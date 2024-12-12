import 'package:flutter/material.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class FileTypeDropdownWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const FileTypeDropdownWidget({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 30),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        _buildPopupMenuItem('audio', 'Audio'),
        _buildPopupMenuItem('video', 'Video'),
        _buildPopupMenuItem('image', 'Image'),
        _buildPopupMenuItem('document', 'Document'),
      ],
      onSelected: onTypeChanged,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return AppColors.primaryGradient.createShader(bounds);
            },
            child: Text(
              selectedType.capitalize(),
              style: CustomTextStyles.baseStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 5),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return AppColors.primaryGradient.createShader(bounds);
            },
            child: const Icon(Icons.keyboard_arrow_down, size: 30),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        label,
        style: CustomTextStyles.baseStyle.copyWith(
          fontSize: 16,
          fontWeight: selectedType == value ? FontWeight.w600 : FontWeight.w400,
          color: selectedType == value ? AppColors.primary : Colors.black,
        ),
      ),
    );
  }
}
