import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/employer_demo_state.dart';
import 'employer_widgets.dart';

class EmployerDashboardScreen extends ConsumerWidget {
  const EmployerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(employerDemoProvider).company;
    return EmployerPage(
      title: 'Employer Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _EmployerTabs(selected: 'Tổng quan'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.business_outlined,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chào buổi sáng · Talent Acquisition',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              company['name']?.isNotEmpty == true
                                  ? 'Xin chào, ${company['name']}'
                                  : 'Quản trị cơ hội nghề nghiệp',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          tooltip: 'Chỉnh sửa thông tin công ty',
                          onPressed: () =>
                              context.go('/employer/company/profile'),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceMuted,
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.navy,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 31,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.successTint.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          color: AppColors.success,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'SDG 8 · nội dung minh họa, chưa xác minh',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricCard(
                  title: 'Vị trí đang mở',
                  value: '18',
                  icon: Icons.work_outline,
                ),
                _MetricCard(
                  title: 'Ứng viên mới nộp',
                  value: '142',
                  icon: Icons.people_outline,
                ),
                _MetricCard(
                  title: 'Lịch phỏng vấn',
                  value: '28',
                  icon: Icons.calendar_month_outlined,
                ),
                _MetricCard(
                  title: 'Tốc độ phản hồi',
                  value: '94.2%',
                  icon: Icons.bolt,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Đăng tin mới',
                    icon: Icons.add,
                    onPressed: () => context.go('/employer/jobs/create/step-1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppSecondaryButton(
                    label: 'Danh sách tin',
                    onPressed: () => context.go('/employer/jobs'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Ứng viên'),
                  onPressed: () => context.go('/employer/candidates'),
                ),
                ActionChip(
                  label: const Text('Shortlist'),
                  onPressed: () => context.go('/employer/shortlist'),
                ),
                ActionChip(
                  label: const Text('Phỏng vấn'),
                  onPressed: () => context.go('/employer/interviews'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ứng viên tiềm năng khớp cao',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            const _CandidateCard(
              name: 'Nguyễn Văn An',
              role: 'Backend Developer Intern',
              match: '96% Match',
            ),
            const SizedBox(height: 8),
            const _CandidateCard(
              name: 'Trần Thị Bình',
              role: 'DevOps Junior',
              match: '92% Match',
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.insights_outlined, color: AppColors.blue),
                title: Text('Tiến độ tuyển dụng theo chiến dịch'),
                subtitle: Text('Số liệu minh họa cho giao diện demo.'),
              ),
            ),
            const SizedBox(height: 12),
            employerDemoNotice(),
          ],
        ),
      ),
    );
  }
}

class EmployerJobListingsScreen extends ConsumerStatefulWidget {
  const EmployerJobListingsScreen({super.key});
  @override
  ConsumerState<EmployerJobListingsScreen> createState() =>
      _EmployerJobListingsScreenState();
}

class _EmployerJobListingsScreenState
    extends ConsumerState<EmployerJobListingsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employerDemoProvider);
    final query = _query.trim().toLowerCase();
    final draftMatches =
        state.hasJobDraft &&
        (state.job['title'] ?? '').toLowerCase().contains(query);
    final backendMatches = 'backend developer intern'.contains(query);
    final devopsMatches = 'devops / cloud engineer'.contains(query);
    return EmployerPage(
      title: 'Tin tuyển dụng',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _EmployerTabs(selected: 'Tin tuyển'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HỆ THỐNG TUYỂN DỤNG SDG 8',
                    style: TextStyle(color: AppColors.blueTint, fontSize: 11),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quản trị cơ hội nghề nghiệp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Thống kê bên dưới là dữ liệu mẫu',
                    style: TextStyle(color: AppColors.blueTint, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm tin tuyển dụng...',
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 10),
            const Wrap(
              spacing: 6,
              children: [
                _StatusChip('Tất cả (18)', active: true),
                _StatusChip('Đang mở (14)'),
                _StatusChip('Bản nháp (2)'),
                _StatusChip('Đã đóng'),
              ],
            ),
            const SizedBox(height: 12),
            if (draftMatches)
              _DraftJobCard(
                title: state.job['title'] ?? '',
                location: state.job['location'] ?? '',
              )
            else if (!state.hasJobDraft && query.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Chưa có tin tuyển dụng demo. Tạo bản nháp đầu tiên để xem trước.',
                  ),
                ),
              ),
            for (final listing in state.listings.where(
              (item) => item.fields['title']!.toLowerCase().contains(query),
            ))
              Card(
                child: ListTile(
                  title: Text(listing.fields['title'] ?? ''),
                  subtitle: Text('${listing.status} · tin demo'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/employer/jobs/${listing.id}'),
                ),
              ),
            if (backendMatches) ...[
              const SizedBox(height: 10),
              const _SampleJobCard(
                title: 'Backend Developer Intern',
                status: 'Dữ liệu mẫu · đang mở',
                salary: '8.000.000 - 12.000.000 VNĐ',
              ),
            ],
            if (devopsMatches) ...[
              const SizedBox(height: 10),
              const _SampleJobCard(
                title: 'DevOps / Cloud Engineer',
                status: 'Dữ liệu mẫu · đang mở',
                salary: '12.000.000 - 18.000.000 VNĐ',
              ),
            ],
            if (query.isNotEmpty &&
                !draftMatches &&
                !backendMatches &&
                !devopsMatches)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('Không có tin nào khớp từ khóa tìm kiếm.'),
                ),
              ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Đăng tin tuyển dụng mới',
              icon: Icons.add,
              onPressed: () => context.go('/employer/jobs/create/step-1'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Ứng viên'),
                  onPressed: () => context.go('/employer/candidates'),
                ),
                ActionChip(
                  label: const Text('Shortlist'),
                  onPressed: () => context.go('/employer/shortlist'),
                ),
                ActionChip(
                  label: const Text('Quản lý phỏng vấn'),
                  onPressed: () => context.go('/employer/interviews'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            employerDemoNotice(
              'Tin tuyển dụng có nhãn dữ liệu mẫu hoặc bản nháp; chưa được xuất bản.',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployerTabs extends StatelessWidget {
  const _EmployerTabs({required this.selected});
  final String selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        _Tab(
          label: 'Tổng quan',
          active: selected == 'Tổng quan',
          path: '/employer/dashboard',
        ),
        _Tab(
          label: 'Tin tuyển',
          active: selected == 'Tin tuyển',
          path: '/employer/jobs',
        ),
        _Tab(
          label: 'Ứng viên',
          active: selected == 'Ứng viên',
          path: '/employer/candidates',
        ),
        _Tab(
          label: 'Phỏng vấn',
          active: selected == 'Phỏng vấn',
          path: '/employer/interviews',
        ),
        _Tab(
          label: 'Công ty',
          active: selected == 'Công ty',
          path: '/employer/company/profile',
        ),
      ],
    ),
  );
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.path});
  final String label, path;
  final bool active;
  @override
  Widget build(BuildContext context) => Expanded(
    child: TextButton(
      onPressed: () => context.go(path),
      style: TextButton.styleFrom(
        backgroundColor: active ? Colors.white : Colors.transparent,
        foregroundColor: active ? AppColors.navy : AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
      ),
      child: FittedBox(
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });
  final String title, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: (MediaQuery.sizeOf(context).width - 42) / 2,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.blue),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.name,
    required this.role,
    required this.match,
  });
  final String name, role, match;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.blueTint,
        child: Icon(Icons.person, color: AppColors.navy),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text('$role · dữ liệu mẫu'),
      trailing: Text(
        match,
        style: const TextStyle(
          color: AppColors.blue,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label, {this.active = false});
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Chip(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        color: active ? Colors.white : AppColors.textSecondary,
      ),
    ),
    backgroundColor: active ? AppColors.blue : AppColors.surfaceMuted,
    side: BorderSide.none,
    visualDensity: VisualDensity.compact,
  );
}

class _SampleJobCard extends StatelessWidget {
  const _SampleJobCard({
    required this.title,
    required this.status,
    required this.salary,
  });
  final String title, status, salary;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.code, color: AppColors.blue),
          const SizedBox(height: 6),
          Text(
            status,
            style: const TextStyle(color: AppColors.success, fontSize: 11),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            salary,
            style: const TextStyle(color: AppColors.blue, fontSize: 12),
          ),
          const Divider(),
          const Text(
            '42 ứng viên · số liệu minh họa',
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class _DraftJobCard extends StatelessWidget {
  const _DraftJobCard({required this.title, required this.location});
  final String title, location;
  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.blueTint,
    child: ListTile(
      leading: const Icon(Icons.edit_note, color: AppColors.navy),
      title: Text(
        title.isEmpty ? 'Bản nháp chưa đặt tên' : title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        'Bản nháp chưa xuất bản${location.isEmpty ? '' : ' · $location'}',
      ),
      trailing: const Icon(Icons.visibility_outlined),
    ),
  );
}
