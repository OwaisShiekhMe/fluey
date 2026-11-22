import 'package:flutter/material.dart';
import 'app_colors.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final double height;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Widget? trailingIcon;

  const Button({
    super.key,
    required this.label,
    required this.onTap,
    this.horizontalMarginFactor = 0.06,
    this.verticalMarginFactor = 0.015,
    this.height = 0.06,
    this.isOutlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final textScaler = MediaQuery.of(context).textScaler;

    final Color resolvedBg = backgroundColor ??
        (isOutlined ? Colors.transparent : AppColors.accentBlue);
    final Color resolvedFg = foregroundColor ??
        (isOutlined ? AppColors.accentBlue : AppColors.white);
    final bool showShadow =
        !isOutlined && backgroundColor == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: resolvedBg,
          borderRadius: BorderRadius.circular(
            (screenHeight * 0.06).clamp(14.0, 40.0),
          ),
          border: (isOutlined || borderColor != null)
              ? Border.all(
                  color: borderColor ?? AppColors.accentBlue,
                  width: 1.2,
                )
              : null,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        width: double.infinity,
        margin: EdgeInsets.only(
          top: (screenHeight * verticalMarginFactor).clamp(0.0, 16.0),
          left: screenWidth * horizontalMarginFactor,
          right: screenWidth * horizontalMarginFactor,
        ),
        height: (screenHeight * height).clamp(42.0, 56.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: textScaler.scale(14.5),
                  fontWeight: FontWeight.w600,
                  color: resolvedFg,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}