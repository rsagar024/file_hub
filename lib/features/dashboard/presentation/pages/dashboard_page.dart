import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/custom_bottom_navbar_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            /*body: BlocBuilder<NavigationBloc, NavigationState>(
              buildWhen: (previous, current) => previous.tabIndex != current.tabIndex,
              builder: (context, state) {
                return PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: PageController(initialPage: state.tabIndex),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return AnimatedSwitcher(
                      duration: Duration.zero,
                      child: _buildScreen(index),
                    );
                  },
                );
              },
            ),*/
            body: IndexedStack(
              index: state.tabIndex,
              children: [
                Container(),
                Container(),
                Container(),
              ],
            ),
            /*bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.neutral.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: state.tabIndex,
                onTap: (index) {
                  context.read<NavigationBloc>().add(TabChanged(index));
                },
                backgroundColor: AppColors.background,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.neutral,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.upload_outlined),
                    activeIcon: Icon(Icons.upload),
                    label: 'Upload',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),*/
            bottomNavigationBar: CustomBottomNavBar(),
          );
        },
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
      default:
        return Container();
    }
  }
}
