part of 'auth_bloc.dart';

@immutable
class AuthState {
  final PageState pageState;
  final String? errorMessage;
  final SMITrigger? error;
  final SMITrigger? success;
  final SMITrigger? reset;
  final SMITrigger? confetti;
  final bool isShowLoading;
  final bool isShowConfetti;

  const AuthState({
    this.pageState = PageState.initial,
    this.errorMessage,
    this.error,
    this.success,
    this.reset,
    this.confetti,
    this.isShowLoading = false,
    this.isShowConfetti = false,
  });

  AuthState resetState() {
    return const AuthState(
      pageState: PageState.initial,
      errorMessage: null,
      error: null,
      success: null,
      reset: null,
      confetti: null,
      isShowLoading: false,
      isShowConfetti: false,
    );
  }

  AuthState copyWith({
    PageState? pageState,
    String? errorMessage,
    SMITrigger? error,
    SMITrigger? success,
    SMITrigger? reset,
    SMITrigger? confetti,
    bool? isShowLoading,
    bool? isShowConfetti,
  }) {
    return AuthState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
      success: success ?? this.success,
      reset: reset ?? this.reset,
      confetti: confetti ?? this.confetti,
      isShowLoading: isShowLoading ?? this.isShowLoading,
      isShowConfetti: isShowConfetti ?? this.isShowConfetti,
    );
  }
}
