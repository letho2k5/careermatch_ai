import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../data/career_guidance_demo_data.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class CareerDashboardScreen extends ConsumerWidget {
  const CareerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerGuidanceProvider);
    final goal = selectedCareerGoal(state);
    final draft = ref.watch(careerDraftProvider);
    final matched =
        goal?.skills.where((skill) => draftHasSkill(draft, skill)).length ?? 0;
    final total = goal?.skills.length ?? 0;
    final score = total == 0 ? 0 : (matched * 100 / total).round();
    final gaps = total - matched;
    final nextSkill = goal == null
        ? null
        : goal.skills
                  .where((skill) => !draftHasSkill(draft, skill))
                  .firstOrNull ??
              goal.skills.firstOrNull;

    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CareerCard(
            color: AppColors.navy,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF174879),
                  child: Icon(Icons.waving_hand_outlined, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TỔNG QUAN NGHỀ NGHIỆP',
                        style: TextStyle(
                          color: AppColors.successTint,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Chào ${draft.fullName.isEmpty ? 'bạn' : draft.fullName}, sẵn sàng nâng tầm sự nghiệp!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Mục tiêu: ${goal?.title ?? 'Chưa chọn'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.trending_up, color: Colors.white54, size: 28),
              ],
            ),
          ),
          careerSectionGap,
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(text: 'Chỉ số từ hồ sơ hiện tại'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 8,
                            backgroundColor: AppColors.surfaceMuted,
                            color: AppColors.blue,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$score%',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const Text(
                                  'khớp kỹ năng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mức sẵn sàng cho mục tiêu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Còn $gaps kỹ năng trong danh sách mục tiêu cần bổ sung.',
                            style: const TextStyle(fontSize: 12, height: 1.35),
                          ),
                          const SizedBox(height: 10),
                          CareerPrimaryButton(
                            label: 'Xem skill gap',
                            icon: Icons.insights,
                            onPressed: () => context.push('/career/skill-gap'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Tiến độ nhanh'),
          Row(
            children: [
              _StatTile(
                value: '$matched/$total',
                label: 'Kỹ năng phù hợp',
                icon: Icons.check_circle_outline,
                color: AppColors.successAccent,
              ),
              const SizedBox(width: 8),
              _StatTile(
                value: '$gaps',
                label: 'Kỹ năng còn thiếu',
                icon: Icons.warning_amber_rounded,
                color: AppColors.error,
              ),
              const SizedBox(width: 8),
              _StatTile(
                value: '${state.completedResourceIds.length}',
                label: 'Bài học hoàn tất',
                icon: Icons.menu_book_outlined,
                color: AppColors.blue,
              ),
            ],
          ),
          const SizedBox(height: 14),
          CareerCard(
            color: AppColors.success,
            child: Row(
              children: [
                const Icon(
                  Icons.eco_outlined,
                  color: AppColors.successTint,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SDG 8 · Việc làm bền vững',
                        style: TextStyle(
                          color: AppColors.successTint,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Phát triển kỹ năng để sẵn sàng cho cơ hội nghề nghiệp.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Trọng tâm học tập'),
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bước tiếp theo cho mục tiêu của bạn',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    careerGapTag('Gợi ý demo'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nextSkill ?? 'Chọn mục tiêu nghề nghiệp',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Gợi ý được sắp theo kỹ năng còn thiếu trong mục tiêu đã chọn.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                CareerProgressBar(value: matched / (total == 0 ? 1 : total)),
                const SizedBox(height: 12),
                CareerPrimaryButton(
                  label: 'Khám phá tài nguyên học',
                  icon: Icons.play_circle_outline,
                  onPressed: () => context.push('/career/resources'),
                ),
              ],
            ),
          ),
          const CareerSectionTitle(
            'Lộ trình đề xuất',
            trailing: Text(
              '4 chặng',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CareerCard(
            child: Column(
              children: [
                for (final (index, title) in [
                  'Nền tảng kỹ thuật',
                  'Container hóa & CI/CD',
                  'Kiểm thử ứng dụng',
                  'Chuẩn bị ứng tuyển',
                ].indexed)
                  _RoadmapPreviewRow(
                    index: index,
                    title: title,
                    complete: index == 0 && matched > 0,
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/career/roadmap'),
                    child: const Text('Xem roadmap'),
                  ),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Khám phá nhanh'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickLink(
                icon: Icons.psychology_outlined,
                title: 'Kỹ năng',
                subtitle: 'Xem hồ sơ kỹ năng',
                onTap: () => context.push('/career/skills'),
              ),
              _QuickLink(
                icon: Icons.flag_outlined,
                title: 'Mục tiêu',
                subtitle: 'Chọn hướng nghề nghiệp',
                onTap: () => context.push('/career/goals'),
              ),
              _QuickLink(
                icon: Icons.stacked_bar_chart,
                title: 'Ưu tiên học',
                subtitle: 'Xem thứ tự kỹ năng',
                onTap: () => context.push('/career/skill-priority'),
              ),
              _QuickLink(
                icon: Icons.menu_book_outlined,
                title: 'Tài nguyên',
                subtitle: 'Tìm nội dung học',
                onTap: () => context.push('/career/resources'),
              ),
              _QuickLink(
                icon: Icons.insights_outlined,
                title: 'Tiến độ',
                subtitle: 'Milestone đã đánh dấu',
                onTap: () => context.push('/career/progress'),
              ),
              _QuickLink(
                icon: Icons.fact_check_outlined,
                title: 'Tự đánh giá',
                subtitle: 'Câu hỏi kỹ năng demo',
                onTap: () => context.push('/career/assessment'),
              ),
              _QuickLink(
                icon: Icons.record_voice_over_outlined,
                title: 'Luyện phỏng vấn',
                subtitle: 'Trả lời bằng văn bản',
                onTap: () => context.push('/career/interview-practice'),
              ),
              _QuickLink(
                icon: Icons.privacy_tip_outlined,
                title: 'Giới hạn & dữ liệu',
                subtitle: 'Thông tin bản demo',
                onTap: () => context.push('/career/ai-privacy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
  final String value, label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(fontSize: 10, height: 1.2),
          ),
        ],
      ),
    ),
  );
}

class _RoadmapPreviewRow extends StatelessWidget {
  const _RoadmapPreviewRow({
    required this.index,
    required this.title,
    required this.complete,
  });
  final int index;
  final String title;
  final bool complete;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: complete
              ? AppColors.successAccent
              : AppColors.blueTint,
          child: Icon(
            complete ? Icons.check : Icons.lock_outline,
            size: 13,
            color: complete ? Colors.white : AppColors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Chặng ${index + 1}: $title',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          complete ? 'Đã có nền tảng' : 'Tiếp theo',
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 42) / 2,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CareerCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ),
  );
}
