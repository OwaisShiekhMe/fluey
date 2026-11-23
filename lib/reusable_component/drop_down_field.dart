import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A themed dropdown field matching the Inventa Figma design.
///
/// White-filled, rounded-corner dropdown with the same border and focus
/// treatment as [CustomInputField].
class Dropdownfield extends StatefulWidget {
  final String label;
  final List<String> options;
  final Function(String?)? onChanged;
  final String initialValue;

  const Dropdownfield({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<Dropdownfield> createState() => _DropdownfieldState();
}

class _DropdownfieldState extends State<Dropdownfield> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: DropdownButtonFormField<String>(
        initialValue: widget.initialValue,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textHint,
        ),
        dropdownColor: AppColors.cardWhite,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cardWhite,
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
        ),
        items: widget.options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }
}
