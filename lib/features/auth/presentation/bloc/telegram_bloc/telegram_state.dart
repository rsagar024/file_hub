part of 'telegram_bloc.dart';

enum AuthState { initial, phoneNumber, otp, success, error, failure }

@immutable
class TelegramState {
  final PageState pageState;
  final String? errorMessage;
  final AuthState authState;
  final String? countryCode;
  final String? phoneNumber;

  const TelegramState({
    this.pageState = PageState.initial,
    this.errorMessage,
    this.authState = AuthState.initial,
    this.countryCode,
    this.phoneNumber,
  });

  TelegramState resetState() {
    return const TelegramState(
      pageState: PageState.initial,
      errorMessage: null,
      authState: AuthState.initial,
      countryCode: null,
      phoneNumber: null,
    );
  }

  TelegramState copyWith({
    PageState? pageState,
    String? errorMessage,
    AuthState? authState,
    String? countryCode,
    String? phoneNumber,
  }) {
    return TelegramState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      authState: authState ?? this.authState,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
