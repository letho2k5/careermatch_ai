import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../employer/models/employer_demo_models.dart';
import '../../employer/state/employer_demo_state.dart';
import '../widgets/admin_widgets.dart';

class AdminJobsPendingScreen extends ConsumerStatefulWidget {
  const AdminJobsPendingScreen({super.key});
  @override
  ConsumerState<AdminJobsPendingScreen> createState() =>
      _AdminJobsPendingScreenState();
}

class _AdminJobsPendingScreenState
    extends ConsumerState<AdminJobsPendingScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pending =
        [
              ...ref.watch(employerDemoProvider).adminListings,
              ...ref.watch(employerDemoProvider).listings,
            ]
            .where((item) => item.status == 'Chờ duyệt')
            .where(
              (item) =>
                  ('${item.fields['title'] ?? ''} ${item.fields['company'] ?? ''}')
                      .toLowerCase()
                      .contains(_search.text.toLowerCase()),
            )
            .toList();
    return AdminPage(
      title: 'Tin tuyển dụng chờ duyệt',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tin tuyển dụng chờ duyệt',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    AdminStatusChip('${pending.length}'),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm vị trí hoặc doanh nghiệp',
                  ),
                ),
                const SizedBox(height: 8),
                const AdminDemoNotice(),
              ],
            ),
          ),
          Expanded(
            child: pending.isEmpty
                ? const Center(child: Text('Không có tin tuyển dụng chờ duyệt'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: pending.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _JobQueueCard(job: pending[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _JobQueueCard extends StatelessWidget {
  const _JobQueueCard({required this.job});
  final EmployerJobListing job;
  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.blueTint,
              child: Icon(Icons.work_outline, color: AppColors.navy),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.fields['title'] ?? 'Tin tuyển dụng',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.fields['company'] ?? 'Doanh nghiệp trong bản demo',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const AdminStatusChip('Chờ duyệt'),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _MetaChip(
              icon: Icons.location_on_outlined,
              label: job.fields['location'] ?? 'Chưa cung cấp',
            ),
            _MetaChip(
              icon: Icons.payments_outlined,
              label: job.fields['salary'] ?? 'Chưa cung cấp',
            ),
            _MetaChip(
              icon: Icons.work_history_outlined,
              label: job.fields['experience'] ?? 'Chưa cung cấp',
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/admin/jobs/${job.id}/review'),
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Xem chi tiết'),
          ),
        ),
      ],
    ),
  );
}

class AdminJobReviewDetailScreen extends ConsumerWidget {
  const AdminJobReviewDetailScreen({required this.jobId, super.key});
  final String jobId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.read(employerDemoProvider.notifier).listing(jobId);
    if (job == null) return _JobNotFound();
    final fields = job.fields;
    return AdminPage(
      title: 'Chi tiết xét duyệt tin',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Từ chối',
              onPressed: () => context.go('/admin/jobs/$jobId/reject'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppPrimaryButton(
              label: 'Phê duyệt',
              onPressed: () => context.go('/admin/jobs/$jobId/approve'),
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              const Text(
                'MÃ ĐỊNH DANH: ',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              Text('#${job.id}'),
            ],
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminStatusChip('CHỜ DUYỆT'),
                const SizedBox(height: 10),
                Text(
                  fields['title'] ?? 'Tin tuyển dụng',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fields['company'] ?? 'Doanh nghiệp demo',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const Divider(height: 24),
                _JobInfo(
                  label: 'Mức lương',
                  value: fields['salary'] ?? 'Chưa cung cấp',
                ),
                _JobInfo(
                  label: 'Địa điểm',
                  value: fields['location'] ?? 'Chưa cung cấp',
                ),
                _JobInfo(
                  label: 'Kinh nghiệm',
                  value: fields['experience'] ?? 'Chưa cung cấp',
                ),
                _JobInfo(
                  label: 'Phòng ban',
                  value: fields['department'] ?? 'Chưa cung cấp',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Mô tả công việc'),
          AdminCard(
            child: Text(
              fields['description'] ?? 'Chưa có mô tả trong hồ sơ demo.',
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Kỹ năng yêu cầu'),
          AdminCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (fields['skills'] ?? 'Chưa cung cấp')
                  .split(',')
                  .map(
                    (item) => _MetaChip(icon: Icons.check, label: item.trim()),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Quyền lợi'),
          AdminCard(
            child: Text(fields['benefits'] ?? 'Chưa có thông tin quyền lợi.'),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Rà soát chính sách'),
          const AdminCard(
            child: Column(
              children: [
                _PolicyRow(label: 'Thông tin công việc minh bạch'),
                _PolicyRow(label: 'Yêu cầu phù hợp cấp độ vị trí'),
                _PolicyRow(label: 'Đã xem nội dung SDG 8'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AdminDemoNotice(),
        ],
      ),
    );
  }
}

class AdminApproveJobScreen extends ConsumerStatefulWidget {
  const AdminApproveJobScreen({required this.jobId, super.key});
  final String jobId;
  @override
  ConsumerState<AdminApproveJobScreen> createState() =>
      _AdminApproveJobScreenState();
}

class _AdminApproveJobScreenState extends ConsumerState<AdminApproveJobScreen> {
  final _checks = [false, false, false];
  @override
  Widget build(BuildContext context) {
    final job = ref.read(employerDemoProvider.notifier).listing(widget.jobId);
    if (job == null) return _JobNotFound();
    return AdminPage(
      title: 'Phê duyệt tin tuyển dụng',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.task_alt, size: 56, color: AppColors.success),
          const SizedBox(height: 12),
          Text(
            'Xác nhận phê duyệt',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.fields['title'] ?? 'Tin tuyển dụng',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(job.fields['company'] ?? 'Doanh nghiệp demo'),
                const Divider(height: 24),
                _JobInfo(
                  label: 'Mức lương',
                  value: job.fields['salary'] ?? 'Chưa cung cấp',
                ),
                _JobInfo(
                  label: 'Địa điểm',
                  value: job.fields['location'] ?? 'Chưa cung cấp',
                ),
                const AdminStatusChip('ĐƯỢC DUYỆT TRONG DEMO', positive: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AdminSectionTitle('Checklist chính sách'),
          AdminCard(
            child: Column(
              children: List.generate(
                3,
                (index) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _checks[index],
                  onChanged: (value) =>
                      setState(() => _checks[index] = value ?? false),
                  title: Text(
                    [
                      'Mô tả và mức lương rõ ràng',
                      'Yêu cầu phù hợp vị trí',
                      'Nội dung phù hợp nguyên tắc SDG 8',
                    ][index],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const AdminDemoNotice(),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'Xác nhận duyệt demo',
            icon: Icons.check,
            onPressed: _checks.every((item) => item) ? _approve : null,
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Quay lại',
            onPressed: () => context.go('/admin/jobs/${widget.jobId}/review'),
          ),
        ],
      ),
    );
  }

  void _approve() {
    final changed = ref
        .read(employerDemoProvider.notifier)
        .moderateJob(widget.jobId, approved: true);
    if (!changed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã cập nhật trạng thái duyệt tin demo. Tin chưa được đăng công khai.',
        ),
      ),
    );
    context.go('/admin/jobs/pending');
  }
}

class AdminRejectJobScreen extends ConsumerStatefulWidget {
  const AdminRejectJobScreen({required this.jobId, super.key});
  final String jobId;
  @override
  ConsumerState<AdminRejectJobScreen> createState() =>
      _AdminRejectJobScreenState();
}

class _AdminRejectJobScreenState extends ConsumerState<AdminRejectJobScreen> {
  final _notes = TextEditingController();
  bool _notifyCompany = true;
  String? _reason;
  static const _reasons = [
    'Thiếu thông tin hoặc thông tin chưa rõ',
    'Mức lương không phù hợp',
    'Nội dung chưa phù hợp SDG 8',
    'Yêu cầu kinh nghiệm quá cao cho vị trí thực tập',
    'Lý do khác',
  ];
  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final job = ref.read(employerDemoProvider.notifier).listing(widget.jobId);
    if (job == null) return _JobNotFound();
    return AdminPage(
      title: 'Từ chối tin tuyển dụng',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AdminStatusChip('CẦN RÀ SOÁT LẠI'),
                  const SizedBox(height: 8),
                  Text(
                    job.fields['title'] ?? 'Tin tuyển dụng',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(job.fields['company'] ?? 'Doanh nghiệp demo'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const AdminSectionTitle('Chọn lý do từ chối *'),
            AdminCard(
              child: RadioGroup<String>(
                groupValue: _reason,
                onChanged: (value) => setState(() => _reason = value),
                child: Column(
                  children: _reasons
                      .map(
                        (reason) => RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          value: reason,
                          title: Text(
                            reason,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ghi chú bổ sung',
                hintText: 'Mô tả nội dung cần chỉnh sửa (nếu cần)',
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _notifyCompany,
              onChanged: (value) =>
                  setState(() => _notifyCompany = value ?? false),
              title: const Text('Đánh dấu cần thông báo doanh nghiệp'),
              subtitle: const Text(
                'Bản demo không gửi email.',
                style: TextStyle(fontSize: 12),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const AdminDemoNotice(),
            const SizedBox(height: 14),
            AppPrimaryButton(
              key: const ValueKey('admin-job-reject-confirm'),
              label: 'Xác nhận từ chối',
              icon: Icons.close,
              onPressed: _reject,
            ),
            const SizedBox(height: 8),
            AppSecondaryButton(
              label: 'Hủy',
              onPressed: () => context.go('/admin/jobs/${widget.jobId}/review'),
            ),
          ],
        ),
      ),
    );
  }

  void _reject() {
    if (_reason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn lý do từ chối.')),
      );
      return;
    }
    if (_reason == 'Lý do khác' && _notes.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng mô tả lý do khác.')),
      );
      return;
    }
    final reason =
        _reason! +
        (_notes.text.trim().isEmpty ? '' : ': ${_notes.text.trim()}');
    final changed = ref
        .read(employerDemoProvider.notifier)
        .moderateJob(widget.jobId, approved: false, reason: reason);
    if (!changed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật trạng thái từ chối tin demo.')),
    );
    context.go('/admin/jobs/pending');
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 15),
    label: Text(label, style: const TextStyle(fontSize: 11)),
    visualDensity: VisualDensity.compact,
    backgroundColor: const Color(0xFFF2F4F6),
    side: BorderSide.none,
  );
}

class _JobInfo extends StatelessWidget {
  const _JobInfo({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 18,
          color: AppColors.success,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class _JobNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Không tìm thấy',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 52, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy tin tuyển dụng',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Về danh sách',
              onPressed: () => context.go('/admin/jobs/pending'),
            ),
          ],
        ),
      ),
    ),
  );
}
