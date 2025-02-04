import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/glass_card.dart';

class GameScore extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onPauseTap;
  final bool isPaused;

  const GameScore({
    Key? key,
    required this.score,
    required this.highScore,
    required this.onPauseTap,
    required this.isPaused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En Yüksek Skor
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'En Yüksek',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    highScore.toString(),
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 32.w),

              Container(
                width: 2,
                height: 40.h,
                color: Colors.white24,
              ),

              SizedBox(width: 32.w),

              // Mevcut Skor
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skor',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 32.w),

              Container(
                width: 2,
                height: 40.h,
                color: Colors.white24,
              ),

              SizedBox(width: 32.w),

              // Duraklat Butonu
              GestureDetector(
                onTap: onPauseTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Oyun',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                    Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      color: isPaused ? Colors.green : Colors.orange,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
