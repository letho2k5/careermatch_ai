import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class EmployerPage extends StatelessWidget {
  const EmployerPage({
    required this.title,
    required this.child,
    this.bottom,
    this.actions = const [],
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? bottom;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final showNavigation =
        path != '/employer/signup' &&
        path != '/employer/login' &&
        path != '/employer/company/setup' &&
        path != '/employer/company/verification';
    final selectedIndex = path.startsWith('/employer/jobs')
        ? 1
        : path.startsWith('/employer/interviews') || path.endsWith('/invite')
        ? 3
        : path.startsWith('/employer/candidates') ||
              path.startsWith('/employer/shortlist')
        ? 2
        : path.startsWith('/employer/company')
        ? 4
        : 0;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        toolbarHeight: 54,
        titleSpacing: 4,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CAREERMATCH RECRUITMENT',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: .25,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          if (showNavigation)
            IconButton(
              tooltip: 'Thông báo',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Thông báo nhà tuyển dụng chưa có trong bản demo.',
                  ),
                ),
              ),
              icon: const Icon(Icons.notifications_none, size: 21),
            ),
          if (showNavigation)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => context.go('/employer/company/profile'),
                customBorder: const CircleBorder(),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.blueTint,
                  child: Icon(Icons.person, size: 18, color: AppColors.navy),
                ),
              ),
            ),
          ...actions,
        ],
        leadingWidth: 44,
        leading: IconButton(
          tooltip: 'Quay lại',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/choose-role'),
          icon: Image.asset(
            'assets/images/career_match_logo.png',
            width: 24,
            height: 24,
          ),
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
      bottomNavigationBar: !showNavigation
          ? bottom == null
                ? null
                : SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: bottom!,
                    ),
                  )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (bottom != null)
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: bottom!,
                    ),
                  ),
                EmployerConsoleNav(selectedIndex: selectedIndex),
              ],
            ),
    );
  }
}

class EmployerConsoleNav extends StatelessWidget {
  const EmployerConsoleNav({required this.selectedIndex, super.key});
  final int selectedIndex;

  static const _paths = [
    '/employer/dashboard',
    '/employer/jobs',
    '/employer/candidates',
    '/employer/interviews',
    '/employer/company/profile',
  ];

  @override
  Widget build(BuildContext context) => NavigationBar(
    height: 60,
    selectedIndex: selectedIndex,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    onDestinationSelected: (index) => context.go(_paths[index]),
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Tổng quan',
      ),
      NavigationDestination(
        icon: Icon(Icons.work_outline),
        selectedIcon: Icon(Icons.work),
        label: 'Tin tuyển',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Ứng viên',
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        selectedIcon: Icon(Icons.calendar_month),
        label: 'Phỏng vấn',
      ),
      NavigationDestination(
        icon: Icon(Icons.business_outlined),
        selectedIcon: Icon(Icons.business),
        label: 'Công ty',
      ),
    ],
  );
}

class EmployerFormBody extends StatelessWidget {
  const EmployerFormBody({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class EmployerField extends StatelessWidget {
  const EmployerField({
    required this.label,
    required this.controller,
    this.requiredField = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.hint,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool requiredField;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: maxLines > 1 ? 3 : 1,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: hint),
          validator:
              validator ??
              (requiredField
                  ? (value) => value?.trim().isNotEmpty == true
                        ? null
                        : 'Vui lòng nhập $label'
                  : null),
        ),
      ],
    ),
  );
}

Widget employerDemoNotice([
  String text = 'Bản demo cục bộ · chưa kết nối hệ thống tuyển dụng',
]) => Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.blueTint,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      const Icon(Icons.info_outline, color: AppColors.blue, size: 18),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.navy),
        ),
      ),
    ],
  ),
);

Widget employerSectionTitle(String text) => Padding(
  padding: const EdgeInsets.only(top: 8, bottom: 12),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      height: 1.3,
      color: AppColors.navy,
      fontWeight: FontWeight.w700,
    ),
  ),
);
