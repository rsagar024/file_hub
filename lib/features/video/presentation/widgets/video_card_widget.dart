import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/core/services/video_service/video_page_manager.dart';

class VideoCardWidget extends StatelessWidget {
  final FileModel videoFile;

  const VideoCardWidget({super.key, required this.videoFile});

  static final videoPageManager = getIt<VideoPageManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
            height: 180,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 7),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // image: DecorationImage(image: NetworkImage(videoFile.thumbnail ?? ''), fit: BoxFit.fitWidth),
              image: DecorationImage(image: FileImage(File(videoFile.thumbnail ?? '')), fit: BoxFit.fitWidth),
            ),
            child: Image.asset('assets/icons/ic_video_play.png', height: 50),
          ),
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  // 'Pitah Se Naam Hai Tera | Full Lyrical Video Song | Boss | Akshay Kumar',
                  videoFile.fileName ?? '',
                  style: CustomTextStyles.custom14Regular.copyWith(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset('assets/icons/ic_vertical_dots.png', height: 24),
              ),
            ],
          )
        ],
      ),
    );
  }
}
