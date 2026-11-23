import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/reusable_component/button.dart';
import 'package:fluey/reusable_component/stat_card.dart';
import 'package:fluey/model/enrollment_item.dart';
import 'package:fluey/view/center_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<EnrolmentItem> _enrolments = const [
    EnrolmentItem(
      initials: 'AA',
      name: 'Ahmed Ali',
      meta: 'Grade 10-A • STU-1024',
      timeLabel: 'Today',
      badgeBg: Color(0xFFE8EEFF),
      badgeFg: Color(0xFF2E5BFF),
    ),
    EnrolmentItem(
      initials: 'FK',
      name: 'Fatima Khan',
      meta: 'Grade 8-B • STU-1025',
      timeLabel: 'Today',
      badgeBg: Color(0xFFFCE6CD),
      badgeFg: Color(0xFF8C4A08),
    ),
    EnrolmentItem(
      initials: 'HA',
      name: 'Hassan Ahmed',
      meta: 'Grade 6-A • STU-1026',
      timeLabel: 'Yesterday',
      badgeBg: Color(0xFFD9EEFA),
      badgeFg: Color(0xFF005A8D),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EnrolmentItem> get _filteredEnrolments {
    if (_searchQuery.trim().isEmpty) return _enrolments;
    final q = _searchQuery.toLowerCase().trim();
    return _enrolments
        .where(
          (item) =>
              item.name.toLowerCase().contains(q) ||
              item.meta.toLowerCase().contains(q),
        )
        .toList();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _openCenterList() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CenterList(),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: const Text(
              'F',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'SUPER ADMIN',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: Color(0xFF475467),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.circle, size: 6, color: Color(0xFFF59E0B)),
                ],
              ),
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            children: [
              IconButton(
                onPressed: () => _showSnack('Notifications'),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF344054),
                  size: 24,
                ),
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final statCardWidth = (MediaQuery.sizeOf(context).width - 44) / 2;

    return AppScaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome & Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back, Admin',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF101828),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Color(0xFF2E5BFF),
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'System Online • All 4 Hubs Active',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF475467),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EEFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.hub_outlined,
                        size: 14,
                        color: Color(0xFF2E5BFF),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E5BFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2x2 Stat Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: statCardWidth / 160,
              children: [
                StatCard(
                  icon: Icons.school_outlined,
                  badgeText: '+4.2%',
                  title: 'Total Students',
                  value: '1,250',
                  accentColor: const Color(0xFF2E5BFF),
                  badgeBackgroundColor: const Color(0xFFE8EEFF),
                  onTap: () => _showSnack('Opened Total Students'),
                ),
                StatCard(
                  icon: Icons.assignment_late_outlined,
                  badgeText: 'Alert',
                  title: 'Pending Fees',
                  value: '250',
                  accentColor: const Color(0xFF8C4A08),
                  badgeBackgroundColor: const Color(0xFFFCE6CD),
                  valueColor: const Color(0xFF8C4A08),
                  onTap: () => _showSnack('Opened Pending Fees'),
                ),
                StatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  badgeText: '94%',
                  title: 'Collected Fees',
                  value: 'PKR 4.8M',
                  accentColor: const Color(0xFF005A8D),
                  badgeBackgroundColor: const Color(0xFFD9EEFA),
                  valueColor: const Color(0xFF005A8D),
                  onTap: () => _showSnack('Opened Collected Fees'),
                ),
                StatCard(
                  icon: Icons.admin_panel_settings_outlined,
                  badgeText: 'Active',
                  title: 'Administrators',
                  value: '12',
                  accentColor: const Color(0xFF475467),
                  badgeBackgroundColor: const Color(0xFFEAEFFB),
                  onTap: () => _showSnack('Opened Administrators'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Registered Centers Banner Card
            _buildRegisteredCentersCard(),
            const SizedBox(height: 14),

            // Quick Actions Row
            Row(
              children: [
                Expanded(
                  child: _QuickActionTile(
                    icon: Icons.person_add_alt_1_outlined,
                    label: 'Add\nStudent',
                    bgColor: const Color(0xFFE8EEFF),
                    fgColor: const Color(0xFF2E5BFF),
                    onTap: () => _showSnack('Add Student tapped'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionTile(
                    icon: Icons.badge_outlined,
                    label: 'Add Admin',
                    bgColor: const Color(0xFFEAEFFB),
                    fgColor: const Color(0xFF4F46E5),
                    onTap: () => _showSnack('Add Admin tapped'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionTile(
                    icon: Icons.payments_outlined,
                    label: 'Fee Desk',
                    bgColor: const Color(0xFFD9EEFA),
                    fgColor: const Color(0xFF005A8D),
                    onTap: () => _showSnack('Fee Desk tapped'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionTile(
                    icon: Icons.campaign_outlined,
                    label: 'Broadcast',
                    bgColor: const Color(0xFFFCE6CD),
                    fgColor: const Color(0xFF8C4A08),
                    onTap: () => _showSnack('Broadcast tapped'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent Enrolments Card
            _buildRecentEnrolmentsCard(),
            const SizedBox(height: 16),

            // Payment Alerts Card
            _buildPaymentAlertsCard(),
            const SizedBox(height: 16),

            // Admin Management Card
            _buildAdminManagementCard(),
            const SizedBox(height: 20),

            // Footer
            Center(
              child: Column(
                children: const [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 14,
                        color: Color(0xFF2E5BFF),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Powered by Fluey Platform',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475467),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NODE CLUSTER 04 • OPERATIONAL',
                    style: TextStyle(
                      fontSize: 10.5,
                      letterSpacing: 0.6,
                      color: Color(0xFF98A2B3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisteredCentersCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _openCenterList,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F3F6)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '4',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E5BFF),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Registered Centers',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Select a center to view its data →',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E5BFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEnrolmentsCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.groups_outlined,
                    size: 18,
                    color: Color(0xFF2E5BFF),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Enrolments',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showSnack('View all enrolments'),
                child: const Text(
                  'View All →',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E5BFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search student by name or STU-ID...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF98A2B3),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 19,
                color: Color(0xFF98A2B3),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          ..._filteredEnrolments.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.badgeBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.initials,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: item.badgeFg,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF101828),
                          ),
                        ),
                        Text(
                          item.meta,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEFFB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.timeLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475467),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAlertsCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 18,
                    color: Color(0xFF8C4A08),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Payment Alerts',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE6CD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Quarter Q2',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8C4A08),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: Color(0xFFD92D20),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Overdue',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD92D20),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '25',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFD92D20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE6CD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: Color(0xFF8C4A08),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Due Soon',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8C4A08),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '40',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8C4A08),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Button(
            label: 'View Pending Fees Ledger',
            trailingIcon: const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Color(0xFF2E5BFF),
            ),
            backgroundColor: const Color(0xFFE8EEFF),
            foregroundColor: const Color(0xFF2E5BFF),
            horizontalMarginFactor: 0,
            verticalMarginFactor: 0,
            height: 0.055,
            onTap: () => _showSnack('Opening Pending Fees Ledger'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminManagementCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: Color(0xFF2E5BFF),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Admin Management',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEFFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '2 Super • 10 Staff',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475467),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '12 active administrative seats engaged across regional campus centers.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF667085),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Button(
                  label: 'Manage Roles',
                  backgroundColor: const Color(0xFFF8F9FC),
                  foregroundColor: const Color(0xFF2E5BFF),
                  borderColor: const Color(0xFFE4E7EC),
                  horizontalMarginFactor: 0,
                  verticalMarginFactor: 0,
                  height: 0.052,
                  onTap: () => _showSnack('Manage Roles tapped'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Button(
                  label: 'Audit Log',
                  backgroundColor: const Color(0xFFF8F9FC),
                  foregroundColor: const Color(0xFF344054),
                  borderColor: const Color(0xFFE4E7EC),
                  horizontalMarginFactor: 0,
                  verticalMarginFactor: 0,
                  height: 0.052,
                  onTap: () => _showSnack('Audit Log tapped'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF1F3F6)),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: fgColor, size: 19),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344054),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
