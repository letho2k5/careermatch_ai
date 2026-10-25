import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class CareerMilestonesScreen extends ConsumerWidget {
  const CareerMilestonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    if (goal == null) return const _CareerMilestoneNotFound();
    final draft = ref.watch(careerDraftProvider);
    final state = ref.watch(careerGuidanceProvider);
    final milestones = milestonesForGoal(goal, draft);
    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: 'Xem tiến độ học tập',
        icon: Icons.insights,
        onPressed: () => context.push('/career/progress'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Roadmap Milestone'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(text: 'Lộ trình gợi ý · dữ liệu cục bộ'),
                const SizedBox(height: 9),
                Text(
                  goal.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${milestones.length} milestone · trạng thái được tính từ các nhiệm vụ bạn tự đánh dấu',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          CareerSectionTitle(
            'Các milestone',
            trailing: Text(
              '${_completedMilestones(milestones, state)} / ${milestones.length} hoàn tất',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
          if (milestones.isEmpty)
            const CareerCard(child: Text('Chưa có milestone cho mục tiêu này.'))
          else
            for (var index = 0; index < milestones.length; index++) ...[
              _MilestoneListCard(
                milestone: milestones[index],
                index: index,
                state: state,
                onTap: () => context.push(
                  '/career/roadmap/milestones/${milestones[index].id}',
                ),
              ),
              const SizedBox(height: 10),
            ],
          CareerCard(
            color: AppColors.blueTint,
            child: const Text(
              'Đánh dấu một nhiệm vụ là cập nhật tiến độ cá nhân trong phiên. Ứng dụng chưa xác minh hoạt động học bên ngoài.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 76),
        ],
      ),
    );
  }
}

class _MilestoneListCard extends StatelessWidget {
  const _MilestoneListCard({
    required this.milestone,
    required this.index,
    required this.state,
    required this.onTap,
  });
  final CareerMilestone milestone;
  final int index;
  final CareerGuidanceState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final done = _completedTasks(milestone, state);
    final total = milestone.tasks.length;
    final complete = total > 0 && done == total;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: CareerCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: complete
                      ? AppColors.successAccent
                      : AppColors.blueTint,
                  child: Icon(
                    complete ? Icons.check : Icons.route_outlined,
                    size: 16,
                    color: complete ? Colors.white : AppColors.blue,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    milestone.title,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                careerGapTag(complete ? 'Hoàn tất' : '$done/$total'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              milestone.description,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 9),
            CareerProgressBar(value: total == 0 ? 0 : done / total),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final skill in milestone.skills) careerGapTag(skill),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: Text(index == 0 ? 'Xem nhiệm vụ' : 'Chi tiết'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CareerMilestoneDetailScreen extends ConsumerWidget {
  const CareerMilestoneDetailScreen({required this.milestoneId, super.key});
  final String milestoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    final draft = ref.watch(careerDraftProvider);
    final state = ref.watch(careerGuidanceProvider);
    final milestone = goal == null
        ? null
        : milestonesForGoal(
            goal,
            draft,
          ).where((item) => item.id == milestoneId).firstOrNull;
    if (goal == null || milestone == null) {
      return const _CareerMilestoneNotFound();
    }
    final done = _completedTasks(milestone, state);
    final complete =
        milestone.tasks.isNotEmpty && done == milestone.tasks.length;
    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: 'Xem tiến độ tổng thể',
        icon: Icons.insights,
        onPressed: () => context.push('/career/progress'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Chi tiết milestone'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.title,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    careerGapTag(complete ? 'Hoàn tất' : 'Đang thực hiện'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  milestone.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  milestone.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                CareerProgressBar(
                  value: milestone.tasks.isEmpty
                      ? 0
                      : done / milestone.tasks.length,
                  color: AppColors.successAccent,
                ),
                const SizedBox(height: 6),
                Text(
                  '$done/${milestone.tasks.length} nhiệm vụ được tự đánh dấu',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
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
                for (final skill in milestone.skills) careerGapTag(skill),
              ],
            ),
          ),
          CareerSectionTitle(
            'Nhiệm vụ & bài học',
            trailing: const CareerDemoNote(text: 'Danh sách gợi ý'),
          ),
          for (final (index, task) in milestone.tasks.indexed) ...[
            _MilestoneTaskTile(
              milestone: milestone,
              task: task,
              index: index,
              done: state.milestoneTaskDoneIds.contains(
                '${milestone.id}:${task.id}',
              ),
              onChanged: () => ref
                  .read(careerGuidanceProvider.notifier)
                  .toggleMilestoneTask(milestone.id, task.id),
            ),
            const SizedBox(height: 8),
          ],
          CareerCard(
            color: AppColors.blueTint,
            child: const Text(
              'Trạng thái chỉ ghi nhận thao tác tự đánh dấu trên thiết bị trong phiên này; chưa có hoạt động học hoặc bài kiểm tra được xác minh.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 78),
        ],
      ),
    );
  }
}

class _MilestoneTaskTile extends StatelessWidget {
  const _MilestoneTaskTile({
    required this.milestone,
    required this.task,
    required this.index,
    required this.done,
    required this.onChanged,
  });
  final CareerMilestone milestone;
  final CareerMilestoneTask task;
  final int index;
  final bool done;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => CareerCard(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: CheckboxListTile(
        value: done,
        onChanged: (_) => onChanged(),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          '${index + 1}. ${task.title}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description, style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 5),
              Text(
                '${task.duration} · ${milestone.skills.join(', ')}',
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CareerProgressTrackingScreen extends ConsumerWidget {
  const CareerProgressTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    if (goal == null) return const _CareerMilestoneNotFound();
    final draft = ref.watch(careerDraftProvider);
    final state = ref.watch(careerGuidanceProvider);
    final milestones = milestonesForGoal(goal, draft);
    final totalTasks = milestones.fold<int>(
      0,
      (sum, item) => sum + item.tasks.length,
    );
    final completeTasks = state.milestoneTaskDoneIds
        .where(
          (key) =>
              milestones.any((milestone) => key.startsWith('${milestone.id}:')),
        )
        .length;
    final progress = totalTasks == 0
        ? 0
        : (completeTasks * 100 / totalTasks).round();
    final matchedSkills = goal.skills
        .where((skill) => draftHasSkill(draft, skill))
        .length;
    final completedMilestones = _completedMilestones(milestones, state);
    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Theo dõi tiến độ'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CareerDemoNote(text: 'Tổng hợp trong phiên hiện tại'),
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
                        '$completeTasks / $totalTasks nhiệm vụ tự đánh dấu',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: const TextStyle(
                        color: AppColors.successTint,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                CareerProgressBar(
                  value: progress / 100,
                  color: AppColors.successAccent,
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Tổng quan'),
          Row(
            children: [
              _ProgressMetric(
                value: '$completedMilestones/${milestones.length}',
                label: 'Milestone hoàn tất',
                icon: Icons.flag_outlined,
              ),
              const SizedBox(width: 8),
              _ProgressMetric(
                value: '$matchedSkills/${goal.skills.length}',
                label: 'Kỹ năng khớp hồ sơ',
                icon: Icons.psychology_outlined,
              ),
            ],
          ),
          const CareerSectionTitle('Tiến độ theo milestone'),
          if (milestones.isEmpty)
            const CareerCard(
              child: Text('Chưa có milestone trong roadmap này.'),
            )
          else
            for (final milestone in milestones) ...[
              _ProgressMilestoneRow(milestone: milestone, state: state),
              const SizedBox(height: 8),
            ],
          const CareerSectionTitle('Hoạt động gần đây'),
          const CareerCard(
            child: Text(
              'Chưa có lịch sử hoạt động theo ngày. Tiến độ phía trên chỉ tính các nhiệm vụ đã tự đánh dấu trong phiên hiện tại.',
              style: TextStyle(fontSize: 11, height: 1.4),
            ),
          ),
          const CareerSectionTitle('Tiến độ kỹ năng'),
          CareerCard(
            child: Column(
              children: [
                for (final skill in goal.skills)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          draftHasSkill(draft, skill)
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: draftHasSkill(draft, skill)
                              ? AppColors.successAccent
                              : AppColors.textMuted,
                          size: 17,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            skill,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        Text(
                          draftHasSkill(draft, skill)
                              ? 'Có trong hồ sơ'
                              : 'Còn thiếu',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const CareerSectionTitle('Chia sẻ / xuất báo cáo'),
          const CareerCard(
            child: Text(
              'Xuất PDF và chia sẻ báo cáo chưa được triển khai. Không tạo tệp hoặc gửi dữ liệu ra ngoài.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 14),
          CareerPrimaryButton(
            label: 'Xem các milestone',
            icon: Icons.route_outlined,
            onPressed: () => context.push('/career/roadmap/milestones'),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value, label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Expanded(
    child: CareerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blue, size: 19),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    ),
  );
}

class _ProgressMilestoneRow extends StatelessWidget {
  const _ProgressMilestoneRow({required this.milestone, required this.state});
  final CareerMilestone milestone;
  final CareerGuidanceState state;
  @override
  Widget build(BuildContext context) {
    final done = _completedTasks(milestone, state);
    return InkWell(
      onTap: () => context.push('/career/roadmap/milestones/${milestone.id}'),
      child: CareerCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.route_outlined, color: AppColors.blue),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CareerProgressBar(
                    value: milestone.tasks.isEmpty
                        ? 0
                        : done / milestone.tasks.length,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$done/${milestone.tasks.length}',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

int _completedTasks(CareerMilestone milestone, CareerGuidanceState state) =>
    milestone.tasks
        .where(
          (task) =>
              state.milestoneTaskDoneIds.contains('${milestone.id}:${task.id}'),
        )
        .length;

int _completedMilestones(
  List<CareerMilestone> milestones,
  CareerGuidanceState state,
) => milestones
    .where(
      (milestone) =>
          milestone.tasks.isNotEmpty &&
          _completedTasks(milestone, state) == milestone.tasks.length,
    )
    .length;

class _CareerMilestoneNotFound extends StatelessWidget {
  const _CareerMilestoneNotFound();
  @override
  Widget build(BuildContext context) => CareerPage(
    child: Column(
      children: [
        const CareerBackHeader(title: 'Không tìm thấy milestone'),
        const CareerCard(
          child: Text('Milestone này không có trong roadmap hiện tại.'),
        ),
        const SizedBox(height: 14),
        CareerPrimaryButton(
          label: 'Về roadmap',
          onPressed: () => context.go('/career/roadmap'),
        ),
      ],
    ),
  );
}
