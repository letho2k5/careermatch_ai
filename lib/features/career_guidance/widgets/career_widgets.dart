import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/student_home/student_app_shell.dart';

class CareerPage extends StatelessWidget {
  const CareerPage({
    required this.child,
    this.bottomAction,
    this.useStudentShell = true,
    super.key,
  });
  final Widget child;
  final Widget? bottomAction;
  final bool useStudentShell;

  @override
  Widget build(BuildContext context) {
    final scrollable = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
    );
    if (useStudentShell) {
      return StudentAppShell(
        selectedTab: 2,
        bottomAction: bottomAction,
        child: scrollable,
      );
    }
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(child: scrollable),
      bottomNavigationBar: bottomAction == null
          ? null
          : Material(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: bottomAction!,
                ),
              ),
            ),
    );
  }
}

class CareerBackHeader extends StatelessWidget {
  const CareerBackHeader({required this.title, this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        SizedBox(
          width: 36,
          height: 40,
          child: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, size: 20),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 36, height: 40),
            padding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          Flexible(
            child: Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      ],
    ),
  );
}

class CareerCard extends StatelessWidget {
  const CareerCard({
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08002549),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class CareerSectionTitle extends StatelessWidget {
  const CareerSectionTitle(this.title, {this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      ],
    ),
  );
}

class CareerDemoNote extends StatelessWidget {
  const CareerDemoNote({
    this.text = 'Gợi ý minh họa · dữ liệu cục bộ',
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.blueTint,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class CareerProgressBar extends StatelessWidget {
  const CareerProgressBar({
    required this.value,
    this.color = AppColors.blue,
    super.key,
  });
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: 7,
      color: color,
      backgroundColor: AppColors.surfaceMuted,
    ),
  );
}

class CareerPrimaryButton extends StatelessWidget {
  const CareerPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward, size: 18),
      label: Text(label, textAlign: TextAlign.center),
    ),
  );
}

Widget careerGapTag(String text, {bool missing = false}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  decoration: BoxDecoration(
    color: missing
        ? AppColors.errorTint
        : AppColors.successTint.withValues(alpha: .35),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    text,
    style: TextStyle(
      fontSize: 11,
      color: missing ? AppColors.error : AppColors.success,
      fontWeight: FontWeight.w700,
    ),
  ),
);

const careerSectionGap = SizedBox(height: AppSpacing.medium);
