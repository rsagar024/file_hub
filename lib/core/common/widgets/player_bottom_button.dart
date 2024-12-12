import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class PlayerBottomButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const PlayerBottomButton({
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
