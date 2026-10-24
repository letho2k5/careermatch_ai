import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class StudentAppShell extends StatelessWidget {
  const StudentAppShell({
    required this.child,
    this.bottomAction,
    this.selectedTab = 4,
    super.key,
  });
  final Widget child;
  final Widget? bottomAction;
  final int selectedTab;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.canvas,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            'assets/images/career_match_logo.png',
            width: 30,
            height: 30,
          ),
          if (MediaQuery.sizeOf(context).width >= 360) ...[
            const SizedBox(width: 8),
            const Text(
              'CareerMatch AI',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _notAvailable(context),
          icon: const Icon(Icons.notifications_none),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.blueTint,
            child: const Icon(Icons.person, size: 19, color: AppColors.navy),
          ),
        ),
      ],
    ),
    body: SafeArea(top: false, child: child),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (bottomAction != null)
          Material(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: bottomAction!,
              ),
            ),
          ),
        NavigationBar(
          height: 64,
          selectedIndex: selectedTab,
          labelBehavior: MediaQuery.sizeOf(context).width < 360
              ? NavigationDestinationLabelBehavior.onlyShowSelected
              : NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            if (index == 0) context.go('/student-home');
            if (index == 1) context.go('/jobs/home');
            if (index == 2) context.go('/career');
            if (index == 4) context.go('/student-profile-setup-1');
            if (index == 3) context.go('/applications');
            if (index != 0 && index != 1 && index != 3 && index != 4) {
              _notAvailable(context);
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              label: 'Việc làm',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up),
              label: 'Lộ trình',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              label: 'Đã ứng tuyển',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Cá nhân',
            ),
          ],
        ),
      ],
    ),
  );

  static void _notAvailable(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mục này chưa nằm trong phạm vi ST-11 đến ST-20.'),
        ),
      );
}

class StudentPage extends StatelessWidget {
  const StudentPage({
    required this.child,
    this.bottomAction,
    this.selectedTab = 4,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 24),
    super.key,
  });
  final Widget child;
  final Widget? bottomAction;
  final int selectedTab;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => StudentAppShell(
    bottomAction: bottomAction,
    selectedTab: selectedTab,
    child: SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
    ),
  );
}

class StudentBackRow extends StatelessWidget {
  const StudentBackRow({
    required this.title,
    this.trailing,
    this.onBack,
    super.key,
  });
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        visualDensity: VisualDensity.compact,
        onPressed:
            onBack ??
            () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/student-home');
              }
            },
        icon: const Icon(Icons.arrow_back),
      ),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}

class ProfileStepIndicator extends StatelessWidget {
  const ProfileStepIndicator({
    required this.step,
    required this.label,
    super.key,
  });
  final int step;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Bước $step/3 • $label',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          Text(
            '${(step * 100 / 3).round()}%',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(value: step / 3, minHeight: 4),
      ),
    ],
  );
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });
  final String title;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final titleText = Text(
              title,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            );
            if (constraints.maxWidth < 300 && trailing != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText,
                  Align(alignment: Alignment.centerLeft, child: trailing!),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: titleText),
                ?trailing,
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Material(color: Colors.transparent, child: child),
      ],
    ),
  );
}

class DemoPill extends StatelessWidget {
  const DemoPill({this.label = 'DEMO', super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.successTint.withValues(alpha: .5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.success,
      ),
    ),
  );
}

InputDecoration profileInput(
  String label, {
  String? hint,
  Widget? suffixIcon,
  String? prefixText,
}) => InputDecoration(
  labelText: label,
  hintText: hint,
  suffixIcon: suffixIcon,
  prefixText: prefixText,
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
);
