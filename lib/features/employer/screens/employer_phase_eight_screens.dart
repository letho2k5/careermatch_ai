import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../models/employer_demo_models.dart';
import '../state/employer_demo_state.dart';
import 'employer_widgets.dart';

class SubmitEmployerJobScreen extends ConsumerWidget {
  const SubmitEmployerJobScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employerDemoProvider);
    final job = state.job;
    return EmployerPage(
      title: 'Gửi duyệt tin tuyển dụng',
      bottom: AppPrimaryButton(
        label: 'Gửi duyệt tin tuyển dụng',
        icon: Icons.send_outlined,
        onPressed: () {
          if ((job['title'] ?? '').trim().isEmpty ||
              (job['department'] ?? '').trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Vui lòng hoàn tất chức danh và phòng ban trước khi gửi.',
                ),
              ),
            );
            context.go('/employer/jobs/create/step-1');
            return;
          }
          final id = ref.read(employerDemoProvider.notifier).submitDraft();
          if (id != null) context.go('/employer/jobs/pending?jobId=$id');
        },
      ),
      child: _Body(
        children: [
          const _DemoNotice(
            'Bản xem lại cục bộ. Không có AI thẩm định hoặc đăng tin lên máy chủ.',
          ),
          _SectionCard(
            title: 'Mã hồ sơ tin',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'] ?? 'Chưa có chức danh',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  '${job['department'] ?? 'Chưa có phòng ban'} · ${job['location'] ?? 'Chưa có địa điểm'}',
                ),
                Text(
                  '${job['salaryMin'] ?? '—'} - ${job['salaryMax'] ?? '—'} VNĐ',
                ),
                const SizedBox(height: 12),
                Text(job['description'] ?? 'Chưa có mô tả'),
                const SizedBox(height: 10),
                Text('Kỹ năng: ${job['hardSkills'] ?? 'Chưa khai báo'}'),
                Text('Trọng số kỹ năng: ${job['hardWeight'] ?? '—'}%'),
              ],
            ),
          ),
          const _SectionCard(
            title: 'Thông tin quy trình',
            child: Text(
              'Sau thao tác này, tin được đánh dấu “Chờ duyệt” trong phiên demo hiện tại. Không có quy trình kiểm duyệt thật.',
            ),
          ),
        ],
      ),
    );
  }
}

class EmployerJobPendingScreen extends ConsumerWidget {
  const EmployerJobPendingScreen({super.key, this.jobId});
  final String? jobId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = jobId == null
        ? null
        : ref
              .watch(employerDemoProvider)
              .listings
              .where((j) => j.id == jobId)
              .firstOrNull;
    if (item == null) {
      return _NotFoundPage(title: 'Không tìm thấy tin tuyển dụng');
    }
    return EmployerPage(
      title: 'Tin chờ duyệt',
      child: _Body(
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            size: 62,
            color: AppColors.blue,
          ),
          const Text(
            'ĐANG CHỜ DUYỆT · DEMO',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            item.fields['title'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const _DemoNotice(
            'Tin chỉ được thêm vào danh sách cục bộ trong phiên chạy. Chưa được gửi tới hệ thống tuyển dụng.',
          ),
          AppPrimaryButton(
            label: 'Xem chi tiết tin',
            onPressed: () => context.go('/employer/jobs/${item.id}'),
          ),
          AppSecondaryButton(
            label: 'Về danh sách tin',
            onPressed: () => context.go('/employer/jobs'),
          ),
        ],
      ),
    );
  }
}

class EmployerJobDetailScreen extends ConsumerWidget {
  const EmployerJobDetailScreen({super.key, required this.jobId});
  final String jobId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref
        .watch(employerDemoProvider)
        .listings
        .where((j) => j.id == jobId)
        .firstOrNull;
    if (item == null) {
      return _NotFoundPage(title: 'Không tìm thấy tin tuyển dụng');
    }
    return EmployerPage(
      title: 'Chi tiết tin tuyển dụng',
      child: _Body(
        children: [
          _DemoNotice('Dữ liệu tin demo · ${item.status}'),
          _SectionCard(
            title: item.fields['title'] ?? 'Tin tuyển dụng',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.fields['department'] ?? ''),
                Text(item.fields['location'] ?? ''),
                Text(
                  '${item.fields['salaryMin'] ?? '—'} - ${item.fields['salaryMax'] ?? '—'} VNĐ',
                ),
                const Divider(),
                Text(item.fields['description'] ?? 'Chưa có mô tả'),
                Text('Kỹ năng: ${item.fields['hardSkills'] ?? '—'}'),
              ],
            ),
          ),
          AppPrimaryButton(
            label: 'Sửa tin',
            icon: Icons.edit_outlined,
            onPressed: () => context.go('/employer/jobs/$jobId/edit'),
          ),
        ],
      ),
    );
  }
}

class EditEmployerJobScreen extends ConsumerStatefulWidget {
  const EditEmployerJobScreen({super.key, required this.jobId});
  final String jobId;
  @override
  ConsumerState<EditEmployerJobScreen> createState() =>
      _EditEmployerJobScreenState();
}

class _EditEmployerJobScreenState extends ConsumerState<EditEmployerJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  EmployerJobListing? _item;

  @override
  void initState() {
    super.initState();
    _item = ref
        .read(employerDemoProvider)
        .listings
        .where((j) => j.id == widget.jobId)
        .firstOrNull;
    _controllers = {
      for (final key in const [
        'title',
        'department',
        'location',
        'salaryMin',
        'salaryMax',
        'description',
        'hardSkills',
      ])
        key: TextEditingController(text: _item?.fields[key] ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) return const _NotFoundPage(title: 'Job not found');
    return EmployerPage(
      title: 'Edit job',
      bottom: AppPrimaryButton(
        label: 'Save changes',
        icon: Icons.save_outlined,
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          final fields = Map<String, String>.of(_item!.fields)
            ..addAll({
              for (final entry in _controllers.entries)
                entry.key: entry.value.text.trim(),
            });
          ref
              .read(employerDemoProvider.notifier)
              .updateListing(widget.jobId, fields);
          context.go('/employer/jobs/${widget.jobId}');
        },
      ),
      child: Form(
        key: _formKey,
        child: _Body(
          children: [
            const _DemoNotice(
              'Changes update this local demo listing for this session only.',
            ),
            for (final entry in _controllers.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: entry.value,
                  maxLines:
                      entry.key == 'description' || entry.key == 'hardSkills'
                      ? 3
                      : 1,
                  decoration: InputDecoration(
                    labelText: _fieldLabel(entry.key),
                  ),
                  validator: (value) =>
                      ['title', 'department'].contains(entry.key) &&
                          (value == null || value.trim().isEmpty)
                      ? 'This field is required'
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EmployerCandidateListScreen extends ConsumerWidget {
  const EmployerCandidateListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employerDemoProvider);
    final candidates = employerDemoCandidates
        .where(
          (c) =>
              c.match >= state.candidateMatchMinimum &&
              (!state.verifiedCandidatesOnly || c.skills.isNotEmpty),
        )
        .toList();
    return EmployerPage(
      title: 'Ứng viên',
      actions: [
        IconButton(
          onPressed: () => context.go('/employer/candidates/filters'),
          icon: const Icon(Icons.tune),
          tooltip: 'Bộ lọc',
        ),
      ],
      child: _Body(
        children: [
          const _DemoNotice(
            'Danh sách ứng viên và điểm tương thích dưới đây là dữ liệu minh họa, không phải hồ sơ thật hay kết quả AI.',
          ),
          Text(
            '${candidates.length} ứng viên phù hợp (demo)',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          for (final c in candidates) _CandidateCard(candidate: c),
          if (candidates.isEmpty)
            _EmptyState(
              title: 'Không có ứng viên phù hợp',
              action: 'Xóa bộ lọc',
              onTap: () => ref
                  .read(employerDemoProvider.notifier)
                  .clearCandidateFilters(),
            ),
        ],
      ),
    );
  }
}

class EmployerCandidateFiltersScreen extends ConsumerStatefulWidget {
  const EmployerCandidateFiltersScreen({super.key});
  @override
  ConsumerState<EmployerCandidateFiltersScreen> createState() =>
      _EmployerCandidateFiltersScreenState();
}

class _EmployerCandidateFiltersScreenState
    extends ConsumerState<EmployerCandidateFiltersScreen> {
  late int _minimum;
  late bool _verified;

  @override
  void initState() {
    super.initState();
    final state = ref.read(employerDemoProvider);
    _minimum = state.candidateMatchMinimum;
    _verified = state.verifiedCandidatesOnly;
  }

  @override
  Widget build(BuildContext context) => EmployerPage(
    title: 'Candidate filters',
    bottom: Row(
      children: [
        Expanded(
          child: AppSecondaryButton(
            label: 'Reset all',
            onPressed: () => setState(() {
              _minimum = 0;
              _verified = false;
            }),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppPrimaryButton(
            label: 'Apply',
            onPressed: () {
              ref
                  .read(employerDemoProvider.notifier)
                  .setCandidateFilters(
                    minimumMatch: _minimum,
                    verifiedOnly: _verified,
                  );
              context.go('/employer/candidates');
            },
          ),
        ),
      ],
    ),
    child: _Body(
      children: [
        const _DemoNotice(
          'Filters affect the local sample candidates shown in this session.',
        ),
        const _SectionCard(
          title: 'Match score (demo)',
          child: Text('Choose a minimum sample score.'),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final value in [0, 60, 80, 95])
              ChoiceChip(
                label: Text(value == 0 ? 'All' : 'At least $value%'),
                selected: _minimum == value,
                onSelected: (_) => setState(() => _minimum = value),
              ),
          ],
        ),
        Card(
          child: SwitchListTile(
            title: const Text('Candidates with declared skills'),
            subtitle: const Text('Skills are not independently verified.'),
            value: _verified,
            onChanged: (value) => setState(() => _verified = value),
          ),
        ),
      ],
    ),
  );
}

class EmployerCandidateDetailScreen extends ConsumerWidget {
  const EmployerCandidateDetailScreen({super.key, required this.candidateId});
  final String candidateId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = employerDemoCandidates
        .where((item) => item.id == candidateId)
        .firstOrNull;
    if (c == null) return _NotFoundPage(title: 'Không tìm thấy ứng viên');
    final shortlisted = ref
        .watch(employerDemoProvider)
        .shortlistedCandidateIds
        .contains(c.id);
    return EmployerPage(
      title: 'Hồ sơ ứng viên',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: shortlisted ? 'Bỏ khỏi shortlist' : 'Lưu shortlist',
              onPressed: () =>
                  ref.read(employerDemoProvider.notifier).toggleShortlist(c.id),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppPrimaryButton(
              label: 'Mời phỏng vấn',
              onPressed: () =>
                  context.go('/employer/candidates/${c.id}/invite'),
            ),
          ),
        ],
      ),
      child: _Body(
        children: [
          const _DemoNotice(
            'Thông tin hồ sơ là dữ liệu mẫu. Không có xác minh sinh trắc, chứng chỉ hoặc AI scoring.',
          ),
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.blueTint,
            child: Text(
              c.name.split(' ').map((p) => p[0]).take(2).join(),
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            c.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          Text('${c.school} · GPA ${c.gpa}'),
          Text('${c.match}% Match (minh họa)'),
          _SectionCard(
            title: 'Kỹ năng đã khai báo',
            child: Wrap(
              spacing: 6,
              children: [
                for (final skill in c.skills) Chip(label: Text(skill)),
              ],
            ),
          ),
          _SectionCard(title: 'Kinh nghiệm', child: Text(c.experience)),
        ],
      ),
    );
  }
}

class EmployerShortlistScreen extends ConsumerWidget {
  const EmployerShortlistScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(employerDemoProvider).shortlistedCandidateIds;
    final items = employerDemoCandidates
        .where((c) => ids.contains(c.id))
        .toList();
    return EmployerPage(
      title: 'Shortlist',
      child: _Body(
        children: [
          const _DemoNotice(
            'Shortlist chỉ được giữ trong bộ nhớ của phiên chạy.',
          ),
          if (items.isEmpty)
            _EmptyState(
              title: 'Chưa có ứng viên đã lưu',
              action: 'Xem ứng viên',
              onTap: () => context.go('/employer/candidates'),
            ),
          for (final c in items) _CandidateCard(candidate: c),
        ],
      ),
    );
  }
}

class EmployerInterviewInviteScreen extends ConsumerStatefulWidget {
  const EmployerInterviewInviteScreen({super.key, required this.candidateId});
  final String candidateId;
  @override
  ConsumerState<EmployerInterviewInviteScreen> createState() =>
      _EmployerInterviewInviteScreenState();
}

class _EmployerInterviewInviteScreenState
    extends ConsumerState<EmployerInterviewInviteScreen> {
  final _form = GlobalKey<FormState>();
  DateTime? _date;
  String _time = '09:00 - 09:45';
  @override
  Widget build(BuildContext context) {
    final candidate = employerDemoCandidates
        .where((c) => c.id == widget.candidateId)
        .firstOrNull;
    if (candidate == null) {
      return _NotFoundPage(title: 'Không tìm thấy ứng viên');
    }
    final jobs = ref.watch(employerDemoProvider).listings;
    final job = jobs.firstOrNull;
    if (job == null) {
      return EmployerPage(
        title: 'Mời phỏng vấn',
        child: const _Body(
          children: [
            _DemoNotice(
              'Tạo và gửi duyệt tin demo trước khi lên lịch phỏng vấn.',
            ),
            Text('Chưa có tin tuyển dụng trong phiên này.'),
          ],
        ),
      );
    }
    return EmployerPage(
      title: 'Mời phỏng vấn',
      bottom: AppPrimaryButton(
        label: 'Tạo lời mời demo',
        icon: Icons.event_available,
        onPressed: () {
          if (!_form.currentState!.validate() || _date == null) return;
          final invite = EmployerInterviewInvite(
            id: 'invite-${DateTime.now().microsecondsSinceEpoch}',
            candidateId: candidate.id,
            candidateName: candidate.name,
            jobId: job.id,
            jobTitle: job.fields['title'] ?? '',
            date: _date!,
            time: _time,
          );
          ref.read(employerDemoProvider.notifier).addInterviewInvite(invite);
          context.go('/employer/interviews');
        },
      ),
      child: Form(
        key: _form,
        child: _Body(
          children: [
            const _DemoNotice(
              'Lời mời là bản ghi demo cục bộ; không gửi email hoặc tạo cuộc hẹn thật.',
            ),
            Text(
              candidate.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(job.fields['title'] ?? ''),
            const Text('Vòng phỏng vấn'),
            const Text('Phỏng vấn kỹ thuật · 45 phút'),
            ListTile(
              title: Text(
                _date == null
                    ? 'Chọn ngày phỏng vấn'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_date!),
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final today = DateTime.now();
                final value = await showDatePicker(
                  context: context,
                  firstDate: today,
                  initialDate: today,
                  lastDate: today.add(const Duration(days: 365)),
                );
                if (value != null) setState(() => _date = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _time,
              decoration: const InputDecoration(labelText: 'Khung giờ'),
              items: const [
                DropdownMenuItem(
                  value: '09:00 - 09:45',
                  child: Text('09:00 - 09:45'),
                ),
                DropdownMenuItem(
                  value: '10:30 - 11:15',
                  child: Text('10:30 - 11:15'),
                ),
                DropdownMenuItem(
                  value: '14:00 - 14:45',
                  child: Text('14:00 - 14:45'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _time = v);
              },
            ),
            if (_date == null)
              const Text(
                'Vui lòng chọn ngày.',
                style: TextStyle(color: AppColors.error),
              ),
          ],
        ),
      ),
    );
  }
}

class EmployerInterviewManagementScreen extends ConsumerWidget {
  const EmployerInterviewManagementScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invites = ref.watch(employerDemoProvider).interviewInvites;
    return EmployerPage(
      title: 'Quản lý phỏng vấn',
      child: _Body(
        children: [
          const _DemoNotice(
            'Lịch hẹn được tạo cục bộ để minh họa, chưa được xác nhận bởi ứng viên.',
          ),
          if (invites.isEmpty)
            _EmptyState(
              title: 'Chưa có lịch phỏng vấn',
              action: 'Xem ứng viên',
              onTap: () => context.go('/employer/candidates'),
            ),
          for (final invite in invites)
            _SectionCard(
              title: invite.candidateName,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invite.jobTitle),
                  Text(
                    '${MaterialLocalizations.of(context).formatMediumDate(invite.date)} · ${invite.time}',
                  ),
                  Text(invite.status),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({required this.candidate});
  final EmployerCandidate candidate;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      isThreeLine: true,
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(candidate.name),
      subtitle: Text(
        '${candidate.school}\nGPA ${candidate.gpa} · ${candidate.skills.take(2).join(', ')}',
      ),
      trailing: Text('${candidate.match}%'),
      onTap: () => context.go('/employer/candidates/${candidate.id}'),
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final child in children)
          Padding(padding: const EdgeInsets.only(bottom: 12), child: child),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    ),
  );
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.blueTint,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, color: AppColors.navy),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title, action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
      Text(title),
      if (onTap != null) TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => EmployerPage(
    title: 'Employer',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 52),
            Text(title),
            AppSecondaryButton(
              label: 'Về danh sách',
              onPressed: () => context.go('/employer/jobs'),
            ),
          ],
        ),
      ),
    ),
  );
}

String _fieldLabel(String key) => switch (key) {
  'title' => 'Chức danh công việc',
  'department' => 'Phòng ban / Nhóm dự án',
  'location' => 'Địa điểm',
  'salaryMin' => 'Thu nhập tối thiểu',
  'salaryMax' => 'Thu nhập tối đa',
  'description' => 'Mô tả công việc',
  _ => 'Kỹ năng yêu cầu',
};
