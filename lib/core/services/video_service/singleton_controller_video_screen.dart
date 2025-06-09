// import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingletonControllerVideoScreen extends StatefulWidget {
  const SingletonControllerVideoScreen({super.key});

  @override
  State<SingletonControllerVideoScreen> createState() => _SingletonControllerVideoScreenState();
}

class _SingletonControllerVideoScreenState extends State<SingletonControllerVideoScreen> {
  VideoPlayerController? _videoPlayerController;
  // ChewieController? _chewieController;
  String? currentVideoUrl;

  void _initializeVideo(String url) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      // _chewieController?.dispose();
    }

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController!,
    //   autoPlay: true,
    //   looping: false,
    // );

    currentVideoUrl = url;

    setState(() {}); // Refresh UI
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    // _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
