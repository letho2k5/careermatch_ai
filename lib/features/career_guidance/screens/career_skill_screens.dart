import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class SkillOverviewScreen extends ConsumerWidget {
  const SkillOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(careerDraftProvider);
    final skills = skillsFromDraft(draft);
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    final matching =
        goal?.skills.where((skill) => draftHasSkill(draft, skill)).length ?? 0;
    final total = goal?.skills.length ?? 0;

    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Tổng quan kỹ năng'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(text: 'Từ hồ sơ và dữ liệu CV demo'),
                const SizedBox(height: 10),
                Text(
                  goal?.title ?? 'Chưa chọn mục tiêu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Khớp $matching/$total kỹ năng trong mục tiêu đã chọn.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                CareerProgressBar(
                  value: total == 0 ? 0 : matching / total,
                  color: AppColors.successAccent,
                ),
              ],
            ),
          ),
          CareerSectionTitle(
            'Kỹ năng của bạn',
            trailing: Text(
              '${skills.length} kỹ năng',
              style: const TextStyle(color: AppColors.blue, fontSize: 11),
            ),
          ),
          if (skills.isEmpty)
            const CareerCard(
              child: Text(
                'Chưa có kỹ năng trong hồ sơ. Hãy bổ sung ở phần hồ sơ sinh viên.',
              ),
            )
          else
            for (final skill in skills) ...[
              _SkillCard(skill: skill),
              const SizedBox(height: 9),
            ],
          const CareerSectionTitle('Skill gap của mục tiêu'),
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(total - matching).clamp(0, total)} kỹ năng cần ưu tiên',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                CareerPrimaryButton(
                  label: 'Xem phân tích skill gap',
                  icon: Icons.insights,
                  onPressed: () => context.push('/career/skill-gap'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});
  final CareerSkill skill;

  @override
  Widget build(BuildContext context) {
    final fromProfile = skill.source == SkillSource.profile;
    final level = _levelPercent(skill.level);
    return CareerCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: fromProfile
                    ? AppColors.blueTint
                    : AppColors.successTint.withValues(alpha: .45),
                child: Icon(
                  fromProfile
                      ? Icons.person_outline
                      : Icons.description_outlined,
                  size: 17,
                  color: fromProfile ? AppColors.blue : AppColors.success,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              careerGapTag(fromProfile ? 'Hồ sơ' : 'CV demo'),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(child: CareerProgressBar(value: level)),
              const SizedBox(width: 10),
              Text(
                skill.level,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            fromProfile
                ? 'Do bạn khai báo trong hồ sơ; chưa xác minh năng lực.'
                : 'Từ dữ liệu trích xuất CV mẫu; cần người dùng xác nhận.',
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  double _levelPercent(String level) {
    final value = level.toLowerCase();
    if (value.contains('thành thạo') || value.contains('nâng cao')) return .9;
    if (value.contains('trung cấp')) return .65;
    if (value.contains('cơ bản')) return .4;
    return .35;
  }
}

class SkillGapSummaryScreen extends ConsumerWidget {
  const SkillGapSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(careerDraftProvider);
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    if (goal == null) {
      return const _CareerNotFound(message: 'Chưa có mục tiêu nghề nghiệp.');
    }
    final rows = goal.skills
        .map(
          (skill) =>
              SkillGap(skill: skill, hasSkill: draftHasSkill(draft, skill)),
        )
        .toList();
    final present = rows.where((row) => row.hasSkill).length;
    final percent = rows.isEmpty ? 0 : (present * 100 / rows.length).round();
    final missing = rows.where((row) => !row.hasSkill).toList();

    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: 'Xem thứ tự ưu tiên học',
        icon: Icons.low_priority,
        onPressed: () => context.push('/career/skill-priority'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Phân tích skill gap'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.track_changes, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        goal.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const CareerDemoNote(text: 'Demo cục bộ'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$percent% kỹ năng đang có  →  ${(percent + (100 - percent) * .45).round()}% nếu hoàn thành các gợi ý',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                CareerProgressBar(
                  value: percent / 100,
                  color: AppColors.successAccent,
                ),
                const SizedBox(height: 7),
                Text(
                  '$present/${rows.length} kỹ năng phù hợp theo tên kỹ năng trong hồ sơ',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const CareerSectionTitle(
            'Kỹ năng đã có',
            trailing: Text(
              'Theo hồ sơ hiện tại',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
          CareerCard(
            child: rows.where((row) => row.hasSkill).isEmpty
                ? const Text('Chưa có kỹ năng khớp với mục tiêu này.')
                : Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      for (final row in rows.where((row) => row.hasSkill))
                        careerGapTag(row.skill),
                    ],
                  ),
          ),
          CareerSectionTitle(
            'Kỹ năng còn thiếu',
            trailing: Text(
              '${missing.length} kỹ năng',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (missing.isEmpty)
            const CareerCard(
              child: Text('Không còn skill gap trong danh sách mục tiêu này.'),
            )
          else
            for (final row in missing) ...[
              _GapCard(skill: row.skill),
              const SizedBox(height: 9),
            ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _GapCard extends StatelessWidget {
  const _GapCard({required this.skill});
  final String skill;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push('/career/missing-skill/${careerSkillId(skill)}'),
    borderRadius: BorderRadius.circular(13),
    child: CareerCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const Text(
                  'Chưa thấy trong dữ liệu hồ sơ hiện tại',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.blue),
        ],
      ),
    ),
  );
}

class MissingSkillDetailScreen extends ConsumerWidget {
  const MissingSkillDetailScreen({required this.skillId, super.key});
  final String skillId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    final draft = ref.watch(careerDraftProvider);
    final skill = goal?.skills
        .where((value) => careerSkillId(value) == skillId)
        .firstOrNull;
    if (goal == null || skill == null || draftHasSkill(draft, skill)) {
      return _CareerNotFound(
        message: skill == null
            ? 'Không tìm thấy kỹ năng.'
            : 'Kỹ năng này không nằm trong skill gap hiện tại.',
      );
    }
    final steps =
        missingSkillSteps[skillId] ??
        [
          'Tìm tài nguyên phù hợp',
          'Luyện tập theo bài học',
          'Áp dụng vào dự án cá nhân',
        ];
    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: 'Tìm tài nguyên học',
        icon: Icons.menu_book_outlined,
        onPressed: () => context.push(
          '/career/resources?skill=${Uri.encodeComponent(skill)}',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CareerBackHeader(title: skill),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(text: 'Skill gap từ phép so khớp cục bộ'),
                const SizedBox(height: 10),
                Text(
                  skill,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mục tiêu: ${goal.title}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Vì sao kỹ năng này có trong mục tiêu?'),
          const CareerCard(
            child: Text(
              'Kỹ năng này nằm trong danh sách yêu cầu demo cho mục tiêu nghề nghiệp đã chọn. Đây là gợi ý tham khảo, không phải kết luận tuyển dụng hay đánh giá AI.',
            ),
          ),
          const CareerSectionTitle('Lộ trình khắc phục 3 bước'),
          for (var i = 0; i < steps.length; i++) ...[
            CareerCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.blue,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const CareerCard(
            child: Text(
              'Mức ưu tiên được sắp theo thứ tự kỹ năng trong bộ dữ liệu mục tiêu demo.',
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class SkillPriorityScreen extends ConsumerWidget {
  const SkillPriorityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(careerDraftProvider);
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    if (goal == null) {
      return const _CareerNotFound(message: 'Chưa có mục tiêu nghề nghiệp.');
    }
    final gaps = goal.skills
        .where((skill) => !draftHasSkill(draft, skill))
        .toList();
    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Ưu tiên phát triển kỹ năng'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(
                  text: 'Thứ tự demo · theo danh sách mục tiêu',
                ),
                const SizedBox(height: 8),
                Text(
                  goal.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Danh sách sắp xếp theo thứ tự kỹ năng còn thiếu trong mục tiêu nghề nghiệp.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Thứ tự nên học'),
          if (gaps.isEmpty)
            const CareerCard(
              child: Text('Hồ sơ hiện đã khớp các kỹ năng trong mục tiêu.'),
            )
          else
            for (var index = 0; index < gaps.length; index++) ...[
              CareerCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: index == 0
                          ? AppColors.errorTint
                          : AppColors.blueTint,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index == 0 ? AppColors.error : AppColors.blue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gaps[index],
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0
                                ? 'Ưu tiên đầu tiên theo thứ tự mục tiêu.'
                                : 'Tiếp theo trong danh sách yêu cầu mục tiêu.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CareerProgressBar(
                            value: (gaps.length - index) / gaps.length,
                            color: index == 0
                                ? AppColors.error
                                : AppColors.blue,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push(
                        '/career/missing-skill/${careerSkillId(gaps[index])}',
                      ),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 12),
          CareerCard(
            color: AppColors.blueTint,
            child: const Text(
              'Tiêu chí: thứ tự được lấy từ danh sách yêu cầu của mục tiêu demo. Không có xếp hạng AI hoặc dữ liệu thị trường trực tiếp.',
              style: TextStyle(fontSize: 11, height: 1.35),
            ),
          ),
          const CareerSectionTitle('Học theo lộ trình'),
          CareerPrimaryButton(
            label: 'Xem tài nguyên học tập',
            icon: Icons.menu_book_outlined,
            onPressed: () => context.push('/career/resources'),
          ),
        ],
      ),
    );
  }
}

class _CareerNotFound extends StatelessWidget {
  const _CareerNotFound({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => CareerPage(
    child: Column(
      children: [
        const CareerBackHeader(title: 'Không tìm thấy'),
        CareerCard(
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.error),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CareerPrimaryButton(
          label: 'Về Career Dashboard',
          onPressed: () => context.go('/career'),
        ),
      ],
    ),
  );
}
