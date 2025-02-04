import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../styles/text_styles.dart';

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final IconData? icon;
  final bool isLoading;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: isOutlined
                ? Colors.transparent
                : (backgroundColor ?? theme.colorScheme.primary),
            border: isOutlined
                ? Border.all(color: theme.colorScheme.primary)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(
                    icon,
                    color: isOutlined
                        ? theme.colorScheme.primary
                        : (textColor ?? Colors.white),
                  ),
                  const SizedBox(width: 8),
                ],
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOutlined
                            ? theme.colorScheme.primary
                            : (textColor ?? Colors.white),
                      ),
                    ),
                  )
                else
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: isOutlined
                          ? theme.colorScheme.primary
                          : (textColor ?? Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale(
          duration: const Duration(milliseconds: 100),
          begin: const Offset(1, 1),
          end: const Offset(0.95, 0.95),
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          duration: const Duration(milliseconds: 100),
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeInOut,
        );
  }
}
