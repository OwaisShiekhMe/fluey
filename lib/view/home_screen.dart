import 'package:fluey/reusable_component/app_colors.dart';
import 'package:fluey/reusable_component/app_scaffold.dart';
import 'package:fluey/view/dashboard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Dashboard(),
    _PlaceholderPage(title: 'Students'),
    _PlaceholderPage(title: 'Employees'),
    _PlaceholderPage(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFAF8FF),
        selectedItemColor: AppColors.accentBlue,
        unselectedItemColor: const Color(0xFF454456),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.textDark,
      ),
      body: Center(
        child: Text(
          '$title coming soon',
          style: const TextStyle(color: AppColors.textHint, fontSize: 16),
        ),
      ),
    );
  }
}
