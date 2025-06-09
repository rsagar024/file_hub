import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatefulWidget {
  final String? fileUrl;
  final bool isVideo;
  final bool isBottomWidgetVisible;

  const VideoPreviewPage({super.key, this.fileUrl, this.isVideo = true, this.isBottomWidgetVisible = true});

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController? _videoController;
  final TextEditingController _captionController = TextEditingController();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.fileUrl!))
        ..initialize().then((_) {
          setState(() {});
        })
        ..addListener(() {
          setState(() {
            _isPlaying = _videoController!.value.isPlaying;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.isVideo
                  ? () {
                      setState(() {
                        _isPlaying ? _videoController!.pause() : _videoController!.play();
                      });
                    }
                  : null,
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
        // _buildSeekBar(),
      ],
    );
  }

  Widget _buildSeekBar() {
    final duration = _videoController?.value.duration ?? Duration.zero;
    final position = _videoController?.value.position ?? Duration.zero;

    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
          thumbColor: Colors.red,
          activeColor: Colors.green,
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

              ),
              Text(
                _formatDuration(duration),
                // style: LexendTextStyles.lexend11Medium.copyWith(color: ColorPalette.gray500),
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
