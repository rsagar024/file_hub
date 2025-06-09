import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/resources/themes/app_colors.dart';
import 'package:file_hub/features/audio/presentation/widgets/mini_audio_player.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/pages/home_page.dart';
import 'package:file_hub/features/dashboard/presentation/pages/profile_page.dart';
import 'package:file_hub/features/dashboard/presentation/pages/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final dashboardBloc = getIt<DashboardBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  controller: dashboardBloc.pageController,
                  onPageChanged: (index) {
                    dashboardBloc.add(PageChangedEvent(index));
                    dashboardBloc.add(TabChangedEvent(index));
                  },
                  children: const [
                    HomePage(),
                    UploadPage(),
                    ProfilePage(),
                  ],
                ),
                Visibility(
                  visible: state.isMiniPlayerVisible,
                  child: MiniAudioPlayer(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5).copyWith(top: 2),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(color: AppColors.neutral400)),
              gradient: AppColors.surfaceGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dashboardBloc.navIcons
                  .asMap()
                  .entries
                  .map((entry) => GestureDetector(
                        onTap: () => dashboardBloc.add(TabChangedEvent(entry.key)),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: state.tabIndex == entry.key ? Colors.white24 : Colors.transparent,
                          child: SvgPicture.asset(
                            dashboardBloc.navIcons[entry.key],
                            height: 40,
                            colorFilter: state.tabIndex == entry.key ? null : ColorFilter.mode(Colors.grey[600]!, BlendMode.modulate),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
