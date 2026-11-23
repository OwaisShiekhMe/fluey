import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/custom_input_field.dart';
import 'package:flutter/material.dart';

class CenterRegistration extends StatefulWidget {
  const CenterRegistration({super.key});

  @override
  State<CenterRegistration> createState() => _CenterRegistrationState();
}

class _CenterRegistrationState extends State<CenterRegistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedCountryCode = '+92';
  String _selectedCountryTag = 'PK';

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

  void _handleRegisterCenter() {
    if (_centerNameController.text.trim().isEmpty ||
        _adminNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      _showSnack('Please fill in all required (*) fields.');
      return;
    }

    FocusScope.of(context).unfocus();
    _showSnack('Center "${_centerNameController.text.trim()}" registered.');
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double horizontalPad = (size.width * 0.045).clamp(14.0, 28.0);
    final double sectionGap = (size.height * 0.018).clamp(12.0, 20.0);

    return AppScaffold(
      appBar: _buildAppBar(),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Register New Center Header Card
                        _buildHeaderBanner(),
                        SizedBox(height: sectionGap),

                        // 2. Center / Academy Name * + Campus ID note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildFieldLabel(
                              'Center / Academy Name',
                              isRequired: true,
                            ),
                            const Flexible(
                              child: Text(
                                'Campus ID auto-generated',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF667085),
                                ),
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

                        // 3. Primary Administrator / Contact *
                        _buildFieldLabel(
                          'Primary Administrator / Contact',
                          isRequired: true,
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

                        // 4. Mobile / WhatsApp Number * (Country Picker + Phone Input)
                        _buildFieldLabel(
                          'Mobile / WhatsApp Number',
                          isRequired: true,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCountryCodeDropdown(),
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

                        // 5. Official Dispatch & Billing Email *
                        _buildFieldLabel(
                          'Official Dispatch & Billing Email',
                          isRequired: true,
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

                        // 6. Center Address
                        _buildFieldLabel('Center Address', isRequired: false),
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

                        // 7. Acoustic Audio Sync Status Bar
                        _buildAcousticSyncStrip(),
                        SizedBox(height: sectionGap + 4),

                        // 8. Primary CTA: Create & Register Center
                        Button(
                          label: '⊕  Create & Register Center',
                          onTap: _handleRegisterCenter,
                          horizontalMarginFactor: 0,
                          verticalMarginFactor: 0,
                          height: 0.062,
                        ),
                        const SizedBox(height: 10),

                        // 9. Secondary CTA: Save Onboarding Draft
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

                        // 10. Footer Security & Branding
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    size: 14,
                                    color: Color(0xFF005A8D),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '256-bit AES Tenant Isolation',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475467),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Fluey Multi-Tenant Directory • Powered by Inventa',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF98A2B3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
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
    );
  }

  Widget _buildFieldLabel(String text, {required bool isRequired}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]
            : const [],
      ),
    );
  }

  Widget _buildCountryCodeDropdown() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Color(0xFF475467),
          ),
          onChanged: (value) {
            if (value == null) return;
            final match = _countryCodes.firstWhere((e) => e['code'] == value);
            setState(() {
              _selectedCountryCode = value;
              _selectedCountryTag = match['tag']!;
            });
          },
          items: _countryCodes.map((entry) {
            return DropdownMenuItem<String>(
              value: entry['code'],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF98A2B3),
                        width: 0.9,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      entry['tag']!,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                        letterSpacing: 0.4,
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
    );
  }

  Widget _buildAcousticSyncStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.graphic_eq_rounded,
            size: 18,
            color: AppColors.accentBlue,
          ),
          const SizedBox(width: 10),
          const Expanded(
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
          const SizedBox(width: 8),
          _buildEqualizerBars(),
        ],
      ),
    );
  }

  Widget _buildEqualizerBars() {
    const bars = [
      (height: 8.0, color: Color(0xFF2E5BFF)),
      (height: 13.0, color: Color(0xFFF59E0B)),
      (height: 16.0, color: Color(0xFF1D4ED8)),
      (height: 10.0, color: Color(0xFF92400E)),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bars
          .map(
            (b) => Container(
              width: 3,
              height: b.height,
              margin: const EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                color: b.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )
          .toList(),
    );
  }
}