import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(ImageResources.iconBack),
        ),
        title: Text(
          'Image Preview',
          style: CustomTextStyles.custom17Medium.copyWith(color: Colors.white.withOpacity(0.8)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(ImageResources.iconMore),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.contain),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.only(left: 3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0xFFe2e5e6), blurRadius: 2)],
          ),
          child: Lottie.asset('assets/lotties/download_anim.json'),
        ),
      ),
    );
  }
}
