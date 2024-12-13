import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';

class FileTypeSelectionWidget extends StatefulWidget {
  const FileTypeSelectionWidget({super.key});

  @override
  State<FileTypeSelectionWidget> createState() => _FileTypeSelectionWidgetState();
}

class _FileTypeSelectionWidgetState extends State<FileTypeSelectionWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closePopup() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _closePopup();
        Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _controller,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppColors.fileGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white54),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select File Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_audio.svg',
                          height: 20,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Audio',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_video.svg',
                          height: 20,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Video',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_image.svg',
                          height: 20,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Image',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_document.svg',
                          height: 20,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Document',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
