import 'package:fluey/core/di/providers.dart';
import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/custom_input_field.dart';
import 'package:fluey/view_model/center_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CenterRegistration extends ConsumerStatefulWidget {
  const CenterRegistration({super.key});

  @override
  ConsumerState<CenterRegistration> createState() => _CenterRegistrationState();
}

class _CenterRegistrationState extends ConsumerState<CenterRegistration> {
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedCountryCode = '+92';

  static const List<Map<String, String>> _countryCodes = [
    {'tag': 'PK', 'code': '+92'},
    {'tag': 'AE', 'code': '+971'},
    {'tag': 'SA', 'code': '+966'},
    {'tag': 'UK', 'code': '+44'},
    {'tag': 'US', 'code': '+1'},
  ];

  @override
  void dispose() {
    _centerNameController.dispose();
    _adminNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _handleRegisterCenter() async {
    final centerName = _centerNameController.text.trim();
    final primaryContactName = _adminNameController.text.trim();
    final mobileNumber = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();

    if (centerName.isEmpty ||
        primaryContactName.isEmpty ||
        mobileNumber.isEmpty ||
        email.isEmpty) {
      _showSnack(
        'Please provide center name, primary contact, mobile number, and email.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref.read(centerProvider.notifier).registerCenter(
          centerName: centerName,
          primaryContactName: primaryContactName,
          countryCode: _selectedCountryCode,
          mobileNumber: mobileNumber,
          email: email,
          address: address.isEmpty ? null : address,
        );

    if (!mounted) return;

    final state = ref.read(centerProvider);
    if (success && state.lastRegistered != null) {
      _showSnack(state.lastRegistered!.message);
      _centerNameController.clear();
      _adminNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _addressController.clear();
      Navigator.of(context).pop(state.lastRegistered!.center);
    } else {
      _showSnack(state.error ?? 'Failed to register center.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double horizontalPad = (size.width * 0.045).clamp(14.0, 28.0);
    final double sectionGap = (size.height * 0.018).clamp(12.0, 20.0);
    final centerState = ref.watch(centerProvider);

    ref.listen<CenterState>(centerProvider, (previous, next) {
      if (next.error != null &&
          next.error != previous?.error &&
          !next.isLoading) {
        _showSnack(next.error!);
      }
    });

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textDark,
            size: 22,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.graphic_eq_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Centers',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => _showSnack('Tenant onboarding settings'),
              icon: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF475467),
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxContentWidth =
                constraints.maxWidth > 620 ? 580 : constraints.maxWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPad,
                vertical: 10,
              ),
              child: Center(
                child: SizedBox(
                  width: maxContentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FE),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCE5FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: AppColors.accentBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Register New Center',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Enter academy branch information to initialize tenant onboarding, automated speech nodes, and portal credentials.',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF475467),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sectionGap),

                      // Center / Academy Name *
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text.rich(
                            TextSpan(
                              text: 'Center / Academy Name',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Campus ID auto-generated',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      CustomInputField(
                        hint: 'e.g., Aptix Star Gate Campus',
                        label: '',
                        controller: _centerNameController,
                        prefixIcon: Icons.apartment_rounded,
                        horizontalMarginFactor: 0,
                        verticalMarginFactor: 0,
                      ),
                      SizedBox(height: sectionGap),

                      // Primary Administrator / Contact *
                      const Text.rich(
                        TextSpan(
                          text: 'Primary Administrator / Contact',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomInputField(
                        hint: 'e.g., Tariq Mahmood',
                        label: '',
                        controller: _adminNameController,
                        prefixIcon: Icons.person_outline_rounded,
                        horizontalMarginFactor: 0,
                        verticalMarginFactor: 0,
                      ),
                      SizedBox(height: sectionGap),

                      // Mobile / WhatsApp Number *
                      const Text.rich(
                        TextSpan(
                          text: 'Mobile / WhatsApp Number',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: Color(0xFF475467),
                                ),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCountryCode = val);
                                  }
                                },
                                items: _countryCodes.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry['code'],
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF98A2B3),
                                              width: 0.9,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            entry['tag']!,
                                            style: const TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF344054),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          entry['code']!,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.accentBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomInputField(
                              hint: '300 9876543',
                              label: '',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.chat_bubble_outline_rounded,
                              horizontalMarginFactor: 0,
                              verticalMarginFactor: 0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sectionGap),

                      // Official Dispatch & Billing Email *
                      const Text.rich(
                        TextSpan(
                          text: 'Official Dispatch & Billing Email',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomInputField(
                        hint: 'admin@aptixstargate.edu.pk',
                        label: '',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.alternate_email_rounded,
                        horizontalMarginFactor: 0,
                        verticalMarginFactor: 0,
                      ),
                      SizedBox(height: sectionGap),

                      // Center Address (optional in controller)
                      const Text(
                        'Center Address',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomInputField(
                        hint: 'Street address, area, city',
                        label: '',
                        controller: _addressController,
                        prefixIcon: Icons.domain_outlined,
                        horizontalMarginFactor: 0,
                        verticalMarginFactor: 0,
                      ),
                      SizedBox(height: sectionGap),

                      // Acoustic Sync Strip
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.graphic_eq_rounded,
                              size: 18,
                              color: AppColors.accentBlue,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Acoustic Audio Sync: Ready to pair',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sectionGap + 4),

                      // Submit Button / Spinner
                      centerState.isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            )
                          : Button(
                              label: '⊕  Create & Register Center',
                              onTap: _handleRegisterCenter,
                              horizontalMarginFactor: 0,
                              verticalMarginFactor: 0,
                              height: 0.062,
                            ),
                      const SizedBox(height: 10),

                      // Draft Button
                      Button(
                        label: 'Save Onboarding Draft',
                        backgroundColor: const Color(0xFFEFF3FF),
                        foregroundColor: const Color(0xFF1E293B),
                        horizontalMarginFactor: 0,
                        verticalMarginFactor: 0,
                        height: 0.058,
                        onTap: () =>
                            _showSnack('Onboarding draft saved locally.'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}