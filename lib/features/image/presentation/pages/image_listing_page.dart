import 'package:flutter/material.dart';
import 'package:vap_uploader/features/image/presentation/widgets/image_card_widget.dart';

class ImageListingPage extends StatelessWidget {
  const ImageListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 20,
      itemBuilder: (context, index) {
        return const ImageCardWidget();
      },
    );
  }
}
