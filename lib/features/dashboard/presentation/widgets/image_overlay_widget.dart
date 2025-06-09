import 'package:flutter/material.dart';

class ImageOverlay {
  static OverlayEntry? overlayEntry;

  static void show(BuildContext context, {required String imageUrl}) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            overlayEntry?.remove();
            overlayEntry = null;
          },
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  static void hideImagePreview() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
