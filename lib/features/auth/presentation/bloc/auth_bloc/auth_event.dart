part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitialEvent extends AuthEvent {}

final class AuthResetEvent extends AuthEvent {}

final class AuthSignInEvent extends AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {}

final class CheckRiveInitEvent extends AuthEvent {
  final Artboard artboard;
  CheckRiveInitEvent(this.artboard);
}

final class ConfettiRiveInitEvent extends AuthEvent {
  final Artboard artboard;
  ConfettiRiveInitEvent(this.artboard);
}
