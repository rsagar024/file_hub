part of 'telegram_bloc.dart';

@immutable
sealed class TelegramEvent {}

class TelegramInitialEvent extends TelegramEvent {}

class AuthorizationUpdatesEvent extends TelegramEvent {}

class AuthStateUpdateEvent extends TelegramEvent {
  final tda.AuthorizationState authorizationState;

  AuthStateUpdateEvent(this.authorizationState);
}

class GetOtpEvent extends TelegramEvent {
  final String? countryCode;
  final String? phoneNumber;

  GetOtpEvent({this.countryCode, this.phoneNumber});
}

class VerifyOtpEvent extends TelegramEvent {
  final String? otp;

  VerifyOtpEvent({this.otp});
}

class CancelEvent extends TelegramEvent {}
