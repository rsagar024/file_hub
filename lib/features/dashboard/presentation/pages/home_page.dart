import 'package:flutter/material.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/features/audio/presentation/pages/music_listing_page.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/showing_file_type_dialog.dart';
import 'package:vap_uploader/features/document/presentation/pages/document_listing_page.dart';
import 'package:vap_uploader/features/image/presentation/pages/image_listing_page.dart';
import 'package:vap_uploader/features/video/presentation/pages/video_listing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedType = 'audio';

  void _handleTypeChange(String newType) {
    setState(() {
      _selectedType = newType;
    });
  }

  Future<void> _showTypeSelection() async {
    final selectedType = await showingFileTypeDialog(context, _selectedType);
    if (selectedType != null) {
      _handleTypeChange(selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(10).copyWith(bottom: 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showTypeSelection,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return AppColors.primaryGradient.createShader(bounds);
                  },
                  child: Text(
                    _selectedType.capitalize(),
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
          ),
          const SizedBox(height: 10),
          Flexible(
            child: {
                  'audio': const MusicListingPage(),
                  'video': const VideoListingPage(),
                  'image': const ImageListingPage(),
                  'document': const DocumentListingPage(),
                }[_selectedType] ??
                Container(), // Fallback if type is unknown
          ),
        ],
      ),
    );
  }
}
