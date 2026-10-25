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
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.canvas,
    appBar: AppBar(
      title: Text(title),
      actions: actions,
      leading: IconButton(
        onPressed: () =>
            context.canPop() ? context.pop() : context.go('/choose-role'),
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
