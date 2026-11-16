import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'admin@fluey.ai');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••••••');
  
  bool _trustDevice = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    final deviceHeight = deviceSize.height;
    final deviceWidth = deviceSize.width;

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
                Image(image: AssetImage('images/logo.png',),),
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
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: Icons.visibility_off_outlined,
                        horizontalMarginFactor: 0.04,
                        verticalMarginFactor: 0.012,
                      ),
                      
                      // Trust device checkbox & Forgot credentials row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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

                      // Authenticate Session Button
                      Button(
                        label: 'Authenticate Session →',
                        onTap: () {
                          // Handle authentication
                        },
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
                      child: Text('•', style: TextStyle(color: AppColors.textHint)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Powered by Inventa',
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
                    const Text('•', style: TextStyle(color: AppColors.textHint, fontSize: 11)),
                    _buildFooterLink('Compliance'),
                    const Text('•', style: TextStyle(color: AppColors.textHint, fontSize: 11)),
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