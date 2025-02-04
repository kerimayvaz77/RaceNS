import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/glass_card.dart';

class GameControls extends StatelessWidget {
  final Function(bool) onAccelerate;
  final Function(bool) onBrake;

  const GameControls({
    Key? key,
    required this.onAccelerate,
    required this.onBrake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fren pedalı
          GestureDetector(
            onTapDown: (_) => onBrake(true),
            onTapUp: (_) => onBrake(false),
            onTapCancel: () => onBrake(false),
            child: GlassCard(
              child: Container(
                width: 100.w,
                height: 100.w,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.stop_circle_outlined,
                      color: Colors.red,
                      size: 40.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'FREN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Gaz pedalı
          GestureDetector(
            onTapDown: (_) => onAccelerate(true),
            onTapUp: (_) => onAccelerate(false),
            onTapCancel: () => onAccelerate(false),
            child: GlassCard(
              child: Container(
                width: 100.w,
                height: 100.w,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.green,
                      size: 40.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'GAZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
