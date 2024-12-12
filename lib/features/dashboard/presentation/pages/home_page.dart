import 'package:flutter/material.dart';
import 'package:vap_uploader/features/audio/presentation/pages/music_listing_page.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/file_type_dropdown_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(10).copyWith(bottom: 0),
      child: Column(
        children: [
          FileTypeDropdownWidget(
            selectedType: _selectedType,
            onTypeChanged: _handleTypeChange,
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
