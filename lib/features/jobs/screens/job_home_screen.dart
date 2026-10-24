import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_home/student_app_shell.dart';
import '../models/job.dart';
import '../widgets/job_widgets.dart';

class JobHomeScreen extends ConsumerWidget {
  const JobHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = demoJobs.take(3).toList();
    return StudentAppShell(
      selectedTab: 1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => context.push('/jobs/saved'),
                    icon: const Icon(Icons.bookmarks_outlined, size: 18),
                    label: const Text('Việc làm đã lưu'),
                  ),
                ),
                InkWell(
                  onTap: () => context.push('/jobs/search'),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Vị trí thực tập, công nghệ, công ty...',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                        Icon(Icons.tune, color: AppColors.navy),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _homeHero(context),
                const SizedBox(height: 18),
                const JobSectionTitle('BỘ LỌC GỢI Ý'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _quickFilter(context, 'Tất cả', true),
                    _quickFilter(context, 'Thực tập Backend', false),
                    _quickFilter(context, 'Data Analyst', false),
                    _quickFilter(context, 'Có lương thực tập', false),
                    _quickFilter(context, 'Chuẩn SDG 8', false),
                  ],
                ),
                const SizedBox(height: 22),
                JobSectionTitle(
                  'Việc làm tương thích cao ✨',
                  trailing: TextButton(
                    onPressed: () => context.push('/jobs/results'),
                    child: const Text('Xem tất cả'),
                  ),
                ),
                const Text(
                  'Dựa trên hồ sơ kỹ năng CareerMatch AI',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                for (final job in jobs) ...[
                  JobCard(job: job),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 10),
                const JobSectionTitle('Doanh nghiệp chuẩn SDG 8'),
                const SizedBox(height: 8),
                const Text(
                  'Cam kết có Mentor kèm cặp, môi trường minh bạch và tôn trọng quyền lợi sinh viên.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _companyPreview(context, 'FPT Software', '12 vị trí mở'),
                      const SizedBox(width: 10),
                      _companyPreview(
                        context,
                        'VNG Corporation',
                        '8 vị trí mở',
                      ),
                      const SizedBox(width: 10),
                      _companyPreview(context, 'MoMo Tech Hub', '5 vị trí mở'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeHero(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [Color(0xFF153B65), Color(0xFF0051D5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22002549),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const JobPill(
          'AI Profile Matcher',
          color: Color(0x33203459),
          textColor: Colors.white,
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 10),
        const Text(
          'Dành riêng cho bạn: 18 việc làm phù hợp',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Độ tương thích trên 85% với hồ sơ Backend Engineering của bạn.',
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => context.push('/jobs/recommended'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Khám phá gợi ý'),
          ),
        ),
      ],
    ),
  );

  Widget _quickFilter(BuildContext context, String label, bool selected) =>
      ActionChip(
        onPressed: () => context.push('/jobs/results'),
        avatar: selected
            ? null
            : const Icon(Icons.check_circle_outline, size: 14),
        label: Text(label),
        backgroundColor: selected ? AppColors.navy : Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
      );

  Widget _companyPreview(BuildContext context, String name, String positions) =>
      InkWell(
        onTap: () => context.push('/companies/fpt-software'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 245,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9EDF1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified, size: 18, color: AppColors.success),
              const SizedBox(height: 6),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              Text(
                positions,
                style: const TextStyle(color: AppColors.blue, fontSize: 12),
              ),
              const Text(
                'Đối tác việc làm bền vững',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      );
}
