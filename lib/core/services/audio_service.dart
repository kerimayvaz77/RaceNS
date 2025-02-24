import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService extends ChangeNotifier with WidgetsBindingObserver {
  static const String _backgroundMusicPath =
      'assets/audio/background_music.mp3';
  static const String _musicEnabledKey = 'music_enabled';

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isInitialized = false;
  bool _wasPlayingBeforePause = false;

  bool get isMusicEnabled => _isMusicEnabled;

  AudioService() {
    _loadMusicState();
    // Observer'ı kaydet
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App yaşam döngüsü durumu değişti: $state');
    switch (state) {
      case AppLifecycleState.paused:
        // Uygulama arka plana geçtiğinde veya ekran kapandığında
        _wasPlayingBeforePause = _backgroundMusicPlayer.playing;
        if (_wasPlayingBeforePause) {
          stopBackgroundMusic();
          debugPrint('Uygulama arka planda: Müzik duraklatıldı');
        }
        break;
      case AppLifecycleState.resumed:
        // Uygulama tekrar açıldığında
        if (_wasPlayingBeforePause && _isMusicEnabled) {
          playBackgroundMusic();
          debugPrint('Uygulama tekrar açıldı: Müzik devam ediyor');
        }
        break;
      default:
        break;
    }
  }

  Future<void> _loadMusicState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMusicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
      debugPrint('Müzik durumu yüklendi: $_isMusicEnabled');
      await _initMusic();
    } catch (e) {
      debugPrint('Müzik durumu yüklenirken hata: $e');
    }
  }

  Future<void> _saveMusicState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_musicEnabledKey, _isMusicEnabled);
      debugPrint('Müzik durumu kaydedildi: $_isMusicEnabled');
    } catch (e) {
      debugPrint('Müzik durumu kaydedilirken hata: $e');
    }
  }

  Future<void> _initMusic() async {
    if (!_isInitialized) {
      await initBackgroundMusic(_backgroundMusicPath);
      _isInitialized = true;
    }
    if (_isMusicEnabled) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> initBackgroundMusic(String assetPath) async {
    try {
      await _backgroundMusicPlayer.setAsset(assetPath);
      await _backgroundMusicPlayer.setLoopMode(LoopMode.all);
      await _backgroundMusicPlayer.setVolume(0.5); // Ses seviyesini ayarla
      debugPrint('Müzik başarıyla yüklendi');
    } catch (e) {
      debugPrint('Müzik yüklenirken hata: $e');
    }
  }

  Future<void> playBackgroundMusic() async {
    if (_isMusicEnabled && _isInitialized) {
      try {
        await _backgroundMusicPlayer.play();
        debugPrint('Müzik çalmaya başladı');
      } catch (e) {
        debugPrint('Müzik çalınırken hata: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (_isInitialized) {
      try {
        await _backgroundMusicPlayer.pause();
        debugPrint('Müzik durduruldu');
      } catch (e) {
        debugPrint('Müzik durdurulurken hata: $e');
      }
    }
  }

  Future<void> toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;
    await _saveMusicState();

    if (_isMusicEnabled) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }

    notifyListeners();
    debugPrint('Müzik durumu değiştirildi: $_isMusicEnabled');
  }

  @override
  void dispose() {
    // Observer'ı kaldır
    WidgetsBinding.instance.removeObserver(this);
    _backgroundMusicPlayer.dispose();
    _isInitialized = false;
    super.dispose();
  }
}
