import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../student_draft.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});
  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  final _search = TextEditingController();
  String _query = '';
  static const _suggestions = [
    'Docker',
    'Redis',
    'Agile/Scrum',
    'Tiếng Anh B2',
  ];
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    final ctrl = ref.read(careerDraftProvider.notifier);
    final hard = d.hardSkills.entries
        .where((e) => e.key.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Kỹ năng của bạn',
            trailing: TextButton(
              onPressed: () {
                _saveAndLeave(context);
              },
              child: const Text('Lưu thay đổi'),
            ),
          ),
          const Text(
            'SDG 8 • Năng lực tuyển dụng công bằng',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          SectionCard(
            title: 'AI Profile Sync',
            trailing: const DemoPill(label: '86%'),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Độ sẵn sàng: 86%',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hệ thống đối soát kỹ năng với các công việc SDG 8 tương thích.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircularProgressIndicator(
                        value: .86,
                        strokeWidth: 5,
                      ),
                      Text(
                        '86%',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm kiếm kỹ năng (vd: Python, React, SQL...)',
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _addSkill(context),
                icon: const Icon(Icons.tune, color: AppColors.navy),
                tooltip: 'Thêm kỹ năng',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _sectionHeading(
            'Kỹ năng chuyên môn (Hard Skills)',
            hard.length,
            Icons.credit_card,
          ),
          SectionCard(
            title: '',
            child: Wrap(
              spacing: 8,
              runSpacing: 2,
              children: [
                for (final entry in hard)
                  InputChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            entry.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _levelBadge(entry.value),
                      ],
                    ),
                    onDeleted: () {
                      final map = {...d.hardSkills}..remove(entry.key);
                      ctrl.update(d.copyWith(hardSkills: map));
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionHeading(
            'Kỹ năng mềm (Soft Skills)',
            d.softSkills.length,
            Icons.psychology_outlined,
          ),
          SectionCard(
            title: '',
            child: Wrap(
              spacing: 8,
              runSpacing: 2,
              children: [
                for (final skill in d.softSkills)
                  InputChip(
                    label: Text(skill),
                    onDeleted: () => ctrl.update(
                      d.copyWith(softSkills: [...d.softSkills]..remove(skill)),
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
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: AppColors.navy,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Gợi ý tăng Match Score (+15%)',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Chạm để thêm',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _suggestions.map((skill) {
                    final has =
                        d.hardSkills.containsKey(skill) ||
                        d.softSkills.contains(skill);
                    return ActionChip(
                      label: Text('${has ? '✓' : '+'} $skill'),
                      onPressed: has
                          ? null
                          : () {
                              ctrl.update(
                                d.copyWith(
                                  hardSkills: {
                                    ...d.hardSkills,
                                    skill: 'Cơ bản',
                                  },
                                ),
                              );
                            },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _verificationCard(),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.blue),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Kỹ năng này sẽ được dùng để đối soát Match Score với các tin tuyển dụng.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'Xác nhận kỹ năng',
            icon: Icons.arrow_forward,
            onPressed: () {
              if (d.hardSkills.isEmpty && d.softSkills.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thêm ít nhất một kỹ năng để tiếp tục.'),
                  ),
                );
                return;
              }
              _saveAndLeave(context);
            },
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Bảo mật dữ liệu cá nhân theo tiêu chuẩn tuyển dụng minh bạch',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String label, int count, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(icon, color: AppColors.blue, size: 17),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.surfaceMuted,
          child: Text('$count', style: const TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
  Widget _levelBadge(String level) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.blueTint,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Text(
      level,
      style: const TextStyle(fontSize: 9, color: AppColors.navy),
    ),
  );
  Widget _verificationCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Image.asset(
          'assets/images/student_project.png',
          width: 56,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.verified, color: AppColors.success),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verified Decent Work',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Kỹ năng được kiểm chứng giúp sinh viên tiếp cận các vị trí thực tập có trả lương chuẩn quy định.',
                style: TextStyle(fontSize: 10, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Future<void> _addSkill(BuildContext context) async {
    final c = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm kỹ năng'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: 'Tên kỹ năng'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, c.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    c.dispose();
    if (value != null && value.isNotEmpty) {
      final d = ref.read(careerDraftProvider);
      ref
          .read(careerDraftProvider.notifier)
          .update(d.copyWith(hardSkills: {...d.hardSkills, value: 'Cơ bản'}));
    }
  }

  void _saveAndLeave(BuildContext context) {
    context.go('/student-experience');
  }
}
