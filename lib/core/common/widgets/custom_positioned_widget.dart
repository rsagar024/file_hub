import 'package:flutter/material.dart';

class CustomPositionedWidget extends StatelessWidget {
  final double scale;
  final Widget child;

  const CustomPositionedWidget({super.key, this.scale = 1, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(flex: 2),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(scale: scale, child: child),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
