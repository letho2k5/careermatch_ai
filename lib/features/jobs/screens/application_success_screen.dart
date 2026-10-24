import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../models/job.dart';
import '../state/job_application_state.dart';
import '../widgets/application_widgets.dart';
import '../widgets/job_widgets.dart';

class ApplicationSuccessScreen extends ConsumerWidget {
  const ApplicationSuccessScreen({required this.applicationId, super.key});
  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref
        .watch(jobApplicationProvider)
        .applications
        .where((item) => item.id == applicationId);
    if (application.isEmpty) {
      return const JobScreenScaffold(
        title: 'Ứng tuyển demo',
        body: Center(child: Text('Không tìm thấy bản ghi ứng tuyển demo.')),
      );
    }
    final record = application.first;
    final jobs = demoJobs.where((item) => item.id == record.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Ứng tuyển demo',
        body: Center(child: Text('Không tìm thấy việc làm liên quan.')),
      );
    }
    final job = jobs.first;
    final timestamp = record.submittedAt;
    final date =
        '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
    final time =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    return JobScreenScaffold(
      title: 'Ứng tuyển demo',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
        children: [
          const Icon(Icons.check_circle, size: 76, color: AppColors.blue),
          const SizedBox(height: 18),
          const Text(
            'Đã tạo bản ghi ứng tuyển demo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hồ sơ chỉ được ghi vào bộ nhớ của ứng dụng trong phiên này. Chưa gửi tới nhà tuyển dụng.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          const ApplicationDemoNotice(),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã demo: $applicationId'),
                const Divider(height: 20),
                Row(
                  children: [
                    JobLogo(company: job.company, size: 46),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(job.company),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Thời điểm tạo bản ghi: $time · $date'),
                const SizedBox(height: 8),
                Text('CV đã chọn: ${record.cvName}'),
                const SizedBox(height: 8),
                const Chip(
                  avatar: Icon(Icons.info_outline, size: 16),
                  label: Text('Trạng thái: demo cục bộ'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => context.go('/applications/$applicationId'),
            icon: const Icon(Icons.timeline),
            label: const Text('Xem chi tiết bản ghi demo'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.go('/applications'),
            icon: const Icon(Icons.folder_open_outlined),
            label: const Text('Danh sách ứng tuyển'),
          ),
        ],
      ),
    );
  }
}
