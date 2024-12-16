import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/common/shapes/dotted_border_painter.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 10, bottom: 20),
            //   child: ShaderMask(
            //     shaderCallback: (Rect bounds) {
            //       return AppColors.primaryGradient.createShader(bounds);
            //     },
            //     child: Text(
            //       'Upload',
            //       style: CustomTextStyles.baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
            Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 50),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
              child: CustomPaint(
                painter: DottedBorderPainter(
                  color: AppColors.neutral100,
                  strokeWidth: 0.8,
                  dashPattern: [6, 6],
                ),
                size: Size.infinite,
                isComplex: true,
                willChange: false,
                child: GestureDetector(
                  onTap: () {
                    print('It is clicked');
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 205,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/image_upload.svg', height: 70),
                        const SizedBox(height: 5),
                        Text('Select Your Files', style: CustomTextStyles.custom14Medium),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Upload File',
                style: CustomTextStyles.custom14Regular.copyWith(color: Colors.white),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
