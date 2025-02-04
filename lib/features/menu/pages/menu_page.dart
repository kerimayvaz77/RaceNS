import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/glass_card.dart';
import '../../game/pages/game_page.dart';
import '../../settings/settings_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Tam ekran modunu koru
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Arka plan resmi
            Positioned.fill(
              child: Image.asset(
                'assets/images/racing_background.jpg',
                fit: BoxFit.cover,
                width: screenSize.width,
                height: screenSize.height,
              ),
            ),
            // Karartma katmanı
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            // İçerik
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.h),
                        // Animasyonlu Başlık
                        AnimatedBuilder(
                          animation: _titleController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Text(
                                'YARIŞA\nHAZIR MISIN?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pressStart2p(
                                  fontSize:
                                      screenSize.width < 360 ? 24.sp : 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.purple.withOpacity(
                                          _glowAnimation.value * 0.5),
                                      blurRadius: 20,
                                    ),
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(2.w, 2.h),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30.h),
                        // Butonlar
                        _buildAnimatedButton(
                          context: context,
                          icon: FontAwesomeIcons.play,
                          text: 'OYUNU BAŞLAT',
                          gradient: LinearGradient(
                            colors: [
                              Colors.green[700]!,
                              Colors.green[900]!,
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GamePage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        _buildAnimatedButton(
                          context: context,
                          icon: FontAwesomeIcons.gear,
                          text: 'AYARLAR',
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber[600]!,
                              Colors.amber[900]!,
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        _buildAnimatedButton(
                          context: context,
                          icon: FontAwesomeIcons.rightFromBracket,
                          text: 'ÇIKIŞ',
                          gradient: LinearGradient(
                            colors: [
                              Colors.red[700]!,
                              Colors.red[900]!,
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.purple[900],
                                title: Text(
                                  'Çıkış',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'Oyundan çıkmak istediğinize emin misiniz?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'İPTAL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      SystemNavigator.pop();
                                    },
                                    child: Text(
                                      'ÇIKIŞ',
                                      style: TextStyle(
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
                        ),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      child: Container(
        width: 280.w,
        height: 70.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // İkon ve parlama efekti
                  Stack(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 24.w,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15.w),
                  // Metin
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
