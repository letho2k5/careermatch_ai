import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class CareerGoalSelectScreen extends ConsumerStatefulWidget {
  const CareerGoalSelectScreen({super.key});
  @override
  ConsumerState<CareerGoalSelectScreen> createState() =>
      _CareerGoalSelectScreenState();
}

class _CareerGoalSelectScreenState
    extends ConsumerState<CareerGoalSelectScreen> {
  late String selectedId;
  String query = '';

  @override
  void initState() {
    super.initState();
    selectedId = ref.read(careerGuidanceProvider).selectedGoalId;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = careerGoals
        .where(
          (goal) => '${goal.title} ${goal.subtitle}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    final selectedExists = careerGoals.any((goal) => goal.id == selectedId);
    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: selectedExists
            ? 'Xác nhận mục tiêu & xem lộ trình'
            : 'Chọn mục tiêu để tiếp tục',
        icon: Icons.check,
        onPressed: selectedExists
            ? () {
                ref
                    .read(careerGuidanceProvider.notifier)
                    .selectGoal(selectedId);
                context.push('/career/goals/$selectedId');
              }
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Chọn mục tiêu nghề nghiệp'),
          CareerCard(
            color: AppColors.navy,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CareerDemoNote(text: 'Danh sách mục tiêu minh họa'),
                SizedBox(height: 9),
                Text(
                  'Bạn muốn phát triển theo hướng nào?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Có thể thay đổi lựa chọn trong phiên ứng dụng.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Tìm mục tiêu nghề nghiệp',
              isDense: true,
            ),
          ),
          const CareerSectionTitle('Mục tiêu phù hợp'),
          if (filtered.isEmpty)
            const CareerCard(
              child: Text('Không có mục tiêu phù hợp với từ khóa.'),
            )
          else
            for (final goal in filtered) ...[
              _GoalOption(
                goal: goal,
                selected: selectedId == goal.id,
                onTap: () => setState(() => selectedId = goal.id),
              ),
              const SizedBox(height: 10),
            ],
          const SizedBox(height: 76),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.selected,
    required this.onTap,
  });
  final CareerGoal goal;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: CareerCard(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.blueTint,
                child: Icon(_goalIcon(goal.id), color: AppColors.blue),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      goal.subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.blue : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            goal.description,
            style: const TextStyle(
              fontSize: 11,
              height: 1.35,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final skill in goal.skills.take(3)) careerGapTag(skill),
            ],
          ),
        ],
      ),
    ),
  );
}

class CareerGoalDetailScreen extends ConsumerWidget {
  const CareerGoalDetailScreen({required this.goalId, super.key});
  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = careerGoals.where((item) => item.id == goalId).firstOrNull;
    if (goal == null) {
      return CareerPage(
        child: Column(
          children: [
            const CareerBackHeader(title: 'Không tìm thấy mục tiêu'),
            const CareerCard(
              child: Text('Không tìm thấy mục tiêu nghề nghiệp này.'),
            ),
            const SizedBox(height: 14),
            CareerPrimaryButton(
              label: 'Chọn mục tiêu khác',
              onPressed: () => context.go('/career/goals'),
            ),
          ],
        ),
      );
    }
    final draft = ref.watch(careerDraftProvider);
    final matchCount = goal.skills
        .where((skill) => draftHasSkill(draft, skill))
        .length;
    final score = goal.skills.isEmpty
        ? 0
        : (matchCount * 100 / goal.skills.length).round();
    final isSelected =
        ref.watch(careerGuidanceProvider).selectedGoalId == goal.id;
    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Chi tiết mục tiêu'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      color: AppColors.successTint,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        goal.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (isSelected) const CareerDemoNote(text: 'Đang chọn'),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  goal.subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Text(
                  goal.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Mức độ phù hợp theo hồ sơ'),
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$score%',
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '$matchCount/${goal.skills.length} kỹ năng khớp',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CareerProgressBar(value: score / 100),
                const SizedBox(height: 7),
                const Text(
                  'So khớp tên kỹ năng từ hồ sơ hiện tại; không phải đánh giá năng lực hay dự đoán tuyển dụng.',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Kỹ năng liên quan'),
          CareerCard(
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final skill in goal.skills)
                  careerGapTag(skill, missing: !draftHasSkill(draft, skill)),
              ],
            ),
          ),
          const CareerSectionTitle('Lộ trình gợi ý'),
          CareerCard(
            child: Column(
              children: [
                for (final title in _roadmapSteps(goal))
                  _StepLine(title: title),
              ],
            ),
          ),
          const CareerSectionTitle('Thị trường tham khảo'),
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(
                  text: 'Công ty ví dụ · không phải vị trí tuyển dụng',
                ),
                const SizedBox(height: 9),
                for (final name in _demoCompanies(goal.id))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.apartment,
                          size: 17,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Text(
                          'Ví dụ',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CareerPrimaryButton(
            label: isSelected
                ? 'Xem skill gap & roadmap'
                : 'Đặt làm mục tiêu hiện tại',
            icon: isSelected ? Icons.route_outlined : Icons.flag_outlined,
            onPressed: () {
              ref.read(careerGuidanceProvider.notifier).selectGoal(goal.id);
              if (isSelected) {
                context.push('/career/skill-gap');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã cập nhật mục tiêu trong phiên hiện tại.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class RoadmapOverviewScreen extends ConsumerWidget {
  const RoadmapOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerGuidanceProvider);
    final goal = selectedCareerGoal(state);
    if (goal == null) {
      return CareerPage(
        child: Column(
          children: [
            const CareerBackHeader(title: 'Roadmap'),
            const CareerCard(child: Text('Chưa chọn mục tiêu nghề nghiệp.')),
            CareerPrimaryButton(
              label: 'Chọn mục tiêu',
              onPressed: () => context.push('/career/goals'),
            ),
          ],
        ),
      );
    }
    final draft = ref.watch(careerDraftProvider);
    final gaps = goal.skills
        .where((skill) => !draftHasSkill(draft, skill))
        .toList();
    final completedResources = state.completedResourceIds.length;
    final steps = <String>[
      'Nền tảng kỹ thuật',
      for (final skill in gaps.take(2)) skill,
      'Thực hành dự án và tổng hợp',
    ];
    final percent = steps.isEmpty
        ? 0
        : (completedResources * 100 / steps.length).round().clamp(0, 100);
    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Roadmap học tập'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(
                  text: 'Roadmap demo · dữ liệu trong phiên',
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${steps.length} chặng gợi ý',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        color: AppColors.successTint,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                CareerProgressBar(
                  value: percent / 100,
                  color: AppColors.successAccent,
                ),
              ],
            ),
          ),
          const CareerSectionTitle(
            'Lộ trình học tập chi tiết',
            trailing: CareerDemoNote(text: 'Mốc gợi ý'),
          ),
          for (var index = 0; index < steps.length; index++) ...[
            _RoadmapMilestone(
              index: index,
              title: steps[index],
              current: index == 0,
              goal: goal,
            ),
            if (index != steps.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 18,
                  child: VerticalDivider(color: AppColors.blue, thickness: 2),
                ),
              ),
          ],
          const CareerSectionTitle('Cam kết lộ trình'),
          CareerCard(
            color: AppColors.blueTint,
            child: const Text(
              'Các mốc là gợi ý demo, không phải khóa học đã đăng ký hoặc tiến độ học thực tế. Có thể điều chỉnh mục tiêu và danh sách kỹ năng bất cứ lúc nào.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CareerPrimaryButton(
            label: 'Xem skill gap',
            icon: Icons.insights,
            onPressed: () => context.push('/career/skill-gap'),
          ),
        ],
      ),
    );
  }
}

class _RoadmapMilestone extends StatelessWidget {
  const _RoadmapMilestone({
    required this.index,
    required this.title,
    required this.current,
    required this.goal,
  });
  final int index;
  final String title;
  final bool current;
  final CareerGoal goal;
  @override
  Widget build(BuildContext context) => CareerCard(
    padding: const EdgeInsets.all(13),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: current
                  ? AppColors.blue
                  : AppColors.surfaceMuted,
              child: Icon(
                current ? Icons.play_arrow : Icons.lock_outline,
                size: 15,
                color: current ? Colors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'Chặng ${index + 1} · $title',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ),
            careerGapTag(current ? 'Gợi ý tiếp theo' : 'Chưa bắt đầu'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          current
              ? 'Bắt đầu bằng cách xem kỹ năng cần bổ sung cho mục tiêu ${goal.title}.'
              : 'Mốc tham khảo trong lộ trình ${goal.title}.',
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
        if (current) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/career/skill-priority'),
              child: const Text('Xem kỹ năng ưu tiên'),
            ),
          ),
        ],
      ],
    ),
  );
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.blue, size: 17),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}

List<String> _roadmapSteps(CareerGoal goal) => [
  'Đánh giá kỹ năng hiện tại theo hồ sơ',
  'Bổ sung ${goal.skills.firstWhere((skill) => !['Python', 'PostgreSQL', 'SQL'].contains(skill), orElse: () => goal.skills.first)}',
  'Thực hành và cập nhật hồ sơ cá nhân',
];

List<String> _demoCompanies(String goalId) => switch (goalId) {
  'backend-developer' => [
    'FPT Software',
    'VNG Corporation',
    'MoMo (M_Service)',
  ],
  'data-analyst' => [
    'Viettel Solutions',
    'MoMo (M_Service)',
    'Tiki Corporation',
  ],
  _ => ['FPT Software', 'VNG Corporation', 'KMS Technology'],
};

IconData _goalIcon(String id) => switch (id) {
  'backend-developer' => Icons.code,
  'data-analyst' => Icons.query_stats,
  _ => Icons.cloud_outlined,
};
