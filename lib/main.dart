import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/services/audio_service/page_manager.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service.dart';
import 'package:vap_uploader/features/auth/presentation/pages/auth_signin_page.dart';
import 'package:vap_uploader/music_player_page.dart';
// import 'package:vap_uploader/telegram_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TelegramService service = TelegramService();
  late TelegramService service;

  @override
  void initState() {
    super.initState();
    service = getIt<TelegramService>();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var file = File(result.files.single.path!);

      service.uploadFile(file);
    } else {
      print("File picking cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAP Uploader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Scaffold(
      //   body: Center(
      //     child: ElevatedButton(
      //       onPressed: () => pickFile(),
      //       child: Text('Upload File'),
      //     ),
      //   ),
      // ),
      // home: MusicPlayerPage(),
      home: AuthSignInPage(),
    );
  }
}
