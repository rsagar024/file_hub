import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/pages/home_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final navigationBloc = getIt<NavigationBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: PageView(
              controller: navigationBloc.pageController,
              onPageChanged: (index) {
                navigationBloc.add(PageChanged(index));
                navigationBloc.add(TabChanged(index));
              },
              children: const [
                HomePage(),
                Center(child: Text('Upload')),
                Center(child: Text('Profile')),
              ],
            ),
            bottomNavigationBar: Container(
              height: 60,
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: navigationBloc.navIcons
                    .asMap()
                    .entries
                    .map((entry) => GestureDetector(
                          onTap: () => navigationBloc.add(TabChanged(entry.key)),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: state.tabIndex == entry.key ? Colors.white24 : Colors.transparent,
                            child: SvgPicture.asset(
                              navigationBloc.navIcons[entry.key],
                              height: 40,
                              colorFilter: state.tabIndex == entry.key ? null : ColorFilter.mode(Colors.grey[600]!, BlendMode.modulate),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
