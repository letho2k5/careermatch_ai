import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../employer/state/employer_demo_state.dart';
import '../widgets/admin_widgets.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _password.clear();
    context.go('/admin/dashboard');
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Đăng nhập quản trị',
    login: true,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/career_match_logo.png',
              width: 160,
              height: 48,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            const AdminStatusChip('SDG 8 · CỔNG ĐIỀU HÀNH QUẢN TRỊ'),
            const SizedBox(height: 12),
            Text(
              'Đăng nhập quản trị',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Quản lý hồ sơ doanh nghiệp và tin tuyển dụng',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            const AdminDemoNotice(),
            const SizedBox(height: 20),
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminField(
                    controller: _email,
                    label: 'Email quản trị',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Vui lòng nhập email';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Email chưa hợp lệ';
                      }
                      return null;
                    },
                  ),
                  AdminField(
                    controller: _password,
                    label: 'Mật khẩu',
                    obscureText: true,
                    validator: (value) => (value?.trim().length ?? 0) < 6
                        ? 'Mật khẩu demo cần ít nhất 6 ký tự'
                        : null,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                      ),
                      const Expanded(
                        child: Text('Ghi nhớ email trên màn hình này'),
                      ),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Khôi phục tài khoản chưa có trong bản demo.',
                                ),
                              ),
                            ),
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ],
                  ),
                  AppPrimaryButton(
                    label: 'Đăng nhập',
                    icon: Icons.login,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Đăng nhập chỉ mô phỏng điều hướng. Mật khẩu không được lưu hoặc gửi đi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Trạng thái máy chủ: bản demo cục bộ',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employerDemoProvider);
    final companies = state.companyApplications
        .where((item) => item.status == 'Chờ duyệt')
        .length;
    final jobs = [
      ...state.adminListings,
      ...state.listings,
    ].where((item) => item.status == 'Chờ duyệt').length;
    return AdminPage(
      title: 'Dashboard quản trị',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AdminDemoNotice(),
          const SizedBox(height: 16),
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào, Quản trị viên',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text('Tổng quan hàng chờ kiểm duyệt'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Doanh nghiệp chờ duyệt',
                        value: '$companies',
                        icon: Icons.business_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        label: 'Tin chờ duyệt',
                        value: '$jobs',
                        icon: Icons.work_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Người dùng',
                        value: 'Demo',
                        icon: Icons.people_outline,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        label: 'Báo cáo',
                        value: 'Demo',
                        icon: Icons.flag_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const AdminSectionTitle('Thao tác nhanh'),
          AdminCard(
            padding: 8,
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.business_center_outlined,
                  title: 'Duyệt doanh nghiệp',
                  count: companies,
                  onTap: () => context.go('/admin/companies/pending'),
                ),
                const Divider(height: 1),
                _ActionRow(
                  icon: Icons.work_outline,
                  title: 'Duyệt tin tuyển dụng',
                  count: jobs,
                  onTap: () => context.go('/admin/jobs/pending'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const AdminSectionTitle('Hoạt động gần đây'),
          const AdminCard(
            child: Text(
              'Các thao tác sẽ xuất hiện tại đây trong phiên demo sau khi quản trị viên xử lý hàng chờ.',
            ),
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: 'Đăng xuất demo',
            onPressed: () => context.go('/admin/login'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 98),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE7E8EB)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppColors.blue),
    title: Text(title),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [AdminStatusChip('$count'), const Icon(Icons.chevron_right)],
    ),
    onTap: onTap,
  );
}
