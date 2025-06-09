import 'package:file_hub/core/common/models/file_model.dart';
import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/features/audio/presentation/pages/audio_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioCardWidget extends StatelessWidget {
  final FileModel audioModel;
  final VoidCallback onPressed;

  const AudioCardWidget({super.key, required this.audioModel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              onPressed();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioPlayerPage()));
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    audioModel.thumbnail ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white60, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onPressed();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioPlayerPage()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              audioModel.fileName ?? '',
                              style: CustomTextStyles.custom13SemiBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              audioModel.createdBy ?? '',
                              style: CustomTextStyles.custom10Regular,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onPressed,
                      icon: SvgPicture.asset(ImageResources.iconPlayColored, height: 30),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Divider(color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
