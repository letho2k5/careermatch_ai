import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../models/job.dart';
import '../state/job_discovery_state.dart';

class JobScreenScaffold extends StatelessWidget {
  const JobScreenScaffold({
    required this.title,
    required this.body,
    this.bottomNavigationBar,
    this.bottomAction,
    this.leading,
    this.actions = const [],
    this.extendBody = false,
    super.key,
  });

  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? bottomAction;
  final Widget? leading;
  final List<Widget> actions;
  final bool extendBody;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.canvas,
    extendBody: extendBody,
    appBar: AppBar(
      toolbarHeight: 56,
      leading:
          leading ??
          IconButton(
            tooltip: 'Quay lại',
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/jobs/home');
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        ...actions,
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () => context.go('/student-profile-setup-1'),
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/student_avatar.png'),
            ),
          ),
        ),
      ],
    ),
    body: SafeArea(top: false, child: body),
    bottomNavigationBar: bottomAction == null
        ? bottomNavigationBar
        : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: bottomAction!,
            ),
          ),
  );
}

class JobSectionTitle extends StatelessWidget {
  const JobSectionTitle(this.title, {this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w700),
        ),
      ),
      ?trailing,
    ],
  );
}

class JobPill extends StatelessWidget {
  const JobPill(
    this.label, {
    this.color = AppColors.blueTint,
    this.textColor = AppColors.navy,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 220),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class JobLogo extends StatelessWidget {
  const JobLogo({required this.company, this.size = 44, super.key});
  final String company;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch (company) {
      'FPT Software' => const Color(0xFFE7F1FF),
      'VNG Corporation' => const Color(0xFFE6F6EF),
      'MoMo (M_Service)' => const Color(0xFFFFE9F1),
      'Tiki Corporation' => const Color(0xFFE4F5FF),
      _ => AppColors.surfaceMuted,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.business_rounded,
        size: size * .54,
        color: AppColors.navy,
      ),
    );
  }
}

class JobCard extends ConsumerWidget {
  const JobCard({required this.job, this.compact = false, super.key});
  final Job job;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(
      jobDiscoveryProvider.select((state) => state.savedIds.contains(job.id)),
    );
    final controller = ref.read(jobDiscoveryProvider.notifier);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/jobs/${job.id}'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9EDF1)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x07002549),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobLogo(company: job.company, size: compact ? 38 : 44),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontSize: 14,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          job.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: isSaved ? 'Bỏ lưu việc làm' : 'Lưu việc làm',
                    onPressed: () {
                      controller.toggleSaved(job.id);
                      context.push('/jobs/${job.id}/save-confirmation');
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? AppColors.blue : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  JobPill(
                    '${job.matchScore}% phù hợp',
                    icon: Icons.auto_awesome,
                  ),
                  JobPill(job.workMode, color: AppColors.surfaceMuted),
                  if (!compact)
                    JobPill(
                      'SDG 8: có hướng dẫn',
                      color: AppColors.successTint,
                      textColor: AppColors.success,
                      icon: Icons.verified_outlined,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.salaryLabel,
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.type,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact)
                    FilledButton.tonalIcon(
                      onPressed: () => _showApplyMessage(context),
                      icon: const Icon(Icons.send_outlined, size: 15),
                      label: const Text('Ứng tuyển nhanh'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showApplyMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ứng tuyển trực tiếp chưa được kết nối.')),
    );
  }
}

class JobEmptyState extends StatelessWidget {
  const JobEmptyState({
    required this.title,
    this.subtitle = 'Hãy thử đổi từ khóa hoặc bộ lọc.',
    this.onReset,
    super.key,
  });
  final String title;
  final String subtitle;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 44, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if (onReset != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: onReset, child: const Text('Xóa bộ lọc')),
          ],
        ],
      ),
    ),
  );
}
