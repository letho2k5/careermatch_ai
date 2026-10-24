import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../models/job.dart';
import '../widgets/job_widgets.dart';

class CompareSkillsScreen extends ConsumerWidget {
  const CompareSkillsScreen({required this.jobId, super.key});
  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = demoJobs.where((item) => item.id == jobId);
    if (job.isEmpty) {
      return const JobScreenScaffold(
        title: 'Đối chiếu kỹ năng',
        body: Center(child: Text('Không tìm thấy việc làm.')),
      );
    }
    final selectedJob = job.first;
    final student = ref.watch(careerDraftProvider);
    final studentSkills = <String>{
      ...student.hardSkills.keys,
      ...student.extractedSkills.keys,
      ...student.softSkills,
    };
    final comparison = selectedJob.skills.map((requiredSkill) {
      final normalized = _normalize(requiredSkill);
      final matched = studentSkills.any((skill) {
        final candidate = _normalize(skill);
        return candidate == normalized ||
            candidate.contains(normalized) ||
            normalized.contains(candidate);
      });
      return (skill: requiredSkill, matched: matched);
    }).toList();
    final matchedCount = comparison.where((item) => item.matched).length;
    final score = comparison.isEmpty
        ? 0
        : (matchedCount * 100 / comparison.length).round();

    return JobScreenScaffold(
      title: 'Đối chiếu kỹ năng',
      bottomAction: FilledButton.icon(
        onPressed: () => context.push('/jobs/${selectedJob.id}/apply'),
        icon: const Icon(Icons.send_outlined),
        label: Text('Tiếp tục ứng tuyển ($score%)'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const JobPill(
            'Đối chiếu theo dữ liệu hồ sơ · demo cục bộ',
            icon: Icons.rule_outlined,
            color: AppColors.blueTint,
          ),
          const SizedBox(height: 12),
          Text(
            selectedJob.title,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text('${selectedJob.company} · ${selectedJob.location}'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 7,
                        backgroundColor: AppColors.surfaceMuted,
                        color: AppColors.successAccent,
                      ),
                      Center(
                        child: Text(
                          '$score%',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '$matchedCount / ${comparison.length} kỹ năng có trong hồ sơ sinh viên.',
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'KỸ NĂNG YÊU CẦU',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in comparison) ...[
            _SkillComparisonRow(skill: item.skill, matched: item.matched),
            const SizedBox(height: 8),
          ],
          if (comparison.isEmpty)
            const Text('Thiết kế chưa cung cấp kỹ năng để đối chiếu.'),
          const SizedBox(height: 12),
          const Text(
            'Kết quả được tính bằng so khớp tên kỹ năng trên dữ liệu hiện có; không phải kết quả phân tích AI.',
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9+#.]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

class _SkillComparisonRow extends StatelessWidget {
  const _SkillComparisonRow({required this.skill, required this.matched});
  final String skill;
  final bool matched;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: matched ? const Color(0xFFE9EDF1) : AppColors.blue,
        width: matched ? 1 : 2,
      ),
    ),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(skill, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  matched ? Icons.check_circle : Icons.info_outline,
                  size: 17,
                  color: matched ? AppColors.successAccent : AppColors.blue,
                ),
                const SizedBox(width: 5),
                Text(
                  matched ? 'Đã có trong hồ sơ' : 'Còn thiếu',
                  style: TextStyle(
                    fontSize: 11,
                    color: matched ? AppColors.success : AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 9),
        LinearProgressIndicator(
          value: matched ? 1 : .35,
          minHeight: 5,
          borderRadius: BorderRadius.circular(6),
          color: matched ? AppColors.successAccent : AppColors.blue,
          backgroundColor: AppColors.surfaceMuted,
        ),
      ],
    ),
  );
}
