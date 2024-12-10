part of 'on_boarding_bloc.dart';

@immutable
sealed class OnBoardingEvent {}

final class InitialOnBoardingEvent extends OnBoardingEvent {}

final class ToggleActionEvent extends OnBoardingEvent {}

final class CheckAuthStateEvent extends OnBoardingEvent {
  final bool isLoggedIn;
  CheckAuthStateEvent(this.isLoggedIn);
}
