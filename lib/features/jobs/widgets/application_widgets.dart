import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ApplicationStepHeader extends StatelessWidget {
  const ApplicationStepHeader({required this.step, super.key});
  final int step;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.blue,
              child: Text(
                '$step',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                switch (step) {
                  1 => 'Thông tin cá nhân',
                  2 => 'Tải CV',
                  _ => 'Xác nhận',
                },
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text('Bước $step / 3', style: const TextStyle(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: step / 3,
            minHeight: 5,
            backgroundColor: AppColors.surfaceMuted,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10,
          runSpacing: 4,
          children: [
            _stepLabel(1, '1. Hồ sơ ứng viên'),
            _stepLabel(2, '2. Tải CV'),
            _stepLabel(3, '3. Xác nhận'),
          ],
        ),
      ],
    ),
  );

  Widget _stepLabel(int number, String text) => Text(
    text,
    style: TextStyle(
      fontSize: 10,
      color: number == step ? AppColors.blue : AppColors.textSecondary,
      fontWeight: number == step ? FontWeight.w700 : FontWeight.normal,
    ),
  );
}

class ApplicationDemoNotice extends StatelessWidget {
  const ApplicationDemoNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.blueTint.withValues(alpha: .65),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.navy, size: 19),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Chế độ demo: thông tin chỉ được giữ trong bộ nhớ phiên này, chưa gửi tới nhà tuyển dụng.',
            style: TextStyle(fontSize: 11, height: 1.35, color: AppColors.navy),
          ),
        ),
      ],
    ),
  );
}

class ApplicationSectionCard extends StatelessWidget {
  const ApplicationSectionCard({
    required this.title,
    required this.child,
    this.icon = Icons.description_outlined,
    super.key,
  });

  final String title;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE9EDF1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.navy),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

String formatApplicationFileSize(int bytes) => bytes < 1024 * 1024
    ? '${(bytes / 1024).toStringAsFixed(0)} KB'
    : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
