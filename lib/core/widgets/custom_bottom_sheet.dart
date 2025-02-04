import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../styles/text_styles.dart';
import 'glass_card.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final VoidCallback? onClose;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
          onClose?.call();
        }
      },
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: GlassCard(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 300),
                  ),
              Text(
                title,
                style: AppTextStyles.h3,
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 300),
                    delay: const Duration(milliseconds: 200),
                  ),
              const SizedBox(height: 16),
              Expanded(
                child: child.animate().fadeIn(
                      duration: const Duration(milliseconds: 300),
                      delay: const Duration(milliseconds: 400),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    double? height,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomBottomSheet(
        title: title,
        child: child,
        height: height,
        onClose: onClose,
      ),
    );
  }
}
