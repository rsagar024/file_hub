import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageCardSkeletonWidget extends StatelessWidget {
  final double aspectRatio;
  final BoxConstraints constraints;

  const ImageCardSkeletonWidget({
    super.key,
    required this.aspectRatio,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      enabled: true,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(constraints.maxWidth * 0.02),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
