import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/widgets/auth_sign_in_form_widget.dart';
import 'package:vap_uploader/features/auth/presentation/widgets/auth_sign_up_form_widget.dart';

void showingDialog(BuildContext context, {bool isSignIn = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.white.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24).copyWith(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 30), blurRadius: 60),
              const BoxShadow(color: Colors.black45, offset: Offset(0, 30), blurRadius: 60),
            ],
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.95),
              body: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          isSignIn ? "Sign In" : "Sign Up",
                          style: CustomTextStyles.baseStyle.copyWith(fontSize: 34, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        isSignIn ? const AuthSignInFormWidget() : const AuthSignUpFormWidget(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: RichText(
                              text: TextSpan(
                                text: isSignIn ? 'Create new account ' : 'Already have an account ',
                                style: CustomTextStyles.custom14Regular.copyWith(color: Colors.white60),
                                children: [
                                  TextSpan(
                                    text: isSignIn ? 'Sign Up' : 'Sign In',
                                    style: CustomTextStyles.custom14SemiBold.copyWith(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                        context.read<AuthBloc>().add(AuthInitialEvent());
                                        showingDialog(context, isSignIn: !isSignIn);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              onTap: () {
                                print('It is tapped');
                              },
                              child: Text(
                                "Forgot Password?",
                                style: CustomTextStyles.custom14SemiBold.copyWith(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OR",
                                style: CustomTextStyles.custom14Medium.copyWith(color: Colors.white70),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Sign ${isSignIn ? 'in' : 'up'} with Google, Facebook or Github",
                            style: CustomTextStyles.custom14Regular.copyWith(color: Colors.white60),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(ImageResources.imageGoogle, height: 64, width: 64),
                            ),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(ImageResources.imageFacebook, height: 64, width: 64),
                            ),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(ImageResources.imageGithub, height: 64, width: 64),
                            ),
                          ],
                        ),
                        const SizedBox(height: 46),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                      child: ColoredBox(
                        color: Colors.black,
                        child: GestureDetector(
                          onTap: () {
                            context.read<OnBoardingBloc>().add(InitialOnBoardingEvent());
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}
