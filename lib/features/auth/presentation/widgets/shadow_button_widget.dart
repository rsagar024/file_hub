import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:flutter/material.dart';

class ShadowButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const ShadowButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 3, offset: Offset.fromDirection(10, -8)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(text, style: CustomTextStyles.custom16Bold.copyWith(color: Colors.blue.withRed(2))),
      ),
    );
  }
}
