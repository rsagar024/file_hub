import 'package:flutter/material.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/image_overlay_widget.dart';
import 'package:vap_uploader/features/image/presentation/pages/image_preview_page.dart';
import 'package:vap_uploader/features/image/presentation/widgets/image_card_skeleton_widget.dart';

class ImageCardWidget extends StatelessWidget {
  final FileModel imageModel;
  final double aspectRatio;
  final BoxConstraints constraints;

  const ImageCardWidget({
    super.key,
    required this.imageModel,
    required this.aspectRatio,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewPage(
              imageUrl: imageModel.fileUrl ?? '',
            ),
          ),
        );
      },
      onLongPress: () {
        ImageOverlay.show(context, imageUrl: imageModel.fileUrl ?? '');
      },
      onLongPressUp: () {
        ImageOverlay.hideImagePreview();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(constraints.maxWidth * 0.02),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.network(
            imageModel.fileUrl ?? '',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ImageCardSkeletonWidget(
                aspectRatio: aspectRatio,
                constraints: constraints,
              );
            },
          ),
        ),
      ),
    );
  }
}
