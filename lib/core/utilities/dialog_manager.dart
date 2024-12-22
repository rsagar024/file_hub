import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class DialogManager {
  static final DialogManager _instance = DialogManager._internal();

  factory DialogManager() => _instance;

  DialogManager._internal();

  OverlayEntry? _overlayEntry;

  void showTransparentProgressDialog(BuildContext context, {required String message}) {
    if (_overlayEntry != null) {
      hideTransparentProgressDialog();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        child: Material(
          color: Colors.white54.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(ImageResources.lottieLoading, height: 100, width: 120, fit: BoxFit.fitHeight),
                Text(
                  message,
                  style: CustomTextStyles.custom15Medium.copyWith(color: CupertinoColors.activeBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideTransparentProgressDialog() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
