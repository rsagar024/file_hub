import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/remote/telegram_client.dart';
import 'package:file_hub/core/resources/themes/app_colors.dart';
import 'package:file_hub/core/services/audio_service/audio_page_manager.dart';
import 'package:file_hub/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/on_boarding_bloc/on_boarding_bloc.dart';
import 'package:file_hub/features/auth/presentation/bloc/telegram_bloc/telegram_bloc.dart';
import 'package:file_hub/features/auth/presentation/pages/on_boarding_page.dart';
import 'package:file_hub/features/auth/presentation/pages/telegram_setup_page.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:file_hub/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:file_hub/features/image/presentation/bloc/image_bloc.dart';
import 'package:file_hub/features/video/presentation/bloc/video_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: 'assets/config/.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );*/

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? userId;

  @override
  void initState() {
    super.initState();
    getIt<AudioPageManager>().init();
    initialization();
  }

  Future<void> initialization() async {
    await Permission.storage.request();
    userId = await getIt<TelegramClient>().getMyUserId();
    setState(() {});
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
        BlocProvider(create: (context) => getIt<TelegramBloc>()),
      ],
      child: MaterialApp(
        title: 'File Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
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
                if (userId != null) {
                  context.read<DashboardBloc>().add(DashboardInitialEvent());
                  return const DashboardPage();
                } else {
                  return const TelegramSetupPage();
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            }
            return const OnBoardingPage();
          },
        ),
      ),
    );
  }
}
