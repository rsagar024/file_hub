import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class FileTypeSelectionWidget extends StatefulWidget {
  final String selectedType;

  const FileTypeSelectionWidget({super.key, required this.selectedType});

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

  void _handleTypeSelection(String type) {
    _closePopup();
    Navigator.pop(context, type);
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
                gradient: AppColors.glassGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white54),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select File Type',
                    style: CustomTextStyles.baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  _buildTypeItem(type: 'audio', icon: 'assets/icons/ic_audio.svg'),
                  _buildTypeItem(type: 'video', icon: 'assets/icons/ic_video.svg'),
                  _buildTypeItem(type: 'image', icon: 'assets/icons/ic_image.svg'),
                  _buildTypeItem(type: 'document', icon: 'assets/icons/ic_document.svg'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeItem({required String type, required String icon}) {
    final bool isSelected = widget.selectedType == type;

    return InkWell(
      onTap: () => _handleTypeSelection(type),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 20,
              colorFilter: ColorFilter.mode(isSelected ? AppColors.primary : AppColors.neutral50, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            !isSelected
                ? Text(type.capitalize(), style: const TextStyle(fontSize: 18))
                : ShaderMask(
                    shaderCallback: (Rect bounds) => AppColors.primaryGradient.createShader(bounds),
                    child: Text(type.capitalize(), style: CustomTextStyles.custom18Regular),
                  ),
          ],
        ),
      ),
    );
  }
}
