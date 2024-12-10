import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class AnimatedButtonWidget extends StatelessWidget {
  final RiveAnimationController btnAnimationController;
  final VoidCallback onPressed;

  const AnimatedButtonWidget({super.key, required this.btnAnimationController, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 64,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(ImageResources.riveButton, controllers: [btnAnimationController]),
            Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.right_chevron, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    "Let's Start",
                    style: CustomTextStyles.custom15SemiBold.copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
