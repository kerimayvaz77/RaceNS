import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/styles/text_styles.dart';
import 'core/widgets/glass_card.dart';
import 'core/widgets/animated_button.dart';
import 'core/utils/animations.dart';
import 'core/utils/page_transitions.dart';
import 'core/services/audio_service.dart';
import 'features/settings/settings_page.dart';
import 'features/game/pages/game_page.dart';
import 'package:provider/provider.dart';
import 'features/menu/pages/menu_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Tam ekran modu
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Yatay modu devre dışı bırak, sadece dikey mod
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setupDependencies();
  runApp(const MyApp());
}

void setupDependencies() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AudioService>(AudioService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Araba Yarışı',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.deepPurple[900],
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const MenuPage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioService _audioService = GetIt.instance<AudioService>();

  @override
  void initState() {
    super.initState();
    _initBackgroundMusic();
  }

  Future<void> _initBackgroundMusic() async {
    await _audioService
        .initBackgroundMusic('assets/audio/background_music.mp3');
    await _audioService.playBackgroundMusic();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mobil Oyun',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A1B9A), // Koyu mor
              Color(0xFF4A148C), // Daha koyu mor
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppAnimations.fadeInSlide(
                child: Text(
                  'Hoş Geldiniz!',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              AppAnimations.scaleIn(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransitions.slideUp(
                        page: const GamePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6A1B9A),
                  ),
                  child: Text(
                    'Oyunu Başlat',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: const Color(0xFF6A1B9A),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AppAnimations.scaleIn(
                delay: const Duration(milliseconds: 200),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransitions.slideUp(
                        page: const SettingsPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Ayarlar',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
