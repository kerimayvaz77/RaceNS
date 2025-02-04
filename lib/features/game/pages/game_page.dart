import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/styles/text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/game_score.dart';
import '../widgets/game_over_dialog.dart';
import '../models/player_car.dart';
import '../models/enemy_car.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late AnimationController _gameController;
  late PlayerCar _playerCar;
  final List<EnemyCar> _enemyCars = [];
  double _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;
  bool _isPaused = false;
  double? _screenWidth;
  bool _isGameStarted = false;
  final String _highScoreKey = 'high_score';

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _initGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    if (!_isGameStarted && _screenWidth != null) {
      _isGameStarted = true;
      _startGame();
    }
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt(_highScoreKey) ?? 0;
    });
    debugPrint('En yüksek skor yüklendi: $_highScore');
  }

  Future<void> _updateHighScore(int newScore) async {
    if (newScore > _highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, newScore);
      setState(() {
        _highScore = newScore;
      });
      debugPrint('Yeni en yüksek skor kaydedildi: $_highScore');
    }
  }

  void _initGame() {
    _gameController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_updateGame);

    _playerCar = PlayerCar();
    _score = 0;
    _isGameOver = false;
    _isPaused = false;
    _enemyCars.clear();
    debugPrint('Oyun başlangıç durumuna getirildi');
  }

  void _startGame() {
    debugPrint('Oyun başlatılıyor. Ekran genişliği: $_screenWidth');
    _gameController.forward();
    _spawnEnemyCar();
  }

  bool _canSpawnEnemyCar(EnemyCar newEnemy) {
    const double minDistance = 150.0; // Minimum güvenli mesafe

    for (var existingEnemy in _enemyCars) {
      double distance =
          (existingEnemy.position.dy - newEnemy.position.dy).abs();
      if (existingEnemy.position.dx == newEnemy.position.dx &&
          distance < minDistance) {
        debugPrint('Çok yakın mesafede başka bir araç var, spawn iptal edildi');
        return false;
      }
    }
    return true;
  }

  void _spawnEnemyCar() {
    if (_isGameOver || _isPaused || _screenWidth == null) {
      debugPrint('Düşman araba oluşturulamadı: oyun durumu uygun değil');
      return;
    }

    debugPrint('Yeni düşman araba oluşturuluyor...');
    final enemy = EnemyCar();
    enemy.initializePosition(_screenWidth!);

    // Eğer yeni araç için uygun pozisyon varsa ekle
    if (_canSpawnEnemyCar(enemy)) {
      setState(() {
        _enemyCars.add(enemy);
        debugPrint('Yeni düşman araba eklendi. Toplam: ${_enemyCars.length}');
      });
    }

    // Sonraki arabayı spawn et
    if (!_isGameOver && !_isPaused) {
      // Skor arttıkça spawn süresi azalır (oyun zorlaşır)
      int spawnDelay = (2000 - (_score ~/ 100) * 100).clamp(500, 2000);
      Future.delayed(Duration(milliseconds: spawnDelay), _spawnEnemyCar);
      debugPrint('Sonraki spawn süresi: $spawnDelay ms');
    }
  }

  void _updateGame() {
    if (_isPaused || _isGameOver) return;

    setState(() {
      // Oyuncu arabasını güncelle
      _playerCar.update();

      // Düşman arabaları güncelle ve çarpışmaları kontrol et
      for (var i = 0; i < _enemyCars.length; i++) {
        var enemy = _enemyCars[i];

        // Skor arttıkça düşman araçların hızı artar (daha yavaş artış)
        double speedMultiplier = 1.0 + (_score / 2000);
        enemy.adjustSpeed(enemy.baseSpeed * speedMultiplier);
        enemy.update();

        // Oyuncu ile çarpışma kontrolü
        if (_playerCar.checkCollision(enemy)) {
          debugPrint('Oyuncu ile çarpışma tespit edildi!');
          _gameOver();
          return;
        }

        // Diğer düşman arabalarla çarpışma kontrolü
        for (var j = i + 1; j < _enemyCars.length; j++) {
          var otherEnemy = _enemyCars[j];
          if (_checkEnemyCollision(enemy, otherEnemy)) {
            debugPrint('Düşman arabalar arasında çarpışma!');
            // Hızlı olanı yavaşlat
            if (enemy.speed > otherEnemy.speed) {
              enemy.adjustSpeed(otherEnemy.speed);
            } else {
              otherEnemy.adjustSpeed(enemy.speed);
            }
          }
        }
      }

      // Ekrandan çıkan arabaları kaldır
      final initialCount = _enemyCars.length;
      _enemyCars.removeWhere((enemy) => enemy.isOffScreen());
      final removedCount = initialCount - _enemyCars.length;
      if (removedCount > 0) {
        debugPrint(
            '$removedCount araba ekrandan çıktı. Kalan: ${_enemyCars.length}');
      }

      // Skoru güncelle (daha yavaş artış)
      _score += 0.1;
    });
  }

  bool _checkEnemyCollision(EnemyCar car1, EnemyCar car2) {
    const double safeDistance = 100.0;
    return (car1.position.dx == car2.position.dx) &&
        (car1.position.dy - car2.position.dy).abs() < safeDistance;
  }

  void _gameOver() {
    _gameController.stop();
    _isGameOver = true;
    _updateHighScore(_score.toInt());
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: _score.toInt(),
        onRestart: () {
          Navigator.pop(context);
          _resetGame();
        },
        onExit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _resetGame() {
    debugPrint('Oyun tamamen sıfırlanıyor...');
    _gameController.dispose();
    setState(() {
      _isGameStarted = false;
      _enemyCars.clear();
      _score = 0;
      _isGameOver = false;
      _isPaused = false;
      _playerCar = PlayerCar();
      _initGame();
      if (_screenWidth != null) {
        _isGameStarted = true;
        _startGame();
      }
    });
  }

  void _startNewGame() {
    _initGame();
    if (_screenWidth != null) {
      _isGameStarted = true;
      _startGame();
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        debugPrint('Oyun duraklatıldı');
        _gameController.stop();
        _showPauseMenu();
      } else {
        debugPrint('Oyun devam ediyor...');
        _gameController.forward();
      }
    });
  }

  void _showPauseMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple[900]?.withOpacity(0.9),
        title: Text(
          'Oyun Duraklatıldı',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPaused = false;
                  _gameController.forward();
                  debugPrint('Oyun devam ettiriliyor...');
                  _spawnEnemyCar(); // Düşman araç oluşturmayı yeniden başlat
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(200.w, 50.h),
              ),
              child: Text(
                'Devam Et',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(200.w, 50.h),
              ),
              child: Text(
                'Baştan Oyna',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(200.w, 50.h),
              ),
              child: Text(
                'Ana Menüye Dön',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('GamePage dispose ediliyor. Kaynaklar temizleniyor.');
    _gameController.dispose();
    _enemyCars.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          if (!_isGameOver && !_isPaused) {
            _playerCar.setHorizontalPosition(
              _screenWidth!,
              details.localPosition,
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6A1B9A),
                Color(0xFF4A148C),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Oyun alanı
                Positioned.fill(
                  child: CustomPaint(
                    painter: GamePainter(
                      playerCar: _playerCar,
                      enemyCars: _enemyCars,
                    ),
                  ),
                ),

                // Skor
                Positioned(
                  top: 16.h,
                  left: 0,
                  right: 0,
                  child: GameScore(
                    score: _score.toInt(),
                    highScore: _highScore,
                    onPauseTap: _togglePause,
                    isPaused: _isPaused,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final PlayerCar playerCar;
  final List<EnemyCar> enemyCars;

  GamePainter({
    required this.playerCar,
    required this.enemyCars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Yolu çiz
    final roadPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, roadPaint);

    // Yol çizgilerini çiz
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Orta çizgi
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );

    // Kenar çizgileri
    canvas.drawLine(
      Offset(size.width * 0.1, 0),
      Offset(size.width * 0.1, size.height),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.9, 0),
      Offset(size.width * 0.9, size.height),
      linePaint,
    );

    // Düşman arabaları çiz
    for (var enemy in enemyCars) {
      enemy.render(canvas, size);
    }

    // Oyuncu arabasını çiz
    playerCar.render(canvas, size);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
