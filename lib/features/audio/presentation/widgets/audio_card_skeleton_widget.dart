import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';

class AudioCardSkeletonWidget extends StatelessWidget {
  const AudioCardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            enabled: true,
            child: Container(
              height: 61,
              width: 61,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white60, width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      enabled: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 5, top: 10),
                          ),
                          Container(
                            height: 8,
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      enabled: true,
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(ImageResources.iconPlayColored, height: 30),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5),
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
