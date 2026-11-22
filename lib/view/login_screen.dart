import 'package:fluey/core/di/providers.dart';
import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/custom_input_field.dart';
import 'package:fluey/view_model/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _trustDevice = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both work email and password.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).login(
          email: email,
          password: password,
          mode: 'super_admin',
        );

    if (!mounted) return;

    if (success) {
      final session = ref.read(authProvider).session;
      final homeScreen = session?.roleStrategy.buildHomeScreen();

      if (homeScreen != null) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) => homeScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 450),
          ),
        );
      }
    } else {
      final errorMessage =
          ref.read(authProvider).error ?? 'Authentication failed.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    final deviceHeight = deviceSize.height;
    final deviceWidth = deviceSize.width;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.028),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // --- HEADER SECTION ---
                const Image(image: AssetImage('images/logo.png')),
                const SizedBox(height: 16),

                const Text(
                  'Admin Console',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Manage enterprise conversations,\ntelemetry & live AI voice agents.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- MAIN CARD CONTAINER ---
                Container(
                  margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                  padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.028),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Work Email Input Field
                      CustomInputField(
                        hint: 'Enter work email',
                        label: 'Work Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline,
                        horizontalMarginFactor: 0.04,
                        verticalMarginFactor: 0.008,
                      ),

                      SizedBox(height: deviceHeight * 0.012),

                      // Password Input Field
                      CustomInputField(
                        hint: 'Enter password',
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        horizontalMarginFactor: 0.04,
                        verticalMarginFactor: 0.012,
                      ),

                      // Trust device checkbox & Forgot credentials row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    value: _trustDevice,
                                    activeColor: AppColors.accentBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _trustDevice = val ?? true;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Trust device',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle forgot credentials
                              },
                              child: const Text(
                                'Forgot credentials?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Authenticate Session Button / Loading Indicator
                      authState.isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            )
                          : Button(
                              label: 'Authenticate Session →',
                              onTap: _handleLogin,
                              horizontalMarginFactor: 0.04,
                              verticalMarginFactor: 0.0,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // --- FOOTER SECURITY & INFO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, size: 14, color: AppColors.textHint),
                    SizedBox(width: 6),
                    Text(
                      '256-bit TLS Encrypted • SOC2 Type II Certified',
                      style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Version 2.4.1 (Build 4820)',
                      style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          Text('•', style: TextStyle(color: AppColors.textHint)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Powered by Fluey',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: [
                    _buildFooterLink('Privacy'),
                    const Text('•',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 11)),
                    _buildFooterLink('Compliance'),
                    const Text('•',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 11)),
                    _buildFooterLink('System Telemetry'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String title) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textHint,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}