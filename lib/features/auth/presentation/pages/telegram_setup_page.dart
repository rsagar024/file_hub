import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/remote/telegram_client.dart';
import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/core/utilities/custom_snackbar.dart';
import 'package:file_hub/features/auth/presentation/bloc/telegram_bloc/telegram_bloc.dart';
import 'package:file_hub/features/auth/presentation/widgets/shadow_button_widget.dart';
import 'package:file_hub/features/auth/presentation/widgets/showing_telegram_setup_popup.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class TelegramSetupPage extends StatefulWidget {
  const TelegramSetupPage({super.key});

  @override
  State<TelegramSetupPage> createState() => _TelegramSetupPageState();
}

class _TelegramSetupPageState extends State<TelegramSetupPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TelegramBloc, TelegramState>(
      listener: (context, state) {
        if (state.authState == AuthState.phoneNumber) {
          showingTelegramSetupPopup(context);
        } else if (state.authState == AuthState.otp) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          showingTelegramSetupPopup(context, otpWidget: true);
        } else if (state.authState == AuthState.failure) {
          CustomSnackbar.show(context: context, message: state.errorMessage ?? '', type: SnackbarType.error);
        } else if (state.authState == AuthState.success) {
          Navigator.pop(context);
          CustomSnackbar.show(context: context, message: 'Authorization Successful', type: SnackbarType.success);
          context.read<DashboardBloc>().add(DashboardInitialEvent());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [Colors.white.withOpacity(0.6), Colors.blue.withRed(2)],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(ImageResources.lottieTelegram),
                Text('Telegram', style: CustomTextStyles.baseStyle.copyWith(fontSize: 30, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Text(
                  'Set up your Telegram Account to upload and access all your files anytime, anywhere—fast and hassle-free!',
                  style: CustomTextStyles.custom14Regular,
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 4),
                ShadowButtonWidget(
                  text: 'Setup Telegram',
                  onTap: () {
                    context.read<TelegramBloc>().add(AuthorizationUpdatesEvent());
                  },
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetTelegram() async {
    final telegram = getIt<TelegramClient>();
    telegram.close();
    await telegram.initialize();
  }
}
