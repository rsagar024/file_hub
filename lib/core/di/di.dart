import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:vap_uploader/core/services/auth_service/auth_service.dart';
import 'package:vap_uploader/core/services/audio_service/page_manager.dart';
import 'package:vap_uploader/core/services/audio_service/audio_handler.dart';
import 'package:vap_uploader/core/services/auth_service/auth_service_impl.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/navigation_bloc.dart';
import 'package:vap_uploader/core/services/telegram_service/telegram_service_impl.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service_impl.dart';
import 'package:vap_uploader/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:vap_uploader/core/services/secure_storage_service/secure_storage_service_impl.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  try {
    _registerBlocs();
    _registerServices();
    await _setupServiceLocator();

    final SecureStorageService service = getIt<SecureStorageService>();
    await service.saveData("botToken", "Nzk0MjU1MjE4ODpBQUhiSWMzZzFaMktHQW52Rmx1c0M4bkwyWWxoaWZhTjhKNA==");
    await service.saveData("chatId", "NjE5NzY4NjMz");
  } catch (e) {
    debugPrint(e.toString());
  }
}

void _registerBlocs() {
  getIt
    ..registerLazySingleton(() => NavigationBloc())
    ..registerLazySingleton(() => AuthBloc())
    ..registerLazySingleton(() => OnBoardingBloc());
}

void _registerServices() {
  getIt
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl())
    ..registerLazySingleton<AuthService>(() => AuthServiceImpl())
    ..registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl(getIt()))
    ..registerLazySingleton<TelegramService>(() => TelegramServiceImpl(getIt()));
}

Future<void> _setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
