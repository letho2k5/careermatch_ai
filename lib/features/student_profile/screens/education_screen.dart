import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../student_draft.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});
  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _school,
      _degree,
      _major,
      _from,
      _to,
      _gpa,
      _thesis;
  bool _showPrevious = false;
  @override
  void initState() {
    super.initState();
    final d = ref.read(careerDraftProvider);
    _school = TextEditingController(text: d.university);
    _degree = TextEditingController(text: d.degree);
    _major = TextEditingController(text: d.major);
    _from = TextEditingController(text: d.educationFrom);
    _to = TextEditingController(text: d.educationTo);
    _gpa = TextEditingController(text: d.gpa);
    _thesis = TextEditingController(text: d.thesis);
  }

  @override
  void dispose() {
    _school.dispose();
    _degree.dispose();
    _major.dispose();
    _from.dispose();
    _to.dispose();
    _gpa.dispose();
    _thesis.dispose();
    super.dispose();
  }

  void _save() {
    final current = ref.read(careerDraftProvider);
    ref
        .read(careerDraftProvider.notifier)
        .update(
          current.copyWith(
            university: _school.text.trim(),
            degree: _degree.text.trim(),
            major: _major.text.trim(),
            educationFrom: _from.text.trim(),
            educationTo: _to.text.trim(),
            gpa: _gpa.text.trim(),
            thesis: _thesis.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    return StudentPage(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentBackRow(
              title: 'Học vấn & Bằng cấp',
              trailing: TextButton.icon(
                onPressed: () => _addEducation(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm mới'),
              ),
            ),
            const Text(
              'Hồ sơ ứng viên SDG 8 • Việc làm bền vững',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navyLight, AppColors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.school, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI MATCH SIGNAL   +18% tỷ lệ mời phỏng vấn',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Thông tin học vấn chuẩn xác giúp đối sánh đúng bậc kỹ sư.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Thông tin học vấn chính',
              trailing: const DemoPill(label: 'Đang chỉnh sửa'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blueTint.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.account_balance, color: AppColors.navy),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ĐHQG TP.HCM',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Đang chỉnh sửa • Bậc chính quy',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DemoPill(label: 'VNU'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _school,
                    decoration: profileInput('Trường Đại học / Cao đẳng *'),
                    validator: _required,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _degree,
                    decoration: profileInput('Bậc đào tạo *'),
                    validator: _required,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _major,
                    decoration: profileInput('Chuyên ngành đào tạo *'),
                    validator: _required,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gợi ý AI:',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  Wrap(
                    spacing: 6,
                    children: ['AI & Data Science', 'Cloud Systems']
                        .map(
                          (x) => ActionChip(
                            label: Text(x),
                            onPressed: () {
                              _major.text = x;
                              _save();
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _from,
                          readOnly: true,
                          decoration: profileInput(
                            'Từ tháng',
                            suffixIcon: const Icon(Icons.calendar_month),
                          ),
                          onTap: () => _pickMonth(context, _from),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _to,
                          readOnly: true,
                          decoration: profileInput(
                            'Dự kiến tốt nghiệp',
                            suffixIcon: const Icon(Icons.event),
                          ),
                          onTap: () => _pickMonth(context, _to),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _gpa,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: profileInput(
                      'Điểm trung bình tích lũy (GPA)',
                      hint: '3.42',
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: Text('/ 4.0'),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      final g = double.tryParse(v.replaceAll(',', '.'));
                      return g == null || g < 0 || g > 4
                          ? 'Nhập GPA trong khoảng 0–4'
                          : null;
                    },
                    onChanged: (_) => _save(),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: d.showGpa,
                    onChanged: (v) {
                      final current = ref.read(careerDraftProvider);
                      ref
                          .read(careerDraftProvider.notifier)
                          .update(current.copyWith(showGpa: v));
                    },
                    title: const Text(
                      'Hiển thị trên hồ sơ ứng tuyển',
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: const Text(
                      'Nhà tuyển dụng sẽ thấy điểm số này',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  TextFormField(
                    controller: _thesis,
                    maxLines: 3,
                    decoration: profileInput(
                      'Đề tài tốt nghiệp / Nghiên cứu khoa học',
                    ),
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F8EE),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      'Nội dung bạn cung cấp chỉ được dùng để đối sánh trong hồ sơ này.',
                      style: TextStyle(color: AppColors.success, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            for (final e in d.educationHistory)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(e.school),
                    subtitle: Text('${e.degree} • ${e.period}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Sửa học vấn',
                          onPressed: () => _editEducation(context, e),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Xóa học vấn',
                          onPressed: () {
                            final current = ref.read(careerDraftProvider);
                            ref
                                .read(careerDraftProvider.notifier)
                                .update(
                                  current.copyWith(
                                    educationHistory: [
                                      ...current.educationHistory,
                                    ]..remove(e),
                                  ),
                                );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (d.educationHistory.isEmpty)
              InkWell(
                onTap: () => setState(() => _showPrevious = !_showPrevious),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history_edu_outlined,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'THPT Chuyên Lê Hồng Phong',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Chuyên Tin học • 2018 - 2021',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => _showPrevious = !_showPrevious),
                        child: Text(_showPrevious ? 'Ẩn' : 'Sửa'),
                      ),
                    ],
                  ),
                ),
              ),
            if (_showPrevious) _previousEducationEditor(),
            const SizedBox(height: 14),
            AppPrimaryButton(
              label: 'Lưu thông tin học vấn',
              icon: Icons.save_outlined,
              onPressed: () {
                if (_form.currentState!.validate()) {
                  _save();
                  context.go('/student-skills');
                }
              },
            ),
            const SizedBox(height: 8),
            AppSecondaryButton(
              label: 'Hủy',
              onPressed: () => context.go('/student-profile-setup-2'),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Trường này là bắt buộc' : null;
  Widget _previousEducationEditor() => const Padding(
    padding: EdgeInsets.only(top: 8),
    child: Text(
      'Mục học vấn này là nội dung mẫu trong Figma; hãy thêm thông tin phù hợp với bạn ở trên.',
      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
    ),
  );

  Future<void> _pickMonth(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month),
      firstDate: DateTime(1990),
      lastDate: DateTime(now.year + 12),
    );
    if (selected != null) {
      controller.text =
          '${selected.month.toString().padLeft(2, '0')}/${selected.year}';
      _save();
    }
  }

  Future<void> _addEducation(BuildContext context) async {
    final record = await _showEducationDialog(context);
    if (record == null) return;
    final current = ref.read(careerDraftProvider);
    ref
        .read(careerDraftProvider.notifier)
        .update(
          current.copyWith(
            educationHistory: [...current.educationHistory, record],
          ),
        );
  }

  Future<void> _editEducation(
    BuildContext context,
    EducationRecord record,
  ) async {
    final updatedRecord = await _showEducationDialog(context, initial: record);
    if (updatedRecord == null) return;
    final current = ref.read(careerDraftProvider);
    final updated = [...current.educationHistory];
    final index = updated.indexOf(record);
    if (index == -1) return;
    updated[index] = updatedRecord;
    ref
        .read(careerDraftProvider.notifier)
        .update(current.copyWith(educationHistory: updated));
  }

  Future<EducationRecord?> _showEducationDialog(
    BuildContext context, {
    EducationRecord? initial,
  }) => showDialog<EducationRecord>(
    context: context,
    builder: (_) => _EducationEditorDialog(initial: initial),
  );
}

class _EducationEditorDialog extends StatefulWidget {
  const _EducationEditorDialog({this.initial});

  final EducationRecord? initial;

  @override
  State<_EducationEditorDialog> createState() => _EducationEditorDialogState();
}

class _EducationEditorDialogState extends State<_EducationEditorDialog> {
  late final TextEditingController _school;
  late final TextEditingController _degree;
  late final TextEditingController _period;

  @override
  void initState() {
    super.initState();
    _school = TextEditingController(text: widget.initial?.school ?? '');
    _degree = TextEditingController(text: widget.initial?.degree ?? '');
    _period = TextEditingController(text: widget.initial?.period ?? '');
  }

  @override
  void dispose() {
    _school.dispose();
    _degree.dispose();
    _period.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.initial == null ? 'Th?m h?c v?n' : 'S?a h?c v?n'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _school,
          decoration: const InputDecoration(labelText: 'Tr??ng'),
        ),
        TextField(
          controller: _degree,
          decoration: const InputDecoration(labelText: 'B?ng c?p'),
        ),
        TextField(
          controller: _period,
          decoration: const InputDecoration(labelText: 'Ni?n kh?a'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('H?y'),
      ),
      FilledButton(
        onPressed: () {
          if (_school.text.trim().isEmpty) return;
          Navigator.pop(
            context,
            EducationRecord(
              school: _school.text.trim(),
              degree: _degree.text.trim(),
              period: _period.text.trim(),
            ),
          );
        },
        child: Text(widget.initial == null ? 'Th?m' : 'L?u'),
      ),
    ],
  );
}
