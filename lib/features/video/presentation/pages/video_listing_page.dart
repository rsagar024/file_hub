// import 'package:chewie/chewie.dart';
import 'package:file_hub/core/services/video_service/video_player_singleton.dart';
import 'package:file_hub/features/video/presentation/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoListingPage extends StatefulWidget {
  const VideoListingPage({super.key});

  @override
  State<VideoListingPage> createState() => _VideoListingPageState();
}

class _VideoListingPageState extends State<VideoListingPage> {
  final List<String> urls = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
  ];

  /*final videoBloc = getIt<VideoBloc>();

  @override
  void initState() {
    super.initState();
    videoBloc.add(InitialVideoEvent());
  }*/



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return VideoPlayerWidget(videoUrl: urls[index]);
      },
    );
    /*return BlocConsumer<VideoBloc, VideoState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.pageState == PageState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.pageState == PageState.error) {
          return const Center(child: Text('Error Occurs'));
        } else {
          if (state.videoModels.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.videoModels.length,
              itemBuilder: (context, index) {
                return VideoCardWidget(
                  videoFile: state.videoModels[index],
                );
              },
            );
          } else {
            return const Center(child: Text('No Files found'));
          }
        }
      },
    );*/
  }
}


/*class VideoCard extends StatefulWidget {
  final String videoUrl;
  const VideoCard({super.key, required this.videoUrl});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  void initState() {
    super.initState();
    VideoPlayerSingleton().initialize(widget.videoUrl).then((_) {
      setState(() {}); // Refresh UI after initialization
    });
  }
  @override
  Widget build(BuildContext context) {
    final videoPlayerSingleton = VideoPlayerSingleton();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: videoPlayerSingleton.videoController != null && videoPlayerSingleton.videoController.value.isInitialized ?
      VideoPlayer(videoPlayerSingleton.videoController) :
      const Center(child: CircularProgressIndicator()),
    );
  }
}*/
