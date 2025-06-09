import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:file_hub/core/utilities/file_type_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tdlib/td_api.dart' as tda;
import 'package:tdlib/td_client.dart' as tdc;
import 'package:tdlib/td_client.dart';

class TelegramClient {
  late final int _apiId;
  late final String _apiHash;
  late final String _dbEncryptionKey;

  tdc.Client? client;

  static TelegramClient? _instance;

  TelegramClient._() {
    _apiId = int.parse(utf8.decode(base64.decode(dotenv.env['TELEGRAM_API_ID'] ?? '')));
    _apiHash = utf8.decode(base64.decode(dotenv.env['TELEGRAM_API_HASH'] ?? ''));
    _dbEncryptionKey = dotenv.env['TELEGRAM_DB_ENC_KEY'] ?? '';
  }

  factory TelegramClient() {
    _instance ??= TelegramClient._();
    return _instance!;
  }

  /// Initialize Telegram Client
  Future<void> initialize() async {
    try {
      if (client == null) {
        client = tdc.Client.create();
        await client!.initialize();
        await setTdlibParameters();
      }
      // final authState = await client!.send<tda.AuthorizationState>(const tda.GetAuthorizationState());
      // debugPrint("🔄 Current Authorization State: ${authState.runtimeType}");
      //
      // if (authState is tda.AuthorizationStateWaitTdlibParameters) {
      //   debugPrint("🔴 TDLib parameters required, setting now...");
      //   await resetTdlibParameters();
      //   await setTdlibParameters();
      //   await initialize();
      // }
    } catch (e) {
      debugPrint("Error initializing TelegramClient: ${e.toString()}");
    }
  }

  Future<tda.TdObject?> sendCode(String phoneNumber) async {
    if (client == null) return null;
    return await client!.send(tda.SetAuthenticationPhoneNumber(phoneNumber: phoneNumber));
  }

  Future<tda.TdObject?> checkConfirmCode(String code) async {
    if (client == null) return null;
    return await client!.send(tda.CheckAuthenticationCode(code: code));
  }

  Future<int?> getMyUserId() async {
    try {
      if (client == null) {
        debugPrint("🔴 Telegram client is not initialized.");
        return null;
      }
      await setTdlibParameters();
      final authState = await client!.send<tda.AuthorizationState>(const tda.GetAuthorizationState());

      debugPrint('Auth state check : $authState');
      if (authState is tda.AuthorizationStateWaitTdlibParameters) {
        debugPrint("⚠️ Need to set TDLib parameters, setting now...");
        await setTdlibParameters();
      }
      if (authState is tda.AuthorizationStateClosed || authState is tda.AuthorizationStateLoggingOut) {
        debugPrint("🔴 Session expired, need to reinitialize.");
        await initialize();
        return null;
      }
      final me = await client!.send<tda.User>(const tda.GetMe());
      debugPrint('✅ User ID: ${me.id}');
      return me.id;
    } catch (e) {
      debugPrint("⚠️ Error in getMyUserId: $e");
      if (e is TdFunctionException && e.error.code == 401) {
        debugPrint("🔴 Unauthorized! Redirecting to login...");
      }
      await initialize();
      return null;
    }
  }

  /*Future<Map<String, dynamic>> getVideoMetadata(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final mediaInfo = session.getMediaInformation();
      final Map<dynamic, dynamic> infoJson = mediaInfo?.getAllProperties() ?? {};

      int duration = 0;
      int width = 0;
      int height = 0;
      bool supportsStreaming = false;

      final format = infoJson['format'];
      if (format != null && format['duration'] != null) {
        duration = (double.tryParse(format['duration'].toString())?.floor() ?? 0);
      }

      final streams = infoJson['streams'] as List<dynamic>?;
      if (streams != null) {
        for (final stream in streams) {
          if (stream['codec_type'] == 'video') {
            width = stream['width'] ?? 0;
            height = stream['height'] ?? 0;
            break;
          }
        }
      }

      final formatName = (format?['format_name'] as String?)?.toLowerCase() ?? '';
      supportsStreaming = formatName.contains('mp4') || formatName.contains('mov');

      return {
        'duration': duration,
        'width': width,
        'height': height,
        'supportsStreaming': supportsStreaming,
      };
    } catch (e) {
      return {
        'duration': 0,
        'width': 0,
        'height': 0,
        'supportsStreaming': false,
      };
    }
  }

  Future<Map<String, dynamic>> getAudioMetadata(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final mediaInfo = session.getMediaInformation();
      final Map<dynamic, dynamic> infoJson = mediaInfo?.getAllProperties() ?? {};

      int duration = 0;
      String title = '';
      String performer = '';

      final format = infoJson['format'];
      if (format != null && format['duration'] != null) {
        duration = (double.tryParse(format['duration'].toString())?.round() ?? 0);
      }

      final tags = format?['tags'] as Map<dynamic, dynamic>?;
      if (tags != null) {
        title = tags['title']?.toString() ?? ''; // Common tag for title
        performer = tags['artist']?.toString() ?? // Most common tag for artist
            tags['performer']?.toString() ??
            '';
      }

      return {
        'duration': duration,
        'title': title,
        'performer': performer,
      };
    } catch (e) {
      return {
        'duration': 0,
        'title': '',
        'performer': '',
      };
    }
  }*/

  /*Future<void> uploadFileToSavedMessages(File file) async {
    if (client == null) {
      debugPrint("Telegram client is not initialized.");
      return;
    }

    try {} catch (e) {
      int? userId = await getMyUserId();
      if (userId == null) {
        debugPrint("Failed to get user ID.");
        return;
      }
      int savedMessagesChatId = -userId;
      tda.InputFile inputFile = tda.InputFileLocal(path: file.path);
      final mimeType = await FileTypeChecker.getMimeType(file.path);

      if (mimeType.startsWith("image")) {
        debugPrint("Uploading Image to Saved Messages...");
        final imageBytes = await file.readAsBytes();
        final img.Image? decodedImage = img.decodeImage(imageBytes);
        final int width = decodedImage?.width ?? 1080;
        final int height = decodedImage?.height ?? 1920;

        await client!.send(
          tda.SendMessage(
            chatId: savedMessagesChatId,
            inputMessageContent: tda.InputMessagePhoto(
              photo: inputFile,
              addedStickerFileIds: const [],
              width: width,
              height: height,
              showCaptionAboveMedia: false,
              hasSpoiler: false,
            ),
            messageThreadId: 0,
          ),
        );
      } else if (mimeType.startsWith("video")) {
        debugPrint("Uploading Video to Saved Messages...");
        Map<String, dynamic> videoMetadata = await getVideoMetadata(file.path);

        await client!.send(
          tda.SendMessage(
            chatId: savedMessagesChatId,
            inputMessageContent: tda.InputMessageVideo(
              video: inputFile,
              addedStickerFileIds: const [],
              duration: videoMetadata["duration"],
              width: videoMetadata["width"],
              height: videoMetadata["height"],
              supportsStreaming: videoMetadata["supportsStreaming"],
              showCaptionAboveMedia: false,
              hasSpoiler: false,
            ),
            messageThreadId: 0,
          ),
        );
      } else if (mimeType.startsWith("audio")) {
        debugPrint("Uploading Audio to Saved Messages...");
        Map<String, dynamic> audioMetadata = await getAudioMetadata(file.path);

        await client!.send(
          tda.SendMessage(
            chatId: savedMessagesChatId,
            inputMessageContent: tda.InputMessageAudio(
              audio: inputFile,
              duration: audioMetadata["duration"],
              title: audioMetadata["title"],
              performer: audioMetadata["performer"],
            ),
            messageThreadId: 0,
          ),
        );
      } else {
        debugPrint("Uploading Document to Saved Messages...");
        await client!.send(
          tda.SendMessage(
            chatId: savedMessagesChatId,
            inputMessageContent: tda.InputMessageDocument(
              document: inputFile,
              disableContentTypeDetection: false,
            ),
            messageThreadId: 0,
          ),
        );
      }
    }
  }*/

  Future<String?> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    }
    return null;
  }

  Future<String?> getOSVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
    return null;
  }

  Future<void> setTdlibParameters() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final downloadDirectory = await getDownloadsDirectory();

    final String downloadPath = downloadDirectory?.path ?? appDocDir.path;
    final String deviceModel = await getDeviceModel() ?? 'Samsung';
    final String systemVersion = await getOSVersion() ?? '11';

    final parameters = tda.SetTdlibParameters(
      apiId: _apiId,
      apiHash: _apiHash,
      systemLanguageCode: 'en-US',
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      applicationVersion: '1.1.0',
      databaseDirectory: appDocDir.path,
      filesDirectory: downloadPath,
      databaseEncryptionKey: _dbEncryptionKey,
      useChatInfoDatabase: true,
      useFileDatabase: true,
      useMessageDatabase: true,
      useSecretChats: true,
      useTestDc: false,
    );

    try {
      await client!.send(parameters);
    } catch (e) {
      debugPrint("Error sending SetTdlibParameters: ${e.toString()}");
    }
  }

  Future<void> resetTdlibParameters() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final downloadDirectory = await getDownloadsDirectory();

    final String downloadPath = downloadDirectory?.path ?? appDocDir.path;

    try {
      final dbDir = Directory(appDocDir.path);
      final filesDir = Directory(downloadPath);

      if (await dbDir.exists()) {
        await dbDir.delete(recursive: true);
        debugPrint("Deleted database directory: ${dbDir.path}");
      }
      if (await filesDir.exists()) {
        await filesDir.delete(recursive: true);
        debugPrint("Deleted files directory: ${filesDir.path}");
      }
    } catch (e) {
      debugPrint("Error deleting Tdlib directories: ${e.toString()}");
    }
  }

  void close() {
    if (client != null) {
      client!.destroy();
      client = null;
    }
  }
}
