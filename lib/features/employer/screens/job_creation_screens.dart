import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/employer_demo_state.dart';
import 'employer_widgets.dart';

class CreateJobStepOneScreen extends ConsumerStatefulWidget {
  const CreateJobStepOneScreen({super.key});
  @override
  ConsumerState<CreateJobStepOneScreen> createState() =>
      _CreateJobStepOneScreenState();
}

class _CreateJobStepOneScreenState
    extends ConsumerState<CreateJobStepOneScreen> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final job = ref.watch(employerDemoProvider).job;
    final set = ref.read(employerDemoProvider.notifier).setJobField;
    return EmployerPage(
      title: 'Tạo tin tuyển dụng · Bước 1',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Lưu nháp',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bản nháp được giữ trong phiên chạy hiện tại.'),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppPrimaryButton(
              label: 'Tiếp tục: Kỹ năng & AI Match',
              icon: Icons.arrow_forward,
              onPressed: () {
                if (_form.currentState!.validate()) {
                  context.go('/employer/jobs/create/step-2');
                }
              },
            ),
          ),
        ],
      ),
      child: Form(
        key: _form,
        child: EmployerFormBody(
          children: [
            const SizedBox(height: 4),
            const _ProgressHeader(step: 1),
            employerSectionTitle('Thông tin vị trí tuyển dụng'),
            const Text(
              'Chuẩn hóa tiêu chuẩn việc làm thỏa đáng, không phân biệt đối xử và lương minh bạch.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            employerDemoNotice(
              'Tin này chỉ là bản nháp demo, chưa được đăng tuyển.',
            ),
            const SizedBox(height: 14),
            _JobField(
              label: 'Chức danh công việc',
              field: 'title',
              job: job,
              set: set,
              requiredField: true,
              hint: 'Backend Developer Intern',
            ),
            _JobField(
              label: 'Phòng ban / Nhóm dự án',
              field: 'department',
              job: job,
              set: set,
              requiredField: true,
              hint: 'Global Cloud & AI Solutions',
            ),
            _ChoiceField(
              label: 'Hình thức làm việc',
              field: 'workMode',
              job: job,
              choices: const ['Toàn thời gian', 'Bán thời gian', 'Thực tập'],
              set: set,
            ),
            _ChoiceField(
              label: 'Mô hình làm việc',
              field: 'workplace',
              job: job,
              choices: const ['On-site', 'Hybrid', 'Remote'],
              set: set,
            ),
            _JobField(
              label: 'Thành phố đặt trụ sở / văn phòng',
              field: 'location',
              job: job,
              set: set,
              requiredField: true,
              hint: 'TP. Hồ Chí Minh',
            ),
            employerSectionTitle('Mức trả cấp / Lương tháng minh bạch'),
            const Text(
              'Cam kết theo SDG 8: Không chấp nhận những thỏa thuận mù mờ về lương.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _JobField(
                    label: 'Từ (VNĐ)',
                    field: 'salaryMin',
                    job: job,
                    set: set,
                    requiredField: true,
                    numeric: true,
                    hint: '8.000.000',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _JobField(
                    label: 'Đến (VNĐ)',
                    field: 'salaryMax',
                    job: job,
                    set: set,
                    requiredField: true,
                    numeric: true,
                    hint: '12.000.000',
                  ),
                ),
              ],
            ),
            _JobField(
              label: 'Số lượng cần tuyển',
              field: 'headcount',
              job: job,
              set: set,
              requiredField: true,
              numeric: true,
              hint: '5',
            ),
            _JobField(
              label: 'Hạn nhận hồ sơ',
              field: 'deadline',
              job: job,
              set: set,
              requiredField: true,
              dateField: true,
              hint: '31/12/2026',
            ),
            _JobField(
              label: 'Mô tả công việc tóm tắt',
              field: 'description',
              job: job,
              set: set,
              requiredField: true,
              lines: 4,
              hint: 'Mô tả trách nhiệm và phạm vi công việc',
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.verified_outlined, color: AppColors.blue),
                title: Text('Chứng nhận Môi trường Bình đẳng'),
                subtitle: Text('Chưa thực hiện đánh giá trong bản demo.'),
              ),
            ),
            const SizedBox(height: 84),
          ],
        ),
      ),
    );
  }
}

class CreateJobStepTwoScreen extends ConsumerStatefulWidget {
  const CreateJobStepTwoScreen({super.key});
  @override
  ConsumerState<CreateJobStepTwoScreen> createState() =>
      _CreateJobStepTwoScreenState();
}

class _CreateJobStepTwoScreenState
    extends ConsumerState<CreateJobStepTwoScreen> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final job = ref.watch(employerDemoProvider).job;
    final set = ref.read(employerDemoProvider.notifier).setJobField;
    return EmployerPage(
      title: 'Tạo tin tuyển dụng · Bước 2',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Quay lại',
              onPressed: () => context.go('/employer/jobs/create/step-1'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppPrimaryButton(
              label: 'Xem trước tin tuyển dụng',
              icon: Icons.arrow_forward,
              onPressed: () {
                if (_form.currentState!.validate()) {
                  context.go('/employer/jobs/create/preview');
                }
              },
            ),
          ),
        ],
      ),
      child: Form(
        key: _form,
        child: EmployerFormBody(
          children: [
            const _ProgressHeader(step: 2),
            employerSectionTitle('Trọng số Kỹ năng & AI Match Score'),
            const Text(
              'Thiết lập kỹ năng và trọng số minh họa; không có AI nào đang phân tích hồ sơ.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFD9F7E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppColors.success),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tổng trọng số: 100%\nĐây là cấu hình demo, chưa dùng để chấm điểm ứng viên.',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            employerSectionTitle('Kỹ năng cốt lõi bắt buộc'),
            _JobField(
              label: 'Kỹ năng kỹ thuật (phân cách bằng dấu phẩy)',
              field: 'hardSkills',
              job: job,
              set: set,
              requiredField: true,
              lines: 3,
              hint: 'Python / FastAPI, PostgreSQL, Docker',
            ),
            _JobField(
              label: 'Tỷ trọng kỹ năng kỹ thuật (%)',
              field: 'hardWeight',
              job: job,
              set: set,
              requiredField: true,
              numeric: true,
              hint: '80',
            ),
            employerSectionTitle('Kỹ năng mềm & Phương pháp'),
            _JobField(
              label: 'Kỹ năng mềm (phân cách bằng dấu phẩy)',
              field: 'softSkills',
              job: job,
              set: set,
              lines: 3,
              hint: 'Git Flow, tư duy giải quyết vấn đề',
            ),
            _JobField(
              label: 'Tỷ trọng kỹ năng mềm (%)',
              field: 'softWeight',
              job: job,
              set: set,
              numeric: true,
              hint: '20',
            ),
            employerSectionTitle('Tùy chọn kích hoạt AI & SDG 8'),
            Card(
              child: SwitchListTile(
                title: const Text('Ưu tiên chứng chỉ xác thực'),
                subtitle: const Text('Cấu hình tùy chọn trong bản demo.'),
                value: job['verifiedBadge'] == 'true',
                onChanged: (value) => set('verifiedBadge', '$value'),
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('Gợi ý lộ trình đào tạo bù'),
                subtitle: const Text('Minh họa gợi ý, không gọi AI thật.'),
                value: job['trainingPath'] == 'true',
                onChanged: (value) => set('trainingPath', '$value'),
              ),
            ),
            const SizedBox(height: 84),
          ],
        ),
      ),
    );
  }
}

class JobPreviewScreen extends ConsumerWidget {
  const JobPreviewScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employerDemoProvider);
    final job = state.job;
    if (!state.hasJobDraft || (job['title'] ?? '').trim().isEmpty) {
      return EmployerPage(
        title: 'Xem trước tin',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_note,
                  size: 56,
                  color: AppColors.textMuted,
                ),
                employerSectionTitle('Bản nháp chưa hoàn tất'),
                const Text(
                  'Hãy nhập chức danh công việc ở Bước 1 trước khi xem trước.',
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  label: 'Quay lại Bước 1',
                  onPressed: () => context.go('/employer/jobs/create/step-1'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final companyName = state.company['name']?.trim();
    final skills = (job['hardSkills'] ?? '')
        .split(',')
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    return EmployerPage(
      title: 'Xem trước tin tuyển dụng',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Chỉnh sửa lại',
              icon: Icons.edit,
              onPressed: () => context.go('/employer/jobs/create/step-1'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: AppPrimaryButton(
              label: 'Gửi duyệt tin',
              icon: Icons.save_outlined,
              onPressed: () {
                context.go('/employer/jobs/submit');
              },
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.blueTint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: AppColors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'CHẾ ĐỘ XEM TRƯỚC (BẢN NHÁP)',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.business_center_outlined,
                      color: AppColors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['title'] ?? 'Chưa đặt chức danh',
                      style: const TextStyle(
                        fontSize: 19,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      companyName?.isNotEmpty == true
                          ? companyName!
                          : 'Tên công ty chưa thiết lập',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(job['location'] ?? 'Chưa có địa điểm'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: [
                        _PreviewChip(job['workplace'] ?? 'Chưa chọn mô hình'),
                        _PreviewChip(
                          job['deadline']?.isNotEmpty == true
                              ? 'Hạn nộp: ${job['deadline']}'
                              : 'Chưa có hạn nộp',
                        ),
                        _PreviewChip(
                          job['headcount']?.isNotEmpty == true
                              ? 'Chỉ tiêu: ${job['headcount']} ứng viên'
                              : 'Chưa có chỉ tiêu',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    employerDemoNotice(
                      'Tin chưa được xuất bản và chưa thể nhận hồ sơ thật.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    employerSectionTitle(
                      'Ma trận đối soát năng lực tuyển dụng',
                    ),
                    if (skills.isEmpty)
                      const Text('Chưa thêm kỹ năng bắt buộc.'),
                    for (final skill in skills)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 7,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(skill)),
                            Text(
                              '${job['hardWeight'] ?? '80'}% trọng số',
                              style: const TextStyle(
                                color: AppColors.blue,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if ((job['softSkills'] ?? '').trim().isNotEmpty)
                      Text('Kỹ năng mềm: ${job['softSkills']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    employerSectionTitle('Mô tả công việc & Cơ hội học tập'),
                    Text(
                      job['description']?.isNotEmpty == true
                          ? job['description']!
                          : 'Chưa có mô tả công việc',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.shield_outlined, color: AppColors.success),
                title: Text('Quyền lợi chuẩn việc làm bền vững'),
                subtitle: Text(
                  'Nội dung quyền lợi minh họa trong bản thiết kế.',
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.step});
  final int step;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.blue,
                child: Text(
                  '$step',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bước $step / 2${step == 1 ? ': Thông tin & Chuẩn mực SDG 8' : ''}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${step * 50}% hoàn thành',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: step / 2,
            minHeight: 6,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
    ),
  );
}

class _JobField extends StatelessWidget {
  const _JobField({
    required this.label,
    required this.field,
    required this.job,
    required this.set,
    this.requiredField = false,
    this.numeric = false,
    this.dateField = false,
    this.lines = 1,
    this.hint,
  });
  final String label, field;
  final Map<String, String> job;
  final void Function(String, String) set;
  final bool requiredField, numeric;
  final bool dateField;
  final int lines;
  final String? hint;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        TextFormField(
          initialValue: job[field] ?? '',
          keyboardType: numeric ? TextInputType.number : null,
          maxLines: lines,
          minLines: lines > 1 ? 3 : 1,
          onChanged: (value) => set(field, value),
          decoration: InputDecoration(hintText: hint ?? label),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (requiredField && text.isEmpty) return 'Vui lòng nhập $label';
            if (numeric && text.isNotEmpty) {
              final digits = text.replaceAll(RegExp(r'[\s,.]'), '');
              final number = int.tryParse(digits);
              if (!RegExp(r'^\d+$').hasMatch(digits) ||
                  number == null ||
                  number < 1) {
                return 'Vui lòng nhập số lớn hơn 0';
              }
              if (field == 'salaryMax') {
                final minimum = (job['salaryMin'] ?? '').replaceAll(
                  RegExp(r'[^\d]'),
                  '',
                );
                final minimumNumber = int.tryParse(minimum);
                if (minimumNumber != null && number <= minimumNumber) {
                  return 'Mức lương tối đa phải cao hơn mức tối thiểu';
                }
              }
            }
            if (dateField && text.isNotEmpty) {
              final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$')
                  .firstMatch(text);
              if (match == null) return 'Dùng định dạng ngày/tháng/năm';
              final day = int.parse(match.group(1)!);
              final month = int.parse(match.group(2)!);
              final year = int.parse(match.group(3)!);
              final date = DateTime(year, month, day);
              if (date.day != day || date.month != month || date.year != year) {
                return 'Ngày không hợp lệ';
              }
            }
            return null;
          },
        ),
      ],
    ),
  );
}

class _ChoiceField extends StatelessWidget {
  const _ChoiceField({
    required this.label,
    required this.field,
    required this.job,
    required this.choices,
    required this.set,
  });
  final String label, field;
  final Map<String, String> job;
  final List<String> choices;
  final void Function(String, String) set;
  @override
  Widget build(BuildContext context) {
    final selected = job[field] ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final choice in choices)
                ChoiceChip(
                  label: Text(choice, style: const TextStyle(fontSize: 11)),
                  selected: selected == choice,
                  onSelected: (_) => set(field, choice),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Chip(
    label: Text(text, style: const TextStyle(fontSize: 10)),
    visualDensity: VisualDensity.compact,
    backgroundColor: AppColors.surfaceMuted,
    side: BorderSide.none,
  );
}
