import 'dart:ui';

import 'package:file_hub/core/common/widgets/gradient_button_widget.dart';
import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/features/auth/presentation/widgets/pin_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;

class AuthPinPage extends StatefulWidget {
  final bool setup;

  const AuthPinPage({super.key, this.setup = true});

  @override
  State<AuthPinPage> createState() => _AuthPinPageState();
}

class _AuthPinPageState extends State<AuthPinPage> {
  final pinField = PinTextFieldWidget();
  late String buttonText;

  @override
  void initState() {
    super.initState();
    buttonText = widget.setup ? 'Setup Pin' : 'Confirm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              left: 100,
              bottom: 100,
              child: Image.asset(ImageResources.imageSpline),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            const RiveAnimation.asset(ImageResources.riveShapes),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/app_logo.png', height: 200),
                Text(
                  widget.setup ? 'Setup 2FA Pin' : 'Welcome back, Sagar',
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.baseStyle.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Text(
                    'Still remember that knock-knock combination we agreed on?',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.custom15Regular,
                  ),
                ),
                const SizedBox(height: 20),
                pinField,
                const SizedBox(height: 70),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: GradientButtonWidget(
                    onPressed: () {
                      print('Pin : ${pinField.controller.text}');
                    },
                    text: buttonText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
