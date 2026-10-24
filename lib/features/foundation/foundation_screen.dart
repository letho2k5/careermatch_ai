import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_frame.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      title: 'CareerMatch AI',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.auto_awesome, size: 40, color: AppColors.blue),
                const SizedBox(height: AppSpacing.large),
                Text(
                  'Nền tảng giao diện đã sẵn sàng',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Các màn hình CareerMatch AI sẽ được bổ sung theo từng giai đoạn.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xLarge),
                const AppPrimaryButton(
                  label: 'Giai đoạn 0 hoàn tất',
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
