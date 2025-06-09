// import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerSingleton {
  static final VideoPlayerSingleton _instance = VideoPlayerSingleton._internal();

  factory VideoPlayerSingleton() => _instance;

  VideoPlayerSingleton._internal();

  late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;
  // bool _isInitialized = false;

  Future<void> initialize(String videoUrl) async {
    // if (_isInitialized) return;

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoPlayerController.initialize();

    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: false,
    //   looping: false,
    // );

    // _isInitialized = true;
  }

  VideoPlayerController get videoController => _videoPlayerController;

  // ChewieController? get chewieController => _chewieController;

  void dispose() {
    _videoPlayerController.dispose();
    // _chewieController?.dispose();
    // _isInitialized = false;
  }
}
