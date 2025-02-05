import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/services/audio_service.dart';
import 'features/splash/pages/splash_video_page.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dikey mod kilitlemesi
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Tam ekran modu
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Ses servisi singleton kaydı
  GetIt.I.registerSingleton<AudioService>(AudioService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // iPhone 13 Pro Max boyutları yerine daha genel bir tasarım boyutu
      designSize:
          const Size(375, 812), // iPhone X/11/12/13 serisi için ortalama boyut
      minTextAdapt: true, // Metin boyutlarını otomatik adapte et
      splitScreenMode: false, // Bölünmüş ekran desteğini kapat
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RaceNS',
          theme: AppTheme.lightTheme, // Özelleştirilmiş tema
          builder: (context, widget) {
            // Ekran boyutlarına göre ölçeklendirme
            ScreenUtil.init(context);

            // Güvenli alan kontrolü
            return MediaQuery(
              // Sistem yazı tipi boyutunu yoksay
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: const SplashVideoPage(),
        );
      },
    );
  }
}
