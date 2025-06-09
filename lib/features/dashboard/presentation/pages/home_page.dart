import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/extensions/string_extension.dart';
import 'package:file_hub/core/resources/themes/app_colors.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/features/audio/presentation/pages/audio_listing_page.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/widgets/showing_file_type_dialog.dart';
import 'package:file_hub/features/document/presentation/pages/document_listing_page.dart';
import 'package:file_hub/features/image/presentation/pages/image_listing_page.dart';
import 'package:file_hub/features/video/presentation/pages/video_listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) async {
        if (state.pageState == PageState.success) {
          final selectedType = await showingFileTypeDialog(context, state.selectedType);
          getIt<DashboardBloc>().add(ToggleTypeChangedEvent(selectedType));
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(10).copyWith(bottom: 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => context.read<DashboardBloc>().add(ShowTypeSelectionEvent()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return AppColors.primaryGradient.createShader(bounds);
                      },
                      child: Text(
                        state.selectedType.capitalize(),
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
                flex: 1,
                child: {
                      'audio': const AudioListingPage(),
                      'video': const VideoListingPage(),
                      'image': const ImageListingPage(),
                      'document': const DocumentListingPage(),
                    }[state.selectedType] ??
                    Container(), // Fallback if type is unknown
              ),
            ],
          ),
        );
      },
    );
  }
}
