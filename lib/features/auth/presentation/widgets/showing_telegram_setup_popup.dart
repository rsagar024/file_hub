import 'package:file_hub/core/common/widgets/countdown_timer_widget.dart';
import 'package:file_hub/core/common/widgets/phone_field/phone_field.dart';
import 'package:file_hub/core/extensions/string_extension.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/features/auth/presentation/bloc/telegram_bloc/telegram_bloc.dart';
import 'package:file_hub/features/auth/presentation/widgets/pin_text_field_widget.dart';
import 'package:file_hub/features/auth/presentation/widgets/shadow_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showingTelegramSetupPopup(
  BuildContext context, {
  bool otpWidget = false,
}) async {
  final pinField = PinTextFieldWidget(length: 5);
  final TextEditingController phoneController = TextEditingController();
  String? code;
  String? phone;
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black45,
    builder: (BuildContext context) {
      return BlocBuilder<TelegramBloc, TelegramState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: StatefulBuilder(builder: (context, setState) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.blueGrey,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            otpWidget ? 'OTP Verification' : "Telegram Setup",
                            style: CustomTextStyles.baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              otpWidget ? 'We\'ve sent the code to your Telegram app for \n${state.countryCode ?? ''} ${state.phoneNumber ?? ''} on your device.' : 'Please confirm your country code and enter your phone number.',
                              style: CustomTextStyles.custom14Regular,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          otpWidget
                              ? pinField
                              : PhoneField(
                                  labelText: 'phone',
                                  controller: phoneController,
                                  selectedDialCode: '91',
                                  isRequired: true,
                                  onValidationChanged: (isValid, countryCode, phoneNumber) {
                                    setState(() {
                                      if (isValid && phoneNumber.isNotNullOrEmpty()) {
                                        code = '+$countryCode';
                                        phone = phoneNumber;
                                      } else {
                                        phone = null;
                                      }
                                    });
                                  },
                                ),
                          if (otpWidget)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: CountdownTimerWidget(
                                onTimerExpire: () {
                                  Navigator.pop(context);
                                  context.read<TelegramBloc>().add(CancelEvent());
                                },
                              ),
                            ),
                          otpWidget
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: ShadowButtonWidget(
                                        text: 'Cancel',
                                        margin: const EdgeInsets.symmetric(vertical: 15),
                                        onTap: () {
                                          Navigator.pop(context);
                                          context.read<TelegramBloc>().add(CancelEvent());
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Flexible(
                                      child: ShadowButtonWidget(
                                        text: 'Verify Otp',
                                        margin: const EdgeInsets.symmetric(vertical: 15),
                                        onTap: () => context.read<TelegramBloc>().add(VerifyOtpEvent(otp: pinField.controller.text)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                )
                              : ShadowButtonWidget(
                                  text: 'Get Otp',
                                  width: 150,
                                  margin: const EdgeInsets.symmetric(vertical: 15),
                                  onTap: () => context.read<TelegramBloc>().add(GetOtpEvent(countryCode: code, phoneNumber: phone)),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );
    },
  );
}
