import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/admin_operations_state.dart';
import '../widgets/admin_widgets.dart';

class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  String _filter = 'Tất cả';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(adminOperationsProvider).reports;
    final reports = all.where((report) {
      final statusMatches = _filter == 'Tất cả' || report.status == _filter;
      final query = _search.text.trim().toLowerCase();
      return statusMatches &&
          (query.isEmpty ||
              report.id.toLowerCase().contains(query) ||
              report.title.toLowerCase().contains(query));
    }).toList();
    final pending = all.where((item) => item.status == 'Chưa xử lý').length;
    return AdminPage(
      title: 'Báo cáo vi phạm',
      bottom: const AdminConsoleNav(selectedIndex: 3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Báo cáo vi phạm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              AdminStatusChip('$pending cần xử lý'),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Kiểm duyệt nội dung theo chuẩn việc làm bền vững · dữ liệu demo',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _search,
            key: const ValueKey('admin-report-search'),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Tìm mã báo cáo hoặc đối tượng...',
              suffixIcon: IconButton(
                onPressed: () {
                  _search.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final status in [
                  'Tất cả',
                  'Chưa xử lý',
                  'Đang xử lý',
                  'Đã giải quyết',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: status == _filter,
                      onSelected: (_) => setState(() => _filter = status),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AdminCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIÊU CHUẨN MINH BẠCH',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Các báo cáo minh họa quy trình rà soát. Không có SLA hoặc số liệu xử lý trực tiếp.',
                ),
              ],
            ),
          ),
          if (reports.isEmpty) ...[
            const SizedBox(height: 14),
            AdminCard(
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined, size: 40),
                  const Text('Không có báo cáo trong bộ lọc này.'),
                  TextButton(
                    onPressed: () => context.push('/admin/empty'),
                    child: const Text('Xem mẫu trạng thái rỗng'),
                  ),
                ],
              ),
            ),
          ] else ...[
            for (final report in reports) ...[
              const SizedBox(height: 10),
              _ReportCard(report: report),
            ],
          ],
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final AdminReportRecord report;
  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '#${report.id}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AdminStatusChip(
              report.priority,
              positive: report.status == 'Đã giải quyết',
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(report.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          report.reason,
          style: const TextStyle(fontSize: 12, color: AppColors.error),
        ),
        const SizedBox(height: 4),
        Text(
          '${report.reporter} · ${report.date}',
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: ValueKey('admin-report-detail-${report.id}'),
            onPressed: () => context.push('/admin/reports/${report.id}'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Xem báo cáo'),
          ),
        ),
      ],
    ),
  );
}

class AdminReportDetailScreen extends ConsumerStatefulWidget {
  const AdminReportDetailScreen({required this.reportId, super.key});
  final String reportId;

  @override
  ConsumerState<AdminReportDetailScreen> createState() =>
      _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState
    extends ConsumerState<AdminReportDetailScreen> {
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = ref
        .watch(adminOperationsProvider)
        .reports
        .where((item) => item.id == widget.reportId)
        .toList();
    final report = matches.isEmpty ? null : matches.first;
    if (report == null) return _ReportNotFound(reportId: widget.reportId);
    return AdminPage(
      title: 'Chi tiết báo cáo',
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppPrimaryButton(
          key: const ValueKey('admin-report-save'),
          label: 'Lưu kết quả xử lý demo',
          icon: Icons.save_outlined,
          onPressed: () => _resolve(report.id, 'Đã giải quyết'),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mã tra cứu: #${report.id}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AdminStatusChip(report.priority),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              AdminStatusChip(report.status),
              const AdminStatusChip('Bản ghi cục bộ', positive: true),
            ],
          ),
          const SizedBox(height: 12),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminSectionTitle('Đối tượng bị báo cáo'),
                Text(
                  report.target,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(report.title),
                Text('Nguồn: ${report.reporter}'),
                Text('Thời gian: ${report.date}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AdminSectionTitle('Nội dung khiếu nại & bằng chứng'),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminStatusChip(report.reason),
                const SizedBox(height: 8),
                Text(report.description),
                const SizedBox(height: 10),
                const Text(
                  'Tệp bằng chứng gốc chưa có trong assets; nội dung trên là mô tả demo.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            key: const ValueKey('admin-report-notes'),
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              labelText: 'Ghi chú xử lý nội bộ (tùy chọn)',
              hintText: 'Nhập ít nhất 10 ký tự nếu chọn biện pháp chế tài.',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 6),
          const AdminSectionTitle('Tùy chọn xử lý'),
          _ActionCard(
            key: const ValueKey('admin-report-processing'),
            icon: Icons.hourglass_top,
            title: 'Đánh dấu đang xử lý',
            detail: 'Giữ báo cáo trong hàng đợi kiểm tra.',
            onTap: () => _resolve(report.id, 'Đang xử lý'),
          ),
          const SizedBox(height: 8),
          _ActionCard(
            key: const ValueKey('admin-report-warning'),
            icon: Icons.notifications_active_outlined,
            title: 'Ghi nhận cảnh báo demo',
            detail: 'Không gửi email hoặc thông báo thật.',
            onTap: () => _resolve(report.id, 'Đã cảnh báo (demo)'),
          ),
          const SizedBox(height: 8),
          _ActionCard(
            key: const ValueKey('admin-report-hide'),
            icon: Icons.visibility_off_outlined,
            title: 'Ẩn nội dung trong bản demo',
            detail: 'Cập nhật trạng thái cục bộ, không ảnh hưởng dữ liệu bên ngoài.',
            onTap: () => _resolve(
              report.id,
              'Đã ẩn nội dung (demo)',
              requireNotes: true,
            ),
          ),
          const SizedBox(height: 8),
          _ActionCard(
            key: const ValueKey('admin-report-close'),
            icon: Icons.check_circle_outline,
            title: 'Đóng báo cáo: không vi phạm',
            detail: 'Ghi nhận kết quả trong phiên ứng dụng.',
            onTap: () => _resolve(report.id, 'Đã giải quyết'),
          ),
          const SizedBox(height: 12),
          const AdminDemoNotice(),
        ],
      ),
    );
  }

  void _resolve(String id, String status, {bool requireNotes = false}) {
    if (requireNotes && _notes.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ghi chú cần có ít nhất 10 ký tự cho biện pháp này.'),
        ),
      );
      return;
    }
    final changed = ref
        .read(adminOperationsProvider.notifier)
        .updateReport(id, status);
    if (!changed) return;
    context.push(
      '/admin/success?title=${Uri.encodeComponent('Đã ghi nhận: $status')}',
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 0,
    child: ListTile(
      leading: Icon(icon, color: AppColors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _ReportNotFound extends StatelessWidget {
  const _ReportNotFound({required this.reportId});
  final String reportId;
  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Không tìm thấy',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.report_gmailerrorred_outlined, size: 48),
            const SizedBox(height: 12),
            Text('Không tìm thấy báo cáo: $reportId'),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Về danh sách',
              onPressed: () => context.go('/admin/reports'),
            ),
          ],
        ),
      ),
    ),
  );
}
