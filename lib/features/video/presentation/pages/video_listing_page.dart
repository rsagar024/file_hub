import 'package:flutter/material.dart';
import 'package:vap_uploader/features/video/presentation/widgets/video_card_widget.dart';

class VideoListingPage extends StatelessWidget {
  const VideoListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 20,
      itemBuilder: (context, index) {
        return const VideoCardWidget();
      },
    );
  }
}
