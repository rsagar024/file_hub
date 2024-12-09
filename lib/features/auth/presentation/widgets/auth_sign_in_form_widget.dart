import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:vap_uploader/core/common/widgets/custom_positioned_widget.dart';
import 'package:vap_uploader/core/common/widgets/custom_text_field_widget.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/items/validators.dart';
import 'package:vap_uploader/core/common/widgets/gradient_button_widget.dart';

class AuthSignInFormWidget extends StatelessWidget {
  const AuthSignInFormWidget({super.key});

  static final authBloc = getIt<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Stack(
            children: [
              Form(
                key: authBloc.signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldWidget(
                      controller: authBloc.emailController,
                      label: 'Email',
                      hint: 'Enter your email id',
                      prefixIcon: 'assets/images/email.svg',
                      validator: (value) => Validators.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextFieldWidget(
                      controller: authBloc.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: 'assets/images/password.svg',
                      validator: (value) => Validators.validatePassword(value),
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 15),
                      child: GradientButtonWidget(
                        onPressed: () => authBloc.add(AuthSignInEvent()),
                        text: 'Sign In',
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isShowLoading)
                CustomPositionedWidget(
                  child: RiveAnimation.asset(
                    'assets/rives/check.riv',
                    fit: BoxFit.cover,
                    onInit: (artboard) => authBloc.add(CheckRiveInitEvent(artboard)),
                  ),
                ),
              if (state.isShowConfetti)
                CustomPositionedWidget(
                  scale: 6,
                  child: RiveAnimation.asset(
                    "assets/rives/confetti.riv",
                    fit: BoxFit.cover,
                    onInit: (artboard) => authBloc.add(ConfettiRiveInitEvent(artboard)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
