import 'package:fluey/core/di/providers.dart';
import 'package:fluey/model/center.dart' as model;
import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/center_card.dart';
import 'package:fluey/view/center_registration.dart';
import 'package:fluey/view_model/center_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CenterList extends ConsumerStatefulWidget {
  const CenterList({super.key});

  @override
  ConsumerState<CenterList> createState() => _CenterListState();
}

class _CenterListState extends ConsumerState<CenterList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(centerProvider.notifier).fetchActiveCenters();
    });
  }

  List<model.Center> _filterCenters(List<model.Center> centers) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return centers;

    return centers.where((center) {
      return center.centerName.toLowerCase().contains(query) ||
          center.centerCode.toLowerCase().contains(query) ||
          center.address.toLowerCase().contains(query) ||
          center.primaryContactName.toLowerCase().contains(query);
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

  Future<void> _openCenterRegistration() async {
    final registeredCenter = await Navigator.of(context).push<model.Center?>(
      PageRouteBuilder<model.Center?>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CenterRegistration(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
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

    if (!mounted) return;
    if (registeredCenter != null) {
      await ref.read(centerProvider.notifier).fetchActiveCenters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerState = ref.watch(centerProvider);
    final allCenters = centerState.activeCenters;
    final filteredCenters = _filterCenters(allCenters);

    final totalCount = allCenters.length;
    final activeCount = allCenters.where((c) => c.isActive).length;
    final pendingCount = totalCount - activeCount;

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
                  child: RefreshIndicator(
                    color: AppColors.accentBlue,
                    onRefresh: () =>
                        ref.read(centerProvider.notifier).fetchActiveCenters(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      child: Column(
                        children: [
                          _buildSearchField(),
                          const SizedBox(height: 8),
                          _buildSummary(
                            total: totalCount,
                            active: activeCount,
                            pending: pendingCount,
                          ),
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
                          _buildCentersBody(centerState, filteredCenters),
                          const SizedBox(height: 10),
                          const _Footer(),
                        ],
                      ),
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

  Widget _buildCentersBody(
    CenterState centerState,
    List<model.Center> centers,
  ) {
    if (centerState.isFetchingCenters && centerState.activeCenters.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accentBlue),
        ),
      );
    }

    if (centerState.fetchError != null && centerState.activeCenters.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              centerState.fetchError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF475467), fontSize: 13),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () =>
                  ref.read(centerProvider.notifier).fetchActiveCenters(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (centers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          _searchQuery.trim().isEmpty
              ? 'No active centers found.'
              : 'No centers match your search.',
          style: const TextStyle(color: AppColors.textHint),
        ),
      );
    }

    return Column(
      children: centers.map((center) {
        final formattedPhone = center.mobileNumber.isNotEmpty
            ? '${center.countryCode} ${center.mobileNumber}'
            : 'Contact on file';

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CenterCard(
            code: center.centerCode,
            name: center.centerName,
            statusText: center.isActive ? 'Active' : 'Pending Review',
            address: center.address.isNotEmpty
                ? center.address
                : 'Address not listed',
            contactName: center.primaryContactName.isNotEmpty
                ? center.primaryContactName
                : 'Primary Admin',
            contactPhone: formattedPhone,
            studentCount: 0,
            facultyCount: 0,
            isActive: center.isActive,
            onTap: () => _showMessage('Opened ${center.centerName}'),
          ),
        );
      }).toList(),
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
                tooltip: 'Refresh centers',
                onPressed: () =>
                    ref.read(centerProvider.notifier).fetchActiveCenters(),
                icon: const Icon(Icons.refresh, size: 20),
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

  Widget _buildSummary({
    required int total,
    required int active,
    required int pending,
  }) {
    return Row(
      children: [
        Expanded(
          child: _SummaryMetric(
            label: 'TOTAL',
            value: '$total',
            detail: 'Hubs',
            valueColor: const Color(0xFF1749C5),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SummaryMetric(
            label: 'ACTIVE',
            value: '$active',
            detail: '•',
            valueColor: const Color(0xFF0085B8),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SummaryMetric(
            label: 'PENDING',
            value: '$pending',
            detail: 'Hold',
            valueColor: const Color(0xFF9A5200),
          ),
        ),
      ],
    );
  }
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