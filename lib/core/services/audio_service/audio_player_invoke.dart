import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/services/audio_service/media_item_converter.dart';
import 'package:vap_uploader/core/services/audio_service/audio_page_manager.dart';

DateTime playerTapTime = DateTime.now();

bool get isProcessForPlay {
  return DateTime.now().difference(playerTapTime).inMilliseconds > 600;
}

Timer? debounce;

void audioPlayerPlayProcessDebounce(List songsList, int index) {
  debounce?.cancel();
  debounce = Timer(const Duration(milliseconds: 600), () {
    AudioPlayerInvoke.init(songsList: songsList, index: index);
  });
}

class AudioPlayerInvoke {
  static final audioPageManager = getIt<AudioPageManager>();

  static Future<void> init({
    required List songsList,
    required int index,
    bool fromMiniPlayer = false,
    bool shuffle = false,
    String? playlistBox,
  }) async {
    final int globalIndex = index < 0 ? 0 : index;
    final List finalList = songsList.toList();
    if (shuffle) finalList.shuffle();
    if (!fromMiniPlayer) {
      if (!Platform.isAndroid) {
        await audioPageManager.stop();
      }
      setValues(finalList, globalIndex);
    }
  }

  static Future<void> setValues(
    List arr,
    int index, {
    bool recommend = false,
  }) async {
    final List<MediaItem> queue = [];
    final Map playItem = (arr[index] as FileModel).toJson();
    final Map? nextItem = index == arr.length - 1 ? null : (arr[index + 1] as FileModel).toJson();
    queue.addAll(arr.map(
      (song) => MediaItemConverter.mapToMediaItem((song as FileModel).toJson(), autoPlay: recommend),
    ));
    updateNPlay(queue, index);
  }

  static Future<void> updateNPlay(List<MediaItem> queue, int index) async {
    try {
      await audioPageManager.setShuffleMode(AudioServiceShuffleMode.none);
      await audioPageManager.adds(queue, index);
      await audioPageManager.playAs();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
