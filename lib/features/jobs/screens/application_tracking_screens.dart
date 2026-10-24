import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_home/student_app_shell.dart';
import '../models/job.dart';
import '../models/job_application.dart';
import '../state/job_application_state.dart';
import '../widgets/application_widgets.dart';
import '../widgets/job_widgets.dart';

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(jobApplicationProvider).applications;
    return StudentAppShell(
      selectedTab: 3,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Hồ sơ đã ứng tuyển',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text('Bản ghi demo trong phiên: ${applications.length}'),
          const SizedBox(height: 12),
          const ApplicationDemoNotice(),
          const SizedBox(height: 14),
          if (applications.isEmpty)
            const _NoApplicationsState()
          else
            for (final application in applications) ...[
              _ApplicationListCard(application: application),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _NoApplicationsState extends StatelessWidget {
  const _NoApplicationsState();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 30),
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Icon(Icons.assignment_outlined, size: 42, color: AppColors.blue),
        const SizedBox(height: 10),
        const Text(
          'Chưa có bản ghi ứng tuyển demo',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        const SizedBox(height: 6),
        const Text(
          'Các hồ sơ chỉ xuất hiện sau khi bạn hoàn tất luồng demo. Không có dữ liệu ứng tuyển mẫu được tạo sẵn.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: () => context.go('/jobs/home'),
          icon: const Icon(Icons.search),
          label: const Text('Khám phá việc làm'),
        ),
      ],
    ),
  );
}

class _ApplicationListCard extends StatelessWidget {
  const _ApplicationListCard({required this.application});
  final JobApplication application;

  @override
  Widget build(BuildContext context) {
    final jobs = demoJobs.where((job) => job.id == application.jobId);
    if (jobs.isEmpty) return const SizedBox.shrink();
    final job = jobs.first;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.push('/applications/${application.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  JobLogo(company: job.company, size: 42),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(job.company, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  JobPill('${job.matchScore}%'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 15,
                    color: AppColors.blue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(application.demoStatusLabel)),
                  TextButton(
                    onPressed: () => context.push(
                      '/applications/${application.id}/timeline',
                    ),
                    child: const Text('Timeline'),
                  ),
                ],
              ),
              Text(
                'CV: ${application.cvName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({required this.applicationId, super.key});
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref
        .watch(jobApplicationProvider)
        .applications
        .where((item) => item.id == applicationId);
    if (application.isEmpty) {
      return const JobScreenScaffold(
        title: 'Chi tiết ứng tuyển',
        body: Center(child: Text('Không tìm thấy bản ghi ứng tuyển.')),
      );
    }
    final record = application.first;
    final jobs = demoJobs.where((job) => job.id == record.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Chi tiết ứng tuyển',
        body: Center(child: Text('Không tìm thấy việc làm liên quan.')),
      );
    }
    final job = jobs.first;

    return JobScreenScaffold(
      title: 'Chi tiết hồ sơ demo',
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: () =>
                context.push('/applications/$applicationId/timeline'),
            icon: const Icon(Icons.timeline),
            label: const Text('Xem trạng thái timeline'),
          ),
          const SizedBox(height: 5),
          TextButton.icon(
            onPressed: () => _removeDemo(context, ref),
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            label: const Text(
              'Xóa bản ghi demo',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          const ApplicationDemoNotice(),
          const SizedBox(height: 12),
          _ApplicationJobCard(job: job, application: record),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Chỉ có mốc tạo bản ghi demo. Không có trạng thái nhà tuyển dụng nào được xác nhận.',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ApplicationSectionCard(
            title: 'Tài liệu đính kèm',
            icon: Icons.description_outlined,
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: AppColors.error),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.cvName),
                      Text(
                        '${formatApplicationFileSize(record.cvBytes)} · chỉ lưu metadata trong phiên',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ApplicationSectionCard(
            title: 'Thông tin ứng viên',
            icon: Icons.person_outline,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detail('Họ và tên', record.fullName),
                _detail('Email', record.email),
                _detail('Điện thoại', record.phone),
                _detail('Trường', record.university),
                if (record.major.isNotEmpty)
                  _detail('Chuyên ngành', record.major),
                _detail('Thời gian bắt đầu', record.availability),
              ],
            ),
          ),
          if (record.coverLetter.isNotEmpty) ...[
            const SizedBox(height: 12),
            ApplicationSectionCard(
              title: 'Thư giới thiệu',
              icon: Icons.mail_outline,
              child: Text(record.coverLetter),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );

  Future<void> _removeDemo(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bản ghi demo?'),
        content: const Text(
          'Thao tác này chỉ xóa bản ghi khỏi bộ nhớ phiên hiện tại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Giữ lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(jobApplicationProvider.notifier).remove(applicationId);
      if (context.mounted) context.go('/applications');
    }
  }
}

class _ApplicationJobCard extends StatelessWidget {
  const _ApplicationJobCard({required this.job, required this.application});
  final Job job;
  final JobApplication application;

  @override
  Widget build(BuildContext context) => ApplicationSectionCard(
    title: 'Vị trí đã chọn',
    icon: Icons.work_outline,
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
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(job.company),
              Text(job.salaryLabel, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );
}

class ApplicationTimelineScreen extends ConsumerWidget {
  const ApplicationTimelineScreen({required this.applicationId, super.key});
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref
        .watch(jobApplicationProvider)
        .applications
        .where((item) => item.id == applicationId);
    if (application.isEmpty) {
      return const JobScreenScaffold(
        title: 'Dòng thời gian demo',
        body: Center(child: Text('Không tìm thấy bản ghi ứng tuyển.')),
      );
    }
    final record = application.first;
    final jobs = demoJobs.where((job) => job.id == record.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Dòng thời gian demo',
        body: Center(child: Text('Không tìm thấy việc làm liên quan.')),
      );
    }

    return JobScreenScaffold(
      title: 'Application Status Timeline',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ApplicationDemoNotice(key: ValueKey('timeline-demo-$applicationId')),
          const SizedBox(height: 12),
          _TimelineJobSummary(job: jobs.first, application: record),
          const SizedBox(height: 14),
          const ApplicationSectionCard(
            title: 'Các mốc trạng thái',
            icon: Icons.timeline,
            child: Column(
              children: [
                _TimelineEntry(
                  title: 'Đã tạo bản ghi ứng tuyển demo',
                  detail: 'Chỉ lưu trong bộ nhớ phiên, chưa gửi tới công ty.',
                  state: _TimelineState.complete,
                  isLast: false,
                ),
                _TimelineEntry(
                  title: 'Nhà tuyển dụng xem hồ sơ',
                  detail: 'Chưa diễn ra · không có kết nối nhà tuyển dụng.',
                  state: _TimelineState.pending,
                  isLast: false,
                ),
                _TimelineEntry(
                  title: 'Phỏng vấn',
                  detail: 'Chưa có lịch phỏng vấn.',
                  state: _TimelineState.pending,
                  isLast: false,
                ),
                _TimelineEntry(
                  title: 'Kết quả tuyển dụng',
                  detail: 'Chưa có kết quả.',
                  state: _TimelineState.pending,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.push('/applications/$applicationId'),
            icon: const Icon(Icons.description_outlined),
            label: const Text('Quay lại chi tiết ứng tuyển demo'),
          ),
        ],
      ),
    );
  }
}

class _TimelineJobSummary extends StatelessWidget {
  const _TimelineJobSummary({required this.job, required this.application});
  final Job job;
  final JobApplication application;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
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
              Text(job.company),
              Text(application.demoStatusLabel),
            ],
          ),
        ),
      ],
    ),
  );
}

enum _TimelineState { complete, current, pending }

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.title,
    required this.detail,
    required this.state,
    required this.isLast,
  });

  final String title;
  final String detail;
  final _TimelineState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      _TimelineState.complete => AppColors.successAccent,
      _TimelineState.current => AppColors.blue,
      _TimelineState.pending => AppColors.outline,
    };
    final icon = switch (state) {
      _TimelineState.complete => Icons.check,
      _TimelineState.current => Icons.more_horiz,
      _TimelineState.pending => Icons.circle_outlined,
    };
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color,
                  child: Icon(icon, size: 14, color: Colors.white),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.outline),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: state == _TimelineState.pending
                    ? AppColors.surfaceMuted
                    : AppColors.blueTint.withValues(alpha: .48),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: state == _TimelineState.pending
                          ? AppColors.textSecondary
                          : AppColors.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
