import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:vap_uploader/core/common/widgets/animated_button_widget.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/pages/showing_dialog.dart';
import 'package:vap_uploader/features/dashboard/presentation/pages/dashboard_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  static final onBoardingBloc = getIt<OnBoardingBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      listener: (context, state) {
        if (state.pageState == PageState.success) {
          showingDialog(context);
        } else if (state.pageState == PageState.loading) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              left: 100,
              bottom: 100,
              child: Image.asset(ImageResources.imageSpline),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            const RiveAnimation.asset(ImageResources.riveShapes),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            AnimatedPositioned(
              top: 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 260),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            Text(
                              "Your Universal File Hub",
                              style: CustomTextStyles.baseStyle.copyWith(
                                fontSize: 55,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Upload files easily; our system sorts them by type for simple and effortless management.',
                              style: CustomTextStyles.custom14Regular,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                      AnimatedButtonWidget(
                        btnAnimationController: onBoardingBloc.btnAnimationController,
                        onPressed: () {
                          onBoardingBloc.add(ToggleActionEvent());
                          context.read<AuthBloc>().add(AuthInitialEvent());
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Access your content directly in the application with built-in players for music, videos, images, and documents—no extra software needed.',
                          style: CustomTextStyles.custom14Regular,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
