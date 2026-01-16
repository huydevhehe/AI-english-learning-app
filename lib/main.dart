import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

// AUTH
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/pages/login_page.dart';

// PROFILE
import 'features/profile/data/datasource/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/domain/usecases/upload_avatar_usecase.dart';
import 'features/profile/presentation/state/profile_notifier.dart';

// ROOT APP
import 'app_root.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

// THEME
import 'core/theme/theme_controller.dart';
import 'core/theme/app_theme.dart';

// STREAK
import 'features/streak/controllers/streak_controller.dart';
import 'features/chatbox/controller/chat_controller.dart';
import 'core/widgets/global_chat_button.dart';
import 'core/navigation/app_navigator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ❌ KHÔNG SEED DATA TRONG RELEASE (gây crash khi lên Play)
  // await SeedRunner.runReadingSeedOnce();
  // await SeedRunner.runVocabSeedOnce();
  // await SeedRunner.runVocabTopicSeedOnce();
  // await SeedRunner.runListeningSeedOnce();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AUTH
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),

        // THEME
        ChangeNotifierProvider(
          create: (_) => ThemeController()..load(),
        ),

        // STREAK
        ChangeNotifierProvider(
          create: (_) => StreakController(),
        ),

        // PROFILE
        ChangeNotifierProvider(
          create: (_) {
            final dataSource = ProfileRemoteDataSource(
              firestore: FirebaseFirestore.instance,
              storage: FirebaseStorage.instance,
            );

            final repo = ProfileRepositoryImpl(
              remoteDataSource: dataSource,
            );

            return ProfileNotifier(
              getProfileUseCase: GetProfileUseCase(repo),
              updateProfileUseCase: UpdateProfileUseCase(repo),
              uploadAvatarUseCase: UploadAvatarUseCase(repo),
            );
          },
        ),
        // CHATBOX
ChangeNotifierProvider(
  create: (_) => ChatController(),
),

      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
             navigatorKey: appNavigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const RootScreen(),
            
          );
        },
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool? hasSeenOnboard;
  String? _loadedUid; // ✅ đảm bảo load profile 1 lần duy nhất

  @override
  void initState() {
    super.initState();
    _loadOnboardStatus();
  }

  Future<void> _loadOnboardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    hasSeenOnboard = prefs.getBool("hasSeenOnboard") ?? false;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final auth = context.read<AuthController>();
    final user = auth.user;

    // ✅ Load profile CHỈ 1 LẦN – KHÔNG gọi trong build()
    if (user != null && _loadedUid != user.uid) {
      _loadedUid = user.uid;
      context.read<ProfileNotifier>().loadProfile(user.uid);
    }
  }

 @override
Widget build(BuildContext context) {
  final auth = context.watch<AuthController>();

  // Chưa đăng nhập
  if (auth.user == null) {
    return const LoginPage();
  }

  return Consumer<ProfileNotifier>(
    builder: (context, notifier, _) {
      final state = notifier.state;

      if (state.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (state.error != null) {
        return Scaffold(
          body: Center(
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
        );
      }

      if (state.profile == null) {
        return const Scaffold(
          body: Center(child: Text("Đang tải hồ sơ...")),
        );
      }

      // ✅ LUÔN HIỆN ONBOARDING (KHÔNG CHECK GÌ CẢ)
      return const OnboardingPage();
    },
  );
}
}
