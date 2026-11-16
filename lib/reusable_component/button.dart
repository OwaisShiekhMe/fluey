import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A themed button matching the Inventa Figma design.
///
/// Renders as a solid bright-blue pill button with white text — no gradients.
/// Supports an optional outlined variant via [isOutlined].
class Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;
  final double height;
  final bool isOutlined;

  const Button({
    super.key,
    required this.label,
    required this.onTap,
    this.horizontalMarginFactor = 0.06,
    this.verticalMarginFactor = 0.015,
    this.height = 0.06,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final textScaler = MediaQuery.of(context).textScaler;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.accentBlue,
          borderRadius: BorderRadius.circular(
            (screenHeight * 0.06).clamp(28.0, 40.0),
          ),
          border: isOutlined
              ? Border.all(color: AppColors.accentBlue, width: 1.5)
              : null,
          boxShadow: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        width: double.infinity,
        margin: EdgeInsets.only(
          top: (screenHeight * verticalMarginFactor).clamp(8.0, 16.0),
          left: screenWidth * horizontalMarginFactor,
          right: screenWidth * horizontalMarginFactor,
        ),
        height: (screenHeight * height).clamp(44.0, 56.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: textScaler.scale(16),
            fontWeight: FontWeight.w600,
            color: isOutlined ? AppColors.accentBlue : AppColors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
