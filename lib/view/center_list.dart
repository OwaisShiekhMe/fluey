import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/center_card.dart';
import 'package:fluey/view/center_registration.dart';
import 'package:flutter/material.dart';

class CenterList extends StatefulWidget {
  const CenterList({super.key});

  @override
  State<CenterList> createState() => _CenterListState();
}

class _CenterListState extends State<CenterList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<_CenterInfo> _centers = [
    _CenterInfo(
      code: 'CTR-101',
      name: 'Aptix Star Gate Campus',
      address: 'Main Shahrah-e-Faisal, Karachi',
      contactName: 'Tariq Mahmood',
      contactPhone: '+92 300 9876543',
      studentCount: 450,
      facultyCount: 18,
    ),
    _CenterInfo(
      code: 'CTR-102',
      name: 'Beaconhouse Gulshan E',
      address: 'Block 5, Gulshan-e-Iqbal, Karachi',
      contactName: 'Amina Farooq',
      contactPhone: '+92 321 4455667',
      studentCount: 620,
      facultyCount: 24,
    ),
    _CenterInfo(
      code: 'CTR-103',
      name: 'Roots Millennium Islamabad',
      address: 'Sector F-8/3, Islamabad',
      contactName: 'Kamran Qureshi',
      contactPhone: '+92 333 5566778',
      studentCount: 380,
      facultyCount: 15,
    ),
    _CenterInfo(
      code: 'CTR-104',
      name: 'City School DHA',
      address: 'Sector C, DHA Phase 5, Lahore',
      contactName: 'Nadia Malik',
      contactPhone: '+92 312 8899001',
      studentCount: 120,
      facultyCount: 8,
      isActive: false,
      statusText: 'Pending Review',
    ),
    _CenterInfo(
      code: 'CTR-105',
      name: 'The Educators Johar Town',
      address: 'G-Block, Johar Town, Lahore',
      contactName: 'Bilal Zubair',
      contactPhone: '+92 301 7766554',
      studentCount: 510,
      facultyCount: 20,
    ),
  ];

  List<_CenterInfo> get _filteredCenters {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _centers;

    return _centers.where((center) {
      return center.name.toLowerCase().contains(query) ||
          center.code.toLowerCase().contains(query) ||
          center.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _openCenterRegistration() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CenterRegistration(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final centers = _filteredCenters;

    return AppScaffold(
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: SizedBox(width: double.infinity, child: _buildHeader()),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Column(
                      children: [
                        _buildSearchField(),
                        const SizedBox(height: 8),
                        _buildSummary(),
                        const SizedBox(height: 8),
                        Button(
                          label: 'Register New Center',
                          onTap: _openCenterRegistration,
                          horizontalMarginFactor: 0,
                          verticalMarginFactor: 0,
                          height: 0.055,
                          trailingIcon: const Icon(
                            Icons.add_circle_outline,
                            size: 16,
                            color: Colors.white,
                          ),
                          onSuffixTap: _openCenterRegistration,
                        ),
                        const SizedBox(height: 10),
                        if (centers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              'No centers match your search.',
                              style: TextStyle(color: AppColors.textHint),
                            ),
                          )
                        else
                          ...centers.map(
                            (center) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CenterCard(
                                code: center.code,
                                name: center.name,
                                statusText: center.statusText,
                                address: center.address,
                                contactName: center.contactName,
                                contactPhone: center.contactPhone,
                                studentCount: center.studentCount,
                                facultyCount: center.facultyCount,
                                isActive: center.isActive,
                                onTap: () =>
                                    _showMessage('Opened ${center.name}'),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        const _Footer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFFAF8FF),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 220;
          return Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 20),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
              ),
              if (!compact) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.multitrack_audio,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Expanded(
                child: Text(
                  'Centers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Filter centers',
                onPressed: () => _showMessage('Center filters'),
                icon: const Icon(Icons.tune, size: 20),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: 'Search centers by name or location...',
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textHint),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.textHint,
        ),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                icon: const Icon(Icons.close, size: 16),
              ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return const Row(
      children: [
        Expanded(
          child: _SummaryMetric(
            label: 'TOTAL',
            value: '28',
            detail: 'Hubs',
            valueColor: Color(0xFF1749C5),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _SummaryMetric(
            label: 'ACTIVE',
            value: '26',
            detail: '•',
            valueColor: Color(0xFF0085B8),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _SummaryMetric(
            label: 'PENDING',
            value: '2',
            detail: 'Hold',
            valueColor: Color(0xFF9A5200),
          ),
        ),
      ],
    );
  }
}

class _CenterInfo {
  final String code;
  final String name;
  final String address;
  final String contactName;
  final String contactPhone;
  final int studentCount;
  final int facultyCount;
  final bool isActive;
  final String statusText;

  const _CenterInfo({
    required this.code,
    required this.name,
    required this.address,
    required this.contactName,
    required this.contactPhone,
    required this.studentCount,
    required this.facultyCount,
    this.isActive = true,
    this.statusText = 'Active',
  });
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final String detail;
  final Color valueColor;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          LayoutBuilder(
            builder: (context, constraints) {
              final largeText = MediaQuery.textScalerOf(context).scale(9) > 13;
              if (largeText || constraints.maxWidth < 82) {
                return Column(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: valueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: valueColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: valueColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 10, color: AppColors.textHint),
            SizedBox(width: 4),
            Text(
              '256-bit AES Tenant Isolation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: AppColors.textHint),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Fluey Multi-Tenant Directory • Powered by Inventa',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
