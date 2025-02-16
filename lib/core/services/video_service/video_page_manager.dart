import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum VideoButtonState {
  paused,
  playing,
  loading,
}

class VideoPlayButtonNotifier extends ValueNotifier<VideoButtonState> {
  VideoPlayButtonNotifier() : super(_initialValue);
  static const _initialValue = VideoButtonState.paused;
}

class VideoProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  VideoProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

class VideoProgressNotifier extends ValueNotifier<VideoProgressBarState> {
  VideoProgressNotifier() : super(_initialValue);
  static final _initialValue = VideoProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

class VideoPageManager {
  final currentVideoNotifier = ValueNotifier<String?>(null);
  final playbackStateNotifier = ValueNotifier<VideoButtonState>(VideoButtonState.paused);
  final videoProgressNotifier = VideoProgressNotifier();
  final videoPlayButtonNotifier = VideoPlayButtonNotifier();
  final isInitializedNotifier = ValueNotifier<bool>(false);

  VideoPlayerController? _videoPlayerController;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> initialize(String videoPath) async {
    if (_videoPlayerController != null) {
      await _disposeCurrentVideo();
    }

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
    playbackStateNotifier.value = VideoButtonState.loading;

    try {
      await _videoPlayerController!.initialize();
      playbackStateNotifier.value = VideoButtonState.paused;
      isInitializedNotifier.value = true;

      _listenToPosition();
      _listenToBuffering();
      _listenToDuration();
      currentVideoNotifier.value = videoPath;
    } catch (e) {
      debugPrint("Error initializing video: $e");
      playbackStateNotifier.value = VideoButtonState.paused;
    }
  }

  Future<String?> getVideoDuration(String videoPath) async {
    final tempController = VideoPlayerController.networkUrl(Uri.parse(videoPath));
    try {
      await tempController.initialize();
      final duration = tempController.value.duration;
      await tempController.dispose();
      return '${duration.inMinutes}:${duration.inSeconds % 60}';
    } catch (e) {
      debugPrint("Error fetching video duration: $e");
      return null;
    }
  }

  Future<void> play() async {
    if (_videoPlayerController == null) return;

    await _videoPlayerController!.play();
    playbackStateNotifier.value = VideoButtonState.playing;
  }

  Future<void> pause() async {
    if (_videoPlayerController == null) return;

    await _videoPlayerController!.pause();
    playbackStateNotifier.value = VideoButtonState.paused;
  }

  Future<void> seek(Duration position) async {
    if (_videoPlayerController == null) return;

    await _videoPlayerController!.seekTo(position);
  }

  Future<void> _disposeCurrentVideo() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.pause();
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
      isInitializedNotifier.value = false;
      currentVideoNotifier.value = null;
    }
  }

  Future<void> stop() async {
    await _disposeCurrentVideo();
    playbackStateNotifier.value = VideoButtonState.paused;
    videoProgressNotifier.value = VideoProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    );
  }

  void _listenToPosition() {
    _videoPlayerController!.addListener(() {
      final currentPosition = _videoPlayerController!.value.position;
      final oldState = videoProgressNotifier.value;
      videoProgressNotifier.value = VideoProgressBarState(
        current: currentPosition,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBuffering() {
    _videoPlayerController!.addListener(() {
      final bufferedPosition = _videoPlayerController!.value.buffered.last.end;
      final oldState = videoProgressNotifier.value;
      videoProgressNotifier.value = VideoProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToDuration() {
    _videoPlayerController!.addListener(() {
      final totalDuration = _videoPlayerController!.value.duration;
      final oldState = videoProgressNotifier.value;
      videoProgressNotifier.value = VideoProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration,
      );
    });
  }

  void dispose() {
    _disposeCurrentVideo();
  }
}
