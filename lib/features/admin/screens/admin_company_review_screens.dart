import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../employer/models/employer_demo_models.dart';
import '../../employer/state/employer_demo_state.dart';
import '../widgets/admin_widgets.dart';

class AdminCompaniesPendingScreen extends ConsumerStatefulWidget {
  const AdminCompaniesPendingScreen({super.key});

  @override
  ConsumerState<AdminCompaniesPendingScreen> createState() =>
      _AdminCompaniesPendingScreenState();
}

class _AdminCompaniesPendingScreenState
    extends ConsumerState<AdminCompaniesPendingScreen> {
  final _search = TextEditingController();
  String _filter = 'Tất cả';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref
        .watch(employerDemoProvider)
        .companyApplications
        .where((item) => item.status == 'Chờ duyệt')
        .where(
          (item) => item.fields['name']!.toLowerCase().contains(
            _search.text.toLowerCase(),
          ),
        )
        .toList();
    final shown = pending.where((item) {
      return switch (_filter) {
        'Mới' => item.fields['new'] == 'true',
        'Ưu tiên' => item.fields['priority'] == 'true',
        'Bổ sung hồ sơ' => item.fields['needsDocuments'] == 'true',
        _ => true,
      };
    }).toList();
    return AdminPage(
      title: 'Doanh nghiệp chờ duyệt',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Doanh nghiệp chờ duyệt',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    AdminStatusChip('${pending.length}'),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: ['Tất cả', 'Mới', 'Ưu tiên', 'Bổ sung hồ sơ']
                      .map(
                        (item) => ChoiceChip(
                          label: Text(item),
                          selected: _filter == item,
                          onSelected: (_) => setState(() => _filter = item),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Tìm doanh nghiệp',
                  ),
                ),
                const SizedBox(height: 8),
                const AdminDemoNotice(),
              ],
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('Không có doanh nghiệp chờ duyệt'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: shown.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _CompanyQueueCard(application: shown[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CompanyQueueCard extends StatelessWidget {
  const _CompanyQueueCard({required this.application});
  final EmployerCompanyApplication application;

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
              child: Icon(Icons.business, color: AppColors.navy),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.fields['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MST: ${application.fields['taxId']}',
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
        const SizedBox(height: 12),
        Text(
          '${application.fields['industry']} · ${application.fields['submittedAt']}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () =>
                context.go('/admin/companies/${application.id}/review'),
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Xem hồ sơ'),
          ),
        ),
      ],
    ),
  );
}

class AdminCompanyReviewDetailScreen extends ConsumerWidget {
  const AdminCompanyReviewDetailScreen({required this.companyId, super.key});
  final String companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref
        .watch(employerDemoProvider)
        .companyApplications
        .where((item) => item.id == companyId)
        .firstOrNull;
    if (company == null) return const _NotFound(kind: 'doanh nghiệp');
    final fields = company.fields;
    return AdminPage(
      title: 'Chi tiết xét duyệt doanh nghiệp',
      bottom: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Từ chối',
              onPressed: () => context.go('/admin/companies/$companyId/reject'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppPrimaryButton(
              label: 'Phê duyệt',
              onPressed: () =>
                  context.go('/admin/companies/$companyId/approve'),
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
                'MÃ HỒ SƠ: ',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              Text('#${fields['submissionId']}'),
            ],
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminStatusChip('CHỜ RÀ SOÁT'),
                const SizedBox(height: 10),
                Text(
                  fields['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(label: 'Mã số thuế', value: fields['taxId']!),
                _InfoRow(label: 'Ngành nghề', value: fields['industry']!),
                _InfoRow(label: 'Email liên hệ', value: fields['email']!),
                _InfoRow(label: 'Địa chỉ', value: fields['address']!),
                _InfoRow(label: 'Ngày gửi', value: fields['submittedAt']!),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Tài liệu hồ sơ'),
          const AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DocumentRow(label: 'Giấy chứng nhận đăng ký doanh nghiệp'),
                Divider(),
                _DocumentRow(label: 'Thông tin mã số thuế'),
                Divider(),
                _DocumentRow(label: 'Thông tin liên hệ đại diện'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Checklist rà soát'),
          const AdminCard(
            child: Column(
              children: [
                _CheckRow(
                  label: 'Thông tin pháp lý đã được cung cấp',
                  checked: true,
                ),
                _CheckRow(
                  label: 'Thông tin ngành nghề đã được cung cấp',
                  checked: true,
                ),
                _CheckRow(
                  label: 'Cần xác minh độc lập trước quyết định',
                  checked: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminDemoNotice(),
        ],
      ),
    );
  }
}

class AdminApproveCompanyScreen extends ConsumerStatefulWidget {
  const AdminApproveCompanyScreen({required this.companyId, super.key});
  final String companyId;

  @override
  ConsumerState<AdminApproveCompanyScreen> createState() =>
      _AdminApproveCompanyScreenState();
}

class _AdminApproveCompanyScreenState
    extends ConsumerState<AdminApproveCompanyScreen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final company = ref
        .watch(employerDemoProvider)
        .companyApplications
        .where((item) => item.id == widget.companyId)
        .firstOrNull;
    if (company == null) return const _NotFound(kind: 'doanh nghiệp');
    return AdminPage(
      title: 'Phê duyệt doanh nghiệp',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 56,
            color: AppColors.success,
          ),
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
                const AdminStatusChip(
                  'VERIFIED EMPLOYER · DEMO',
                  positive: true,
                ),
                const SizedBox(height: 12),
                Text(
                  company.fields['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(label: 'Mã số thuế', value: company.fields['taxId']!),
                _InfoRow(
                  label: 'Mã hồ sơ',
                  value: company.fields['submissionId']!,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AdminDemoNotice(),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _confirmed,
            onChanged: (value) => setState(() => _confirmed = value ?? false),
            title: const Text(
              'Tôi xác nhận quyết định duyệt trong bản demo này.',
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          AppPrimaryButton(
            label: 'Xác nhận phê duyệt',
            icon: Icons.check,
            onPressed: _confirmed
                ? () {
                    final changed = ref
                        .read(employerDemoProvider.notifier)
                        .moderateCompany(widget.companyId, approved: true);
                    if (!changed) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã cập nhật trạng thái duyệt demo.'),
                      ),
                    );
                    context.go('/admin/companies/pending');
                  }
                : null,
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Quay lại',
            onPressed: () =>
                context.go('/admin/companies/${widget.companyId}/review'),
          ),
        ],
      ),
    );
  }
}

class AdminRejectCompanyScreen extends ConsumerStatefulWidget {
  const AdminRejectCompanyScreen({required this.companyId, super.key});
  final String companyId;

  @override
  ConsumerState<AdminRejectCompanyScreen> createState() =>
      _AdminRejectCompanyScreenState();
}

class _AdminRejectCompanyScreenState
    extends ConsumerState<AdminRejectCompanyScreen> {
  final _notes = TextEditingController();
  bool _notifyCompany = true;
  String? _reason;
  static const _reasons = [
    'Thông tin không hợp lệ',
    'Thiếu giấy phép',
    'Không xác minh được mã số thuế',
    'Không phù hợp tiêu chí SDG 8',
    'Lý do khác',
  ];

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final company = ref
        .watch(employerDemoProvider)
        .companyApplications
        .where((item) => item.id == widget.companyId)
        .firstOrNull;
    if (company == null) return const _NotFound(kind: 'doanh nghiệp');
    return AdminPage(
      title: 'Từ chối doanh nghiệp',
      child: Form(
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
                    const SizedBox(height: 10),
                    Text(
                      company.fields['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Text('MST: ${company.fields['taxId']}'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const AdminSectionTitle('Lý do từ chối *'),
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
                  hintText: 'Nhập hướng dẫn chỉnh sửa (nếu cần)',
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
                key: const ValueKey('admin-company-reject-confirm'),
                label: 'Xác nhận từ chối',
                icon: Icons.close,
                onPressed: _reject,
              ),
              const SizedBox(height: 8),
              AppSecondaryButton(
                label: 'Hủy',
                onPressed: () =>
                    context.go('/admin/companies/${widget.companyId}/review'),
              ),
            ],
          ),
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
        .moderateCompany(widget.companyId, approved: false, reason: reason);
    if (!changed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật trạng thái từ chối demo.')),
    );
    context.go('/admin/companies/pending');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
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
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.description_outlined, color: AppColors.blue),
      const SizedBox(width: 8),
      Expanded(child: Text(label)),
      const Text(
        'Đã nộp',
        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
    ],
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.checked});
  final String label;
  final bool checked;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(
          checked ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: checked ? AppColors.success : AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.kind});
  final String kind;
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
              'Không tìm thấy $kind',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Về danh sách',
              onPressed: () => context.go(
                kind == 'tin tuyển dụng'
                    ? '/admin/jobs/pending'
                    : '/admin/companies/pending',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
