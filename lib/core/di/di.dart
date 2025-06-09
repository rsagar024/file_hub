import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_hub/core/remote/pinning_dio.dart';
import 'package:file_hub/core/remote/telegram_client.dart';
import 'package:file_hub/core/services/audio_service/audio_handler.dart';
import 'package:file_hub/core/services/audio_service/audio_page_manager.dart';
import 'package:file_hub/core/services/auth_service/auth_service.dart';
import 'package:file_hub/core/services/auth_service/auth_service_impl.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service_impl.dart';
import 'package:file_hub/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:file_hub/core/services/secure_storage_service/secure_storage_service_impl.dart';
import 'package:file_hub/core/services/telegram_service/telegram_service.dart';
import 'package:file_hub/core/services/telegram_service/telegram_service_impl.dart';
import 'package:file_hub/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/telegram_bloc/telegram_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:file_hub/features/image/presentation/bloc/image_bloc.dart';
import 'package:file_hub/features/video/presentation/bloc/video_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  try {
    await _setupServiceLocator();
    _registerFirebaseServices();
    _registerSupabaseService();
    await _registerServices();
    _registerBlocs();

    final SecureStorageService service = getIt<SecureStorageService>();
    await service.saveData("botToken", "Nzk0MjU1MjE4ODpBQUhiSWMzZzFaMktHQW52Rmx1c0M4bkwyWWxoaWZhTjhKNA==");
    await service.saveData("chatId", "NjE5NzY4NjMz");
  } catch (e) {
    debugPrint(e.toString());
  }
}

void _registerBlocs() {
  getIt
    ..registerLazySingleton(() => AuthBloc(getIt()))
    ..registerLazySingleton(() => DashboardBloc())
    ..registerLazySingleton(() => UploadBloc(getIt()))
    ..registerLazySingleton(() => ImageBloc(getIt()))
    ..registerLazySingleton(() => AudioBloc(getIt()))
    ..registerLazySingleton(() => VideoBloc(getIt()))
    ..registerLazySingleton(() => TelegramBloc(getIt()))
    ..registerLazySingleton(() => OnBoardingBloc(FirebaseAuth.instance));
}

Future<void> _registerServices() async {
  final telegramClient = TelegramClient();
  await telegramClient.initialize();
  getIt
    ..registerSingleton<TelegramClient>(telegramClient)
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl())
    ..registerLazySingleton<AuthService>(() => AuthServiceImpl(getIt(), getIt()))
    ..registerLazySingleton<TelegramService>(() => TelegramServiceImpl(getIt()))
    ..registerLazySingleton<FirestoreService>(() => FirestoreServiceImpl(getIt(), getIt(), getIt()));
  // ..registerLazySingleton<TelegramService>(() => TelegramServiceImpl(getIt(), getIt()));
}

void _registerFirebaseServices() {
  getIt
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance);
}

void _registerSupabaseService() {
  getIt.registerLazySingleton(() => Supabase.instance.client);
}

Future<void> _setupServiceLocator() async {
  getIt
    ..registerSingleton<AudioHandler>(await initAudioService())
    ..registerSingleton<Dio>(PinningDio.createDio())
    ..registerLazySingleton<AudioPageManager>(() => AudioPageManager());
  // ..registerLazySingleton<VideoPageManager>(() => VideoPageManager())
}
