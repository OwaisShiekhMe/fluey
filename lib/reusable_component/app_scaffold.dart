import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A themed scaffold that applies the Inventa design background.
///
/// Replaces the old gradient background with a clean, light-grey scaffold
/// matching the Student Registration Figma design.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor = AppColors.scaffoldBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
