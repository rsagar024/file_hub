part of 'on_boarding_bloc.dart';

@immutable
sealed class OnBoardingEvent {}

final class InitialOnBoardingEvent extends OnBoardingEvent {}

final class ToggleActionEvent extends OnBoardingEvent {}
