import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../menu/pages/menu_page.dart';

class SplashVideoPage extends StatefulWidget {
  const SplashVideoPage({super.key});

  @override
  State<SplashVideoPage> createState() => _SplashVideoPageState();
}

class _SplashVideoPageState extends State<SplashVideoPage> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      debugPrint('Video yüklenmeye başlıyor...');
      _controller = VideoPlayerController.asset('assets/videos/splash.mp4');

      await _controller.initialize();
      debugPrint('Video başarıyla yüklendi');

      // Video ses ayarı
      await _controller.setVolume(1.0);
      // Loop'u kapat
      await _controller.setLooping(false);

      if (!mounted) return;

      setState(() {});

      // Videoyu başlat
      await _controller.play();
      debugPrint('Video oynatılmaya başlandı');

      // Video süresini al ve süre sonunda menüye geç
      final duration = _controller.value.duration;
      debugPrint('Video süresi: $duration');

      Future.delayed(duration, () {
        debugPrint('Video süresi doldu, ana menüye geçiliyor...');
        _goToMenu();
      });
    } catch (e) {
      debugPrint('Video yüklenirken hata oluştu: $e');
      setState(() {
        _isError = true;
      });
      // Hata durumunda 2 saniye sonra ana menüye geç
      Future.delayed(const Duration(seconds: 2), _goToMenu);
    }
  }

  void _goToMenu() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    }
  }

  @override
  void dispose() {
    debugPrint('Video controller dispose ediliyor...');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_isError) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: _controller.value.isInitialized
            ? Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
      ),
    );
  }
}
