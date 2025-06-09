import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:tuple/tuple.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  AuthBloc(this._authService) : super(const AuthState()) {
    on<AuthInitialEvent>(_onAuthInitial);
    on<AuthResetEvent>(_onAuthReset);
    on<AuthSignUpEvent>(_onAuthSignUp);
    on<AuthSignInEvent>(_onAuthSignIn);
    on<CheckRiveInitEvent>(_onCheckRiveInit);
    on<ConfettiRiveInitEvent>(_onConfettiRiveInit);
  }

  FutureOr<void> _onAuthInitial(AuthInitialEvent event, Emitter<AuthState> emit) {
    nameController.text = '';
    emailController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    add(AuthResetEvent());
  }

  FutureOr<void> _onAuthReset(AuthResetEvent event, Emitter<AuthState> emit) {
    emit(state.resetState());
  }

  FutureOr<void> _onAuthSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isShowLoading: true, pageState: PageState.initial));
    await Future.delayed(const Duration(seconds: 1));
    if (signUpFormKey.currentState!.validate()) {
      Tuple2<bool, String> result = await _authService.signUpUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (result.item1) {
        state.success?.fire();
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isShowLoading: false, isShowConfetti: true));
        await Future.delayed(const Duration(milliseconds: 100));
        state.confetti?.fire();
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(pageState: PageState.success, isShowConfetti: false));
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        state.error?.fire();
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isShowLoading: false, pageState: PageState.error, isShowConfetti: false, errorMessage: result.item2));
        state.reset?.fire();
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      state.error?.fire();
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(isShowLoading: false, pageState: PageState.initial));
      state.reset?.fire();
    }
  }

  Future<void> _onAuthSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isShowLoading: true, pageState: PageState.initial));
    if (signInFormKey.currentState!.validate()) {
      Tuple2<bool, String> result = await _authService.signInUser(
        email: emailController.text,
        password: passwordController.text,
      );

      if (result.item1) {
        state.success?.fire();
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isShowLoading: false, isShowConfetti: true));
        await Future.delayed(const Duration(milliseconds: 100));
        state.confetti?.fire();
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(pageState: PageState.success, isShowConfetti: false));
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        state.error?.fire();
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isShowLoading: false, pageState: PageState.error, isShowConfetti: false, errorMessage: result.item2));
        state.reset?.fire();
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      state.error?.fire();
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isShowLoading: false, pageState: PageState.initial));
      state.reset?.fire();
    }
  }

  FutureOr<void> _onCheckRiveInit(CheckRiveInitEvent event, Emitter<AuthState> emit) {
    StateMachineController? controller = StateMachineController.fromArtboard(event.artboard, 'State Machine 1');

    if (controller != null) {
      event.artboard.addController(controller);

      final error = controller.findInput<bool>('Error') as SMITrigger;
      final success = controller.findInput<bool>('Check') as SMITrigger;
      final reset = controller.findInput<bool>('Reset') as SMITrigger;

      emit(state.copyWith(error: error, success: success, reset: reset));
    }
  }

  FutureOr<void> _onConfettiRiveInit(ConfettiRiveInitEvent event, Emitter<AuthState> emit) {
    StateMachineController? controller = StateMachineController.fromArtboard(event.artboard, "State Machine 1");

    if (controller != null) {
      event.artboard.addController(controller);

      final confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
      emit(state.copyWith(confetti: confetti));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
