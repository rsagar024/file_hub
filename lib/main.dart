import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/services/audio_service/audio_page_manager.dart';
import 'package:vap_uploader/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';
import 'package:vap_uploader/features/auth/presentation/pages/on_boarding_page.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:vap_uploader/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:vap_uploader/features/image/presentation/bloc/image_bloc.dart';
import 'package:vap_uploader/features/video/presentation/bloc/video_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getIt<AudioPageManager>().init();
    initialization();
  }

  Future<void> initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    getIt<AudioPageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<OnBoardingBloc>()),
        BlocProvider(create: (context) => getIt<DashboardBloc>()),
        BlocProvider(create: (context) => getIt<UploadBloc>()),
        BlocProvider(create: (context) => getIt<ImageBloc>()),
        BlocProvider(create: (context) => getIt<AudioBloc>()),
        BlocProvider(create: (context) => getIt<VideoBloc>()),
      ],
      child: MaterialApp(
        title: 'File Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                context.read<DashboardBloc>().add(DashboardInitialEvent());
                return const DashboardPage();
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            return const OnBoardingPage();
          },
        ),
      ),
    );
  }
}
