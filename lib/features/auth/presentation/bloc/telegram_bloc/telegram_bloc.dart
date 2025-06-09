import 'dart:async';

import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/extensions/string_extension.dart';
import 'package:file_hub/core/remote/telegram_client.dart';
import 'package:file_hub/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdlib/td_api.dart' as tda;

part 'telegram_event.dart';
part 'telegram_state.dart';

class TelegramBloc extends Bloc<TelegramEvent, TelegramState> {
  final TelegramClient _telegramClient;

  TelegramBloc(this._telegramClient) : super(const TelegramState()) {
    on<TelegramInitialEvent>(_onTelegramInitial);
    on<AuthorizationUpdatesEvent>(_onAuthorizationUpdates);
    on<AuthStateUpdateEvent>(_onAuthStateUpdate);
    on<GetOtpEvent>(_onGetOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CancelEvent>(_onCancel);
  }

  FutureOr<void> _onTelegramInitial(TelegramInitialEvent event, Emitter<TelegramState> emit) {}

  FutureOr<void> _onAuthorizationUpdates(AuthorizationUpdatesEvent event, Emitter<TelegramState> emit) async {
    try {
      if (_telegramClient.client == null) {
        await _telegramClient.initialize();
      }
      if (_telegramClient.client == null) {
        throw Exception("TDLib client is still null after initialization.");
      }
      var response = await _telegramClient.client!.send(const tda.GetAuthorizationState());
      if (response is tda.AuthorizationStateClosed) {
        debugPrint("🔴 Telegram Authorization State: CLOSED");
        await _handleAuthorizationClosed(emit);
        return;
      }
      if (response is tda.AuthorizationState) {
        add(AuthStateUpdateEvent(response));
      } else {
        throw Exception("Unexpected response type: ${response.runtimeType}");
      }
    } catch (e, stacktrace) {
      debugPrint("❌ Error in _onAuthorizationUpdates: $e\n$stacktrace");
      emit(state.copyWith(authState: AuthState.error, errorMessage: e.toString()));
    }
  }

  Future<void> _handleAuthorizationClosed(Emitter<TelegramState> emit) async {
    try {
      debugPrint("🔄 Restarting Telegram Client...");
      _telegramClient.close(); // Ensure this method exists in your client
      await _telegramClient.initialize();
    } catch (e, stacktrace) {
      debugPrint("❌ Error while restarting Telegram Client: $e\n$stacktrace");
      emit(state.copyWith(authState: AuthState.error, errorMessage: 'Failed to restart Telegram Client.'));
    }
  }

  FutureOr<void> _onAuthStateUpdate(AuthStateUpdateEvent event, Emitter<TelegramState> emit) async {
    switch (event.authorizationState.getConstructor()) {
      case tda.AuthorizationStateWaitTdlibParameters.constructor:
        // add(CancelEvent());
        await _telegramClient.setTdlibParameters();
        add(AuthorizationUpdatesEvent());
        emit(state.copyWith(authState: AuthState.initial));
        break;
      case tda.AuthorizationStateWaitPhoneNumber.constructor:
        emit(state.copyWith(authState: AuthState.phoneNumber));
        break;
      case tda.AuthorizationStateWaitCode.constructor:
        emit(state.copyWith(authState: AuthState.otp));
        break;
      case tda.AuthorizationStateReady.constructor:
        emit(state.copyWith(authState: AuthState.success));
        break;
      case tda.AuthorizationStateClosing.constructor:
        emit(state.copyWith(authState: AuthState.initial));
        break;
      default:
        emit(state.copyWith(authState: AuthState.failure));
        debugPrint("Unhandled Authorization State: ${event.authorizationState.toJson()}");
    }
  }

  FutureOr<void> _onGetOtp(GetOtpEvent event, Emitter<TelegramState> emit) async {
    if (event.countryCode.isNotNullOrEmpty() && event.phoneNumber.isNotNullOrEmpty()) {
      final result = await _telegramClient.sendCode('${event.countryCode}${event.phoneNumber}');
      if (result != null && result.toJson()['@type'] == 'ok') {
        emit(state.copyWith(
          authState: AuthState.otp,
          countryCode: event.countryCode,
          phoneNumber: event.phoneNumber,
        ));
      } else {
        emit(state.copyWith(
          authState: AuthState.failure,
          errorMessage: result!.toJson()['message'],
        ));
      }
    } else {
      emit(state.copyWith(
        authState: AuthState.failure,
        errorMessage: 'Please enter valid phone number',
      ));
    }
  }

  FutureOr<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<TelegramState> emit) async {
    if (event.otp != null && event.otp!.length == 5) {
      final result = await _telegramClient.checkConfirmCode(event.otp!);
      if (result != null && result.toJson()['@type'] == 'ok') {
        getIt<SecureStorageService>().deleteData('last_otp_timestamp');
        emit(state.copyWith(authState: AuthState.success));
      } else {
        emit(state.copyWith(
          authState: AuthState.failure,
          errorMessage: result!.toJson()['message'],
        ));
      }
    } else {
      emit(state.copyWith(
        authState: AuthState.failure,
        errorMessage: 'Please enter valid otp',
      ));
    }
  }

  FutureOr<void> _onCancel(CancelEvent event, Emitter<TelegramState> emit) async {
    getIt<SecureStorageService>().deleteData('last_otp_timestamp');
    if (_telegramClient.client != null) {
      await _telegramClient.client!.send(const tda.Close());
      _telegramClient.client = null; // Reset client instance
    }
    await Future.delayed(const Duration(seconds: 1));
    await _telegramClient.resetTdlibParameters();
    await _telegramClient.setTdlibParameters();
    await _telegramClient.initialize();
  }
}
