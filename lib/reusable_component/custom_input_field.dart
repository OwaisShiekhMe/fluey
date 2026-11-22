import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A themed text input field matching the Inventa Figma design.
///
/// White-filled, rounded-corner input with light grey borders that turn
/// accent-blue on focus. Label and icons follow the same focus-aware
/// colour logic.
class CustomInputField extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final double horizontalMarginFactor;
  final double verticalMarginFactor;

  const CustomInputField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.horizontalMarginFactor = 0.06,
    this.verticalMarginFactor = 0.012,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool focused = _focusNode.hasFocus;

    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * widget.verticalMarginFactor,
        left: screenWidth * widget.horizontalMarginFactor,
        right: screenWidth * widget.horizontalMarginFactor,
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: focused ? AppColors.accentBlue : AppColors.textHint,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: focused ? AppColors.accentBlue : AppColors.textHint,
                  size: 20,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  onPressed: widget.onSuffixTap,
                  icon: Icon(
                    widget.suffixIcon,
                    color: focused ? AppColors.accentBlue : AppColors.textHint,
                    size: 20,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.borderFocused,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: AppColors.cardWhite,
        ),
      ),
    );
  }
}
