import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioPlayerBottomButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const AudioPlayerBottomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(onPressed: onPressed, icon: SvgPicture.asset(icon)),
          Text(title, style: CustomTextStyles.custom8Regular.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}
