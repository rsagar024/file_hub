/*
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:video_player/video_player.dart';

class VideoCardWidget extends StatefulWidget {
  final FileModel videoFile;

  const VideoCardWidget({super.key, required this.videoFile});

  @override
  State<VideoCardWidget> createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  late VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile.fileUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoFile.fileUrl!))
        ..initialize().then((_) {
          setState(() {});
        })
        ..addListener(() {
          setState(() {
            _isPlaying = _videoController!.value.isPlaying;
          });
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying ? _videoController!.pause() : _videoController!.play();
                });
              },
              child: _buildVideoPlayer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 64,
                ),
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
              ),
            ],
          ),
        ),
        _buildSeekbar(),
      ],
    );
  }

  Widget _buildSeekbar() {
    final duration = _videoController?.value.duration ?? Duration.zero;
    final position = _videoController?.value.position ?? Duration.zero;

    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
          thumbColor: Colors.red,
          activeColor: Colors.orange,
          onChanged: (value) {
            _videoController?.seekTo(Duration(milliseconds: value.toInt()));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.grey),
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
*/
