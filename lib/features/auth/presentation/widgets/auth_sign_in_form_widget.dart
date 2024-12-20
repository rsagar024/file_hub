import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:vap_uploader/core/common/widgets/custom_positioned_widget.dart';
import 'package:vap_uploader/core/common/widgets/custom_text_field_widget.dart';
import 'package:vap_uploader/core/common/widgets/gradient_button_widget.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/utilities/custom_snackbar.dart';
import 'package:vap_uploader/core/utilities/validators.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/pages/dashboard_page.dart';

class AuthSignInFormWidget extends StatelessWidget {
  const AuthSignInFormWidget({super.key});

  static final authBloc = getIt<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.pageState == PageState.success) {
          Navigator.pop(context);
          context.read<DashboardBloc>().add(DashboardInitialEvent());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        } else if (state.pageState == PageState.error) {
          CustomSnackbar.show(context: context, message: state.errorMessage ?? '', type: SnackbarType.error);
        }
      },
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
                      prefixIcon: ImageResources.iconEmail,
                      validator: (value) => Validators.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextFieldWidget(
                      controller: authBloc.passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: ImageResources.iconPassword,
                      validator: (value) => Validators.validatePassword(value),
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 15),
                      child: GradientButtonWidget(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          authBloc.add(AuthSignInEvent());
                        },
                        text: 'Sign In',
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isShowLoading)
                CustomPositionedWidget(
                  child: RiveAnimation.asset(
                    ImageResources.riveCheck,
                    fit: BoxFit.cover,
                    onInit: (artboard) => authBloc.add(CheckRiveInitEvent(artboard)),
                  ),
                ),
              if (state.isShowConfetti)
                CustomPositionedWidget(
                  scale: 6,
                  child: RiveAnimation.asset(
                    ImageResources.riveConfetti,
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
