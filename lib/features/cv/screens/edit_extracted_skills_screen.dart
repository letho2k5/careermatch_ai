import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../../student_profile/student_draft.dart';

class EditExtractedSkillsScreen extends ConsumerStatefulWidget {
  const EditExtractedSkillsScreen({super.key});
  @override
  ConsumerState<EditExtractedSkillsScreen> createState() =>
      _EditExtractedSkillsScreenState();
}

class _EditExtractedSkillsScreenState
    extends ConsumerState<EditExtractedSkillsScreen> {
  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    final ctrl = ref.read(careerDraftProvider.notifier);
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Kiểm tra kỹ năng trích xuất',
            trailing: TextButton(
              onPressed: () => context.go('/cv-analysis-result'),
              child: const Text('Xong'),
            ),
          ),
          const Center(
            child: Text(
              'BƯỚC 3 / 3',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.blueTint.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.blue,
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quyền kiểm soát thuộc về bạn  •  AI Copilot',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'AI chỉ đóng vai trò gợi ý. Bạn có toàn quyền xác nhận, chỉnh sửa mức độ hoặc xóa các kỹ năng trước khi gửi nhà tuyển dụng.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
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
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColors.success),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Chuẩn minh bạch SDG 8\nKhông đánh giá thiên vị bằng AI',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DemoPill(label: 'Độ tin cậy 96% • demo'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kỹ năng tự động phát hiện',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '${d.extractedSkills.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Chạm để chỉnh cấp độ',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final entry in d.extractedSkills.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: _skillRow(
                entry.key,
                entry.value,
                (level) {
                  final m = {...d.extractedSkills, entry.key: level};
                  ctrl.update(d.copyWith(extractedSkills: m));
                },
                () {
                  final m = {...d.extractedSkills}..remove(entry.key);
                  ctrl.update(d.copyWith(extractedSkills: m));
                },
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _addSkill(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Thêm kỹ năng bị bỏ sót'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kỹ năng AI nghi vấn',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const DemoPill(label: 'Cần bạn xác nhận'),
            ],
          ),
          const SizedBox(height: 8),
          for (final skill in d.suspectedSkills)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _suspected(
                skill,
                () {
                  ctrl.update(
                    d.copyWith(
                      extractedSkills: {...d.extractedSkills, skill: 'Cơ bản'},
                      suspectedSkills: [...d.suspectedSkills]..remove(skill),
                    ),
                  );
                },
                () {
                  ctrl.update(
                    d.copyWith(
                      suspectedSkills: [...d.suspectedSkills]..remove(skill),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8EE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              children: [
                Icon(Icons.public, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cam kết Việc làm Bền vững',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        'Hồ sơ xác thực kỹ năng giúp bạn tiếp cận các cơ hội có chế độ đãi ngộ công bằng.',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: d.confirmedExtractedSkills,
            onChanged: (v) =>
                ctrl.update(d.copyWith(confirmedExtractedSkills: v ?? false)),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Tôi xác nhận các kỹ năng trên phản ánh đúng năng lực thực tế của bản thân theo chuẩn tuyển dụng minh bạch SDG 8.',
              style: TextStyle(fontSize: 10, height: 1.35),
            ),
          ),
          const SizedBox(height: 8),
          AppPrimaryButton(
            label: 'Hoàn tất hồ sơ & Đi đến việc làm',
            icon: Icons.arrow_forward,
            onPressed: () {
              if (!d.confirmedExtractedSkills) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Vui lòng xác nhận danh sách kỹ năng trước khi hoàn tất.',
                    ),
                  ),
                );
                return;
              }
              context.go('/student-home');
            },
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Hệ thống AI không được kết nối; thao tác này chỉ hoàn tất luồng giao diện demo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillRow(
    String name,
    String level,
    ValueChanged<String> onLevel,
    VoidCallback onRemove,
  ) => Container(
    margin: EdgeInsets.zero,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.circle, size: 7, color: AppColors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String>(
            initialValue: level,
            isExpanded: true,
            isDense: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
            ),
            items: const ['Cơ bản', 'Trung cấp', 'Nâng cao', 'Thành thạo']
                .map(
                  (x) => DropdownMenuItem(
                    value: x,
                    child: Text(x, style: const TextStyle(fontSize: 10)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onLevel(v);
            },
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onRemove,
          icon: const Icon(Icons.close, size: 17, color: AppColors.textMuted),
        ),
      ],
    ),
  );

  Widget _suspected(String skill, VoidCallback onAdd, VoidCallback onSkip) =>
      Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const DemoPill(label: '68% • demo'),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Phát hiện qua mô tả môn học hoặc đồ án (gợi ý minh họa).',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text(
                      'Thêm vào hồ sơ',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSkip,
                    child: const Text('Bỏ qua', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Future<void> _addSkill(BuildContext context) async {
    final input = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm kỹ năng bị bỏ sót'),
        content: TextField(
          controller: input,
          decoration: const InputDecoration(hintText: 'Tên kỹ năng'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    input.dispose();
    if (name != null && name.isNotEmpty) {
      final d = ref.read(careerDraftProvider);
      ref
          .read(careerDraftProvider.notifier)
          .update(
            d.copyWith(extractedSkills: {...d.extractedSkills, name: 'Cơ bản'}),
          );
    }
  }
}
