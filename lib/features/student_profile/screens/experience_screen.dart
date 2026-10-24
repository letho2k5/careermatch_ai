import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../student_draft.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});
  @override
  ConsumerState<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends ConsumerState<ExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Kinh nghiệm & Hoạt động',
            trailing: TextButton.icon(
              onPressed: () => _addExperience(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm mới'),
            ),
          ),
          const ProfileStepIndicator(step: 3, label: 'Hồ sơ ứng viên SDG 8'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, AppColors.navyLight],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LỜI KHUYÊN TUYỂN DỤNG  •  Tác động +35%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kinh nghiệm có thể gồm dự án môn học, đồ án tốt nghiệp, nghiên cứu khoa học hoặc hoạt động câu lạc bộ.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2 điểm kinh nghiệm đã liên kết',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Sẵn sàng đối sánh tiêu chuẩn việc làm tử tế',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _message(context, 'Đây là dữ liệu minh họa từ thiết kế.'),
                  child: const Text('Tốt'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (d.experiences.isEmpty) _emptyExperience(context),
          for (var i = 0; i < d.experiences.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _experienceCard(context, d.experiences[i], i),
            ),
          SectionCard(
            title: 'Bạn còn dự án nhóm hoặc chứng chỉ GitHub?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bổ sung liên kết để nhà tuyển dụng hiểu rõ hơn về năng lực của bạn.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () =>
                      _message(context, 'Kết nối GitHub chưa được cấu hình.'),
                  icon: const Icon(Icons.link),
                  label: const Text('Nhập tự động từ GitHub URL'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'Lưu & Hoàn tất kinh nghiệm',
            icon: Icons.check_circle_outline,
            onPressed: () => context.go('/cv-upload'),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => context.go('/cv-upload'),
              child: const Text('Bỏ qua bước này'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyExperience(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.work_history_outlined,
          size: 36,
          color: AppColors.textMuted,
        ),
        const SizedBox(height: 8),
        const Text(
          'Chưa có kinh nghiệm',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        const SizedBox(height: 4),
        const Text(
          'Bạn có thể thêm dự án học tập, CLB hoặc bỏ qua bước này.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _addExperience(context),
          icon: const Icon(Icons.add),
          label: const Text('Thêm kinh nghiệm'),
        ),
      ],
    ),
  );

  Widget _experienceCard(
    BuildContext context,
    ExperienceDraft e,
    int index,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.work_outline, color: AppColors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                e.title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') _editExperience(context, e, index);
                if (v == 'delete') {
                  final current = ref.read(careerDraftProvider);
                  ref
                      .read(careerDraftProvider.notifier)
                      .update(
                        current.copyWith(
                          experiences: [...current.experiences]
                            ..removeAt(index),
                        ),
                      );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                PopupMenuItem(value: 'delete', child: Text('Xóa')),
              ],
            ),
          ],
        ),
        Text(
          e.organization,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 5),
        Text(
          e.period,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        Text(e.description, style: const TextStyle(fontSize: 11, height: 1.4)),
        if (index == 0)
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/student_project.png',
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 60,
                  child: Icon(Icons.photo_outlined),
                ),
              ),
            ),
          ),
        if (index == 1)
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/student_club.png',
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 60,
                  child: Icon(Icons.groups_outlined),
                ),
              ),
            ),
          ),
        if (e.skills.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 5,
              children: e.skills
                  .map(
                    (s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 10)),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    ),
  );

  Future<void> _addExperience(BuildContext context) async =>
      _editExperience(context, null, -1);
  Future<void> _editExperience(
    BuildContext context,
    ExperienceDraft? old,
    int index,
  ) async {
    final title = TextEditingController(text: old?.title),
        organization = TextEditingController(text: old?.organization),
        period = TextEditingController(text: old?.period),
        description = TextEditingController(text: old?.description);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(old == null ? 'Thêm kinh nghiệm' : 'Chỉnh sửa kinh nghiệm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Tên dự án / vai trò',
                ),
              ),
              TextField(
                controller: organization,
                decoration: const InputDecoration(
                  labelText: 'Tổ chức / bối cảnh',
                ),
              ),
              TextField(
                controller: period,
                decoration: const InputDecoration(labelText: 'Thời gian'),
              ),
              TextField(
                controller: description,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Mô tả đóng góp'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (result == true && title.text.trim().isNotEmpty) {
      final current = ref.read(careerDraftProvider);
      final list = [...current.experiences];
      final entry = ExperienceDraft(
        title: title.text.trim(),
        organization: organization.text.trim(),
        period: period.text.trim(),
        description: description.text.trim(),
      );
      if (index < 0) {
        list.add(entry);
      } else {
        list[index] = entry;
      }
      ref
          .read(careerDraftProvider.notifier)
          .update(current.copyWith(experiences: list));
    }
    title.dispose();
    organization.dispose();
    period.dispose();
    description.dispose();
  }

  void _message(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
