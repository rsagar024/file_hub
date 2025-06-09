import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final FirebaseAuth _firebaseAuth;
  final RiveAnimationController btnAnimationController = OneShotAnimation("active", autoplay: false);

  OnBoardingBloc(this._firebaseAuth) : super(const OnBoardingState()) {
    on<InitialOnBoardingEvent>(_onInitialOnBoarding);
    on<ToggleActionEvent>(_onToggleAction);
  }

  FutureOr<void> _onInitialOnBoarding(InitialOnBoardingEvent event, Emitter<OnBoardingState> emit) {
    emit(state.copyWith(isButtonEnabled: true, pageState: PageState.initial, errorMessage: ''));
  }

  FutureOr<void> _onToggleAction(ToggleActionEvent event, Emitter<OnBoardingState> emit) async {
    if (!state.isButtonEnabled) return;
    emit(state.copyWith(isButtonEnabled: false, pageState: PageState.initial));
    btnAnimationController.isActive = true;
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(pageState: PageState.success, isButtonEnabled: true));
  }
}
