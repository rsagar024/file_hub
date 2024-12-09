import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/nav_bar_item_widget.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomAppBar(
              height: 70,
              padding: EdgeInsets.zero,
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavBarItem(
                    icon: Icons.home,
                    isSelected: state.tabIndex == 0,
                    onTap: () => context.read<NavigationBloc>().add(TabChanged(state.tabIndex)),
                  ),
                  // const SizedBox(width: 40),
                  NavBarItem(
                    icon: Icons.notifications,
                    isSelected: state.tabIndex == 1,
                    onTap: () => context.read<NavigationBloc>().add(TabChanged(state.tabIndex)),
                  ),
                  // const SizedBox(width: 40),
                  NavBarItem(
                    icon: Icons.person,
                    isSelected: state.tabIndex == 2,
                    onTap: () => context.read<NavigationBloc>().add(TabChanged(state.tabIndex)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
