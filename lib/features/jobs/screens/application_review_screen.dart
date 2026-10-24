import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../models/job_application.dart';
import '../models/job.dart';
import '../state/job_application_state.dart';
import '../widgets/application_widgets.dart';
import '../widgets/job_widgets.dart';

class ApplicationReviewScreen extends ConsumerWidget {
  const ApplicationReviewScreen({required this.jobId, super.key});
  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = demoJobs.where((job) => job.id == jobId);
    final draft = ref.watch(jobApplicationProvider).draft;
    if (jobs.isEmpty || draft.jobId != jobId) {
      return const JobScreenScaffold(
        title: 'Xem lại hồ sơ',
        body: Center(child: Text('Không tìm thấy dữ liệu ứng tuyển.')),
      );
    }
    final job = jobs.first;

    return JobScreenScaffold(
      title: 'Quick Apply Flow',
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: () => _submit(context, ref, draft),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Xác nhận tạo bản ghi demo'),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bản ghi chỉ tồn tại trong phiên này; chưa gửi hồ sơ thật.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          const ApplicationStepHeader(step: 3),
          const SizedBox(height: 12),
          _ReviewJob(job: job),
          const SizedBox(height: 12),
          ApplicationDemoNotice(key: ValueKey('demo-review-${job.id}')),
          const SizedBox(height: 12),
          ApplicationSectionCard(
            title: 'Thông tin ứng viên',
            icon: Icons.person_outline,
            child: Column(
              children: [
                _reviewField('Họ và tên', draft.fullName),
                _reviewField('Số điện thoại', draft.phone),
                _reviewField('Email liên hệ', draft.email),
                _reviewField('Trường đào tạo', draft.university),
                if (draft.major.trim().isNotEmpty)
                  _reviewField('Chuyên ngành', draft.major),
                _reviewField('Thời gian bắt đầu', draft.availability),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => context.go('/jobs/$jobId/apply'),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Sửa thông tin'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ApplicationSectionCard(
            title: 'Hồ sơ năng lực (CV)',
            icon: Icons.description_outlined,
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: AppColors.error),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        draft.selectedCvName.isEmpty
                            ? 'Chưa chọn CV'
                            : draft.selectedCvName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        draft.selectedCvBytes == null
                            ? 'Không có tệp CV hợp lệ'
                            : '${formatApplicationFileSize(draft.selectedCvBytes!)} · metadata cục bộ',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/jobs/$jobId/select-cv'),
                  child: const Text('Đổi tệp'),
                ),
              ],
            ),
          ),
          if (draft.coverLetter.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            ApplicationSectionCard(
              title: 'Thư giới thiệu',
              icon: Icons.mail_outline,
              child: Text(draft.coverLetter),
            ),
          ],
          const SizedBox(height: 12),
          const ApplicationSectionCard(
            title: 'Quyền riêng tư',
            icon: Icons.shield_outlined,
            child: Text(
              'Nội dung này chỉ được lưu cục bộ trong bộ nhớ phiên để minh họa luồng ứng tuyển. Không có nhà tuyển dụng nào nhận được hồ sơ.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewField(String label, String value) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(value.trim().isEmpty ? 'Chưa cung cấp' : value),
      ],
    ),
  );

  void _submit(BuildContext context, WidgetRef ref, ApplicationDraft draft) {
    if (!draft.hasRequiredDetails) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy hoàn thiện thông tin ứng viên trước.'),
        ),
      );
      context.go('/jobs/$jobId/apply');
      return;
    }
    if (!draft.hasSelectedCv) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy chọn CV trước khi xác nhận.')),
      );
      context.go('/jobs/$jobId/select-cv');
      return;
    }
    final id = ref.read(jobApplicationProvider.notifier).submit();
    if (id == null) return;
    context.go('/applications/$id/success');
  }
}

class _ReviewJob extends StatelessWidget {
  const _ReviewJob({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        JobLogo(company: job.company, size: 44),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(job.company, style: const TextStyle(fontSize: 11)),
              Text(
                job.salaryLabel,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        JobPill('${job.matchScore}% Match'),
      ],
    ),
  );
}
