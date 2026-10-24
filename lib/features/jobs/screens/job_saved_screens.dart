import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_home/student_app_shell.dart';
import '../models/job.dart';
import '../state/job_discovery_state.dart';
import '../widgets/job_widgets.dart';

enum _SavedJobFilter { all, open, closingSoon }

class SavedJobsScreen extends ConsumerStatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  ConsumerState<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends ConsumerState<SavedJobsScreen> {
  _SavedJobFilter _filter = _SavedJobFilter.all;

  @override
  Widget build(BuildContext context) {
    final savedIds = ref.watch(
      jobDiscoveryProvider.select((state) => state.savedIds),
    );
    final savedJobs =
        demoJobs.where((job) => savedIds.contains(job.id)).toList()
          ..sort((a, b) => a.daysUntilDeadline.compareTo(b.daysUntilDeadline));
    final visibleJobs = savedJobs.where((job) {
      return switch (_filter) {
        _SavedJobFilter.all => true,
        _SavedJobFilter.open => job.daysUntilDeadline > 0,
        _SavedJobFilter.closingSoon =>
          job.daysUntilDeadline > 0 && job.daysUntilDeadline <= 3,
      };
    }).toList();

    return StudentAppShell(
      selectedTab: 1,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Việc làm đã lưu',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Chip(label: Text('${savedJobs.length} tin đã lưu')),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Danh sách chỉ lưu trong phiên hiện tại của bản demo.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _filterChip(_SavedJobFilter.all, 'Tất cả ${savedJobs.length}'),
              _filterChip(
                _SavedJobFilter.open,
                'Còn hạn ${savedJobs.where((job) => job.daysUntilDeadline > 0).length}',
              ),
              _filterChip(
                _SavedJobFilter.closingSoon,
                'Sắp hết hạn ${savedJobs.where((job) => job.daysUntilDeadline > 0 && job.daysUntilDeadline <= 3).length}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (visibleJobs.isEmpty)
            _SavedJobsEmptyState(hasSavedItems: savedJobs.isNotEmpty)
          else
            for (final job in visibleJobs) ...[
              _SavedJobCard(job: job),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  Widget _filterChip(_SavedJobFilter filter, String label) => ChoiceChip(
    label: Text(label),
    selected: _filter == filter,
    onSelected: (_) => setState(() => _filter = filter),
  );
}

class _SavedJobsEmptyState extends StatelessWidget {
  const _SavedJobsEmptyState({required this.hasSavedItems});
  final bool hasSavedItems;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 44),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Icon(Icons.bookmark_border, size: 42, color: AppColors.blue),
        const SizedBox(height: 12),
        Text(
          hasSavedItems
              ? 'Không có việc làm trong nhóm này'
              : 'Bạn chưa lưu việc làm nào',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Lưu tin tuyển dụng để xem lại tại đây. Danh sách sẽ được xóa khi kết thúc phiên demo.',
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

class _SavedJobCard extends ConsumerWidget {
  const _SavedJobCard({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: () => context.push('/jobs/${job.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobLogo(company: job.company, size: 42),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.company, style: const TextStyle(fontSize: 11)),
                      Text(
                        job.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Bỏ lưu việc làm',
                  onPressed: () {
                    ref.read(jobDiscoveryProvider.notifier).toggleSaved(job.id);
                    context.push('/jobs/${job.id}/save-confirmation');
                  },
                  icon: const Icon(Icons.favorite, color: AppColors.error),
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                JobPill('${job.matchScore}% Match', icon: Icons.auto_awesome),
                JobPill(job.location, icon: Icons.location_on_outlined),
                JobPill(
                  job.daysUntilDeadline <= 3
                      ? 'Sắp hết hạn'
                      : 'Còn ${job.daysUntilDeadline} ngày',
                  color: job.daysUntilDeadline <= 3
                      ? AppColors.errorTint
                      : AppColors.surfaceMuted,
                  icon: Icons.schedule,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.salaryLabel,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () => context.push('/jobs/${job.id}/apply'),
                  child: const Text('Ứng tuyển ngay'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class SaveConfirmationScreen extends ConsumerWidget {
  const SaveConfirmationScreen({required this.jobId, super.key});
  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = demoJobs.where((job) => job.id == jobId);
    final saved = ref.watch(
      jobDiscoveryProvider.select((state) => state.savedIds.contains(jobId)),
    );
    final job = jobs.isEmpty ? null : jobs.first;

    return Material(
      color: Colors.black54,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.pop(),
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .88,
                ),
                child: Container(
                  width: 430,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outline,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: saved
                              ? AppColors.blueTint
                              : AppColors.surfaceMuted,
                          child: Icon(
                            saved
                                ? Icons.bookmark_added
                                : Icons.bookmark_remove,
                            color: saved ? AppColors.blue : AppColors.textMuted,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          saved ? 'Đã lưu việc làm' : 'Đã bỏ lưu việc làm',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          job == null
                              ? 'Không tìm thấy việc làm.'
                              : saved
                              ? 'Tin đã được cập nhật trong danh sách đã lưu của phiên demo.'
                              : 'Tin đã được gỡ khỏi danh sách đã lưu của phiên demo.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (job != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                JobLogo(company: job.company, size: 42),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        job.company,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: saved
                                ? () => context.go('/jobs/saved')
                                : () => context.go('/jobs/home'),
                            icon: Icon(
                              saved ? Icons.bookmarks_outlined : Icons.search,
                            ),
                            label: Text(
                              saved
                                  ? 'Xem danh sách đã lưu'
                                  : 'Khám phá việc làm',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('Tiếp tục xem việc làm'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
