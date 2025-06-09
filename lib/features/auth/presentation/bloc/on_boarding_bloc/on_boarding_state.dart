part of 'on_boarding_bloc.dart';

@immutable
class OnBoardingState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool isButtonEnabled;

  const OnBoardingState({
    this.pageState = PageState.initial,
    this.errorMessage,
    this.isButtonEnabled = true,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, isButtonEnabled];

  OnBoardingState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isButtonEnabled,
  }) {
    return OnBoardingState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
