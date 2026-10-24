import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../models/job.dart';
import '../models/job_application.dart';
import '../state/job_application_state.dart';
import '../widgets/application_widgets.dart';
import '../widgets/job_widgets.dart';

class ApplyStepOneScreen extends ConsumerStatefulWidget {
  const ApplyStepOneScreen({required this.jobId, super.key});
  final String jobId;

  @override
  ConsumerState<ApplyStepOneScreen> createState() => _ApplyStepOneScreenState();
}

class _ApplyStepOneScreenState extends ConsumerState<ApplyStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _university;
  late final TextEditingController _major;
  late final TextEditingController _availability;

  @override
  void initState() {
    super.initState();
    final student = ref.read(careerDraftProvider);
    final existingDraft = ref.read(jobApplicationProvider).draft;
    final draft =
        existingDraft.jobId == widget.jobId &&
            existingDraft.submittedApplicationId == null
        ? existingDraft
        : ApplicationDraft(
            jobId: widget.jobId,
            fullName: student.fullName,
            phone: student.phone,
            university: student.university,
            major: student.major,
            availability: student.startAvailability,
          );
    _name = TextEditingController(text: draft.fullName);
    _email = TextEditingController(text: draft.email);
    _phone = TextEditingController(text: draft.phone);
    _university = TextEditingController(text: draft.university);
    _major = TextEditingController(text: draft.major);
    _availability = TextEditingController(text: draft.availability);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(jobApplicationProvider.notifier).begin(widget.jobId, student);
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _university.dispose();
    _major.dispose();
    _availability.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = demoJobs.where((job) => job.id == widget.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Ứng tuyển',
        body: Center(child: Text('Không tìm thấy việc làm.')),
      );
    }
    final job = jobs.first;

    return JobScreenScaffold(
      title: 'Quick Apply Flow',
      bottomAction: FilledButton.icon(
        onPressed: _continue,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Tiếp tục: Chọn CV nộp đơn'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            const ApplicationStepHeader(step: 1),
            const SizedBox(height: 12),
            _JobSummary(job: job),
            const SizedBox(height: 12),
            const ApplicationDemoNotice(),
            const SizedBox(height: 18),
            _input('Họ và tên', _name, validator: _required('Nhập họ và tên')),
            _input(
              'Email liên hệ',
              _email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nhập email liên hệ';
                }
                return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value.trim())
                    ? null
                    : 'Email chưa đúng định dạng';
              },
            ),
            _input(
              'Số điện thoại liên hệ',
              _phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nhập số điện thoại liên hệ';
                }
                return RegExp(r'^\+?[0-9() .-]{8,20}$').hasMatch(value.trim())
                    ? null
                    : 'Số điện thoại chưa hợp lệ';
              },
            ),
            _input(
              'Trường đào tạo',
              _university,
              validator: _required('Nhập trường đào tạo'),
            ),
            _input('Chuyên ngành', _major),
            _input(
              'Thời gian có thể bắt đầu',
              _availability,
              validator: _required('Nhập thời gian có thể bắt đầu'),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Chỉ nội dung bạn nhập trong luồng demo mới được dùng để tạo bản ghi cục bộ. Chưa có dữ liệu nào được gửi cho nhà tuyển dụng.',
                style: TextStyle(fontSize: 11, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? Function(String?) _required(String message) =>
      (value) => value == null || value.trim().isEmpty ? message : null;

  Widget _input(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    ),
  );

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    final applicationDraft = ref
        .read(jobApplicationProvider)
        .draft
        .copyWith(
          fullName: _name.text,
          email: _email.text,
          phone: _phone.text,
          university: _university.text,
          major: _major.text,
          availability: _availability.text,
        );
    ref.read(jobApplicationProvider.notifier).updateDraft(applicationDraft);
    final student = ref.read(careerDraftProvider);
    ref
        .read(careerDraftProvider.notifier)
        .update(
          student.copyWith(
            fullName: _name.text,
            phone: _phone.text,
            university: _university.text,
            major: _major.text,
            startAvailability: _availability.text,
          ),
        );
    context.push('/jobs/${widget.jobId}/select-cv');
  }
}

class _JobSummary extends StatelessWidget {
  const _JobSummary({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        JobLogo(company: job.company, size: 46),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '${job.company} · ${job.salaryLabel}',
                style: const TextStyle(fontSize: 11, color: AppColors.navy),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
