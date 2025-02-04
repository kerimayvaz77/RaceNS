import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/services/audio_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = GetIt.instance<AudioService>();
  bool _isMusicEnabled = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _isMusicEnabled = _audioService.isMusicEnabled;
    _loadHighScore();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _highScore = prefs.getInt('high_score') ?? 0;
        });
        debugPrint('En yüksek skor yüklendi: $_highScore');
      }
    } catch (e) {
      debugPrint('Skor yüklenirken hata oluştu: $e');
    }
  }

  Future<void> _resetHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('high_score', 0);
    setState(() {
      _highScore = 0;
    });

    // Başarılı mesajı göster
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'En yüksek skor sıfırlandı!',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[900]!,
              Colors.deepPurple[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Başlık ve Geri Butonu
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      GlassCard(
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.angleLeft,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'AYARLAR',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.purple.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Ayarlar Listesi
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      // Müzik Ayarı
                      GlassCard(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.music,
                                        color: Colors.white,
                                        size: 20.w,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'MÜZİK',
                                        style: GoogleFonts.orbitron(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: _isMusicEnabled,
                                    onChanged: (value) async {
                                      setState(() {
                                        _isMusicEnabled = value;
                                      });
                                      await _audioService.toggleMusic();
                                    },
                                    activeColor: Colors.purple[300],
                                    activeTrackColor:
                                        Colors.purple.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Skor Sıfırlama
                      GlassCard(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.trophy,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'EN YÜKSEK SKOR',
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Colors.amber.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _highScore.toString(),
                                  style: GoogleFonts.orbitron(
                                    color: Colors.amber,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.amber.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.purple[900],
                                      title: Text(
                                        'Skoru Sıfırla',
                                        style: GoogleFonts.orbitron(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'En yüksek skoru sıfırlamak istediğinize emin misiniz?',
                                        style: GoogleFonts.orbitron(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'İPTAL',
                                            style: GoogleFonts.orbitron(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _resetHighScore();
                                          },
                                          child: Text(
                                            'SIFIRLA',
                                            style: GoogleFonts.orbitron(
                                              color: Colors.red,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red[700]!,
                                        Colors.red[900]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'SKORU SIFIRLA',
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Hakkında
                      GlassCard(
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.circleInfo,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'HAKKINDA',
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              _buildInfoItem('VERSİYON', '1.0.8'),
                              SizedBox(height: 12.h),
                              _buildInfoItem('GELİŞTİRİCİ', 'Kerim AYVAZ'),
                              SizedBox(height: 12.h),
                              _buildInfoItem('OYUN TÜRÜ', 'Araba Yarışı'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.purple.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontSize: 14.sp,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
