import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    setState(() {
      _isInitialized = true;
    });
    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          if (!_isInitialized)
            Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildSeekBar(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (_isInitialized && !_controller.value.isPlaying)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeekBar() {
    final duration = _controller.value.duration ?? Duration.zero;
    final position = _controller.value.position ?? Duration.zero;

    return Column(
      children: [
        SizedBox(
          height: 20,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 4,
            ),
            child: Slider(
              min: 0,
              max: duration.inMilliseconds.toDouble(),
              value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
              thumbColor: Colors.red,
              activeColor: Colors.green,
              onChanged: (value) {
                _controller.seekTo(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
              ),
              Text(
                _formatDuration(duration),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
