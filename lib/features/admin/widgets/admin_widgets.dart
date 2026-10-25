import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    required this.title,
    required this.child,
    this.bottom,
    this.login = false,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? bottom;
  final bool login;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FC),
    appBar: login
        ? null
        : AppBar(
            backgroundColor: const Color(0xFFF8F9FC),
            title: Text(title),
            leading: IconButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go('/admin/dashboard'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: child,
        ),
      ),
    ),
    bottomNavigationBar: bottom == null
        ? null
        : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: bottom!,
            ),
          ),
  );
}

class AdminDemoNotice extends StatelessWidget {
  const AdminDemoNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.blueTint,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline, color: AppColors.navy, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Dữ liệu demo cục bộ trong phiên chạy; chưa kết nối hệ thống quản trị.',
            style: TextStyle(color: AppColors.navy, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class AdminCard extends StatelessWidget {
  const AdminCard({required this.child, this.padding = 16, super.key});
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 1,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE7E8EB)),
    ),
    child: Padding(padding: EdgeInsets.all(padding), child: child),
  );
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
    ),
  );
}

class AdminStatusChip extends StatelessWidget {
  const AdminStatusChip(this.label, {this.positive = false, super.key});
  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: positive ? const Color(0xFFABF3BF) : const Color(0xFFB4D0FD),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: positive ? AppColors.success : AppColors.navy,
      ),
    ),
  );
}

class AdminField extends StatelessWidget {
  const AdminField({
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    ),
  );
}

class AdminConsoleNav extends StatelessWidget {
  const AdminConsoleNav({required this.selectedIndex, super.key});
  final int selectedIndex;

  static const _paths = [
    '/admin/dashboard',
    '/admin/companies/pending',
    '/admin/users',
    '/admin/reports',
    '/admin/settings',
  ];

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selectedIndex,
    height: 64,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    onDestinationSelected: (index) => context.go(_paths[index]),
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Tổng quan',
      ),
      NavigationDestination(
        icon: Icon(Icons.fact_check_outlined),
        selectedIcon: Icon(Icons.fact_check),
        label: 'Duyệt',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Người dùng',
      ),
      NavigationDestination(
        icon: Icon(Icons.flag_outlined),
        selectedIcon: Icon(Icons.flag),
        label: 'Báo cáo',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Cài đặt',
      ),
    ],
  );
}
