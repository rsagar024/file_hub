import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/features/video/presentation/bloc/video_bloc.dart';
import 'package:vap_uploader/features/video/presentation/pages/video_card_widget.dart';
// import 'package:vap_uploader/features/video/presentation/widgets/video_card_widget.dart';

class VideoListingPage extends StatefulWidget {
  const VideoListingPage({super.key});

  @override
  State<VideoListingPage> createState() => _VideoListingPageState();
}

class _VideoListingPageState extends State<VideoListingPage> {
  final videoBloc = getIt<VideoBloc>();

  @override
  void initState() {
    super.initState();
    videoBloc.add(InitialVideoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoBloc, VideoState>(
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
    );
  }
}
