import 'dart:io';
import 'package:video_player/video_player.dart';

class SingletonVideoPlayer {
  static final SingletonVideoPlayer _instance = SingletonVideoPlayer._internal();
  VideoPlayerController? _controller;

  SingletonVideoPlayer._internal();

  static SingletonVideoPlayer get instance => _instance;

  VideoPlayerController? get controller => _controller;

  Future<VideoPlayerController?> loadVideo(String videoPath) async {
    try {
      // Dispose of the previous controller if it's still active
      if (_controller != null) {
        await _controller!.pause();
        await _controller!.dispose();
      }

      // Create and initialize a new controller
      _controller = VideoPlayerController.file(File(videoPath));
      await _controller!.initialize();
      return _controller!;
    } catch (e) {
      print('Error loading video: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }
  }
}
