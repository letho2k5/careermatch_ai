import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../widgets/admin_widgets.dart';

class AdminEmptyStateScreen extends StatelessWidget {
  const AdminEmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Trạng thái rỗng',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        Row(
          children: [
            const AdminStatusChip('Template AD-18'),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Thư viện giao diện chuẩn',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const AdminStatusChip('SDG 8', positive: true),
          ],
        ),
        const SizedBox(height: 14),
        AdminCard(
          child: Column(
            children: [
              Container(
                width: 132,
                height: 132,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EFFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inbox_outlined,
                  color: AppColors.blue,
                  size: 62,
                ),
              ),
              const SizedBox(height: 12),
              const AdminStatusChip('Hệ thống quản trị mục rỗng'),
              const SizedBox(height: 8),
              Text(
                'Chưa có dữ liệu',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Hiện chưa có mục nào để hiển thị. Vui lòng quay lại sau hoặc điều chỉnh bộ lọc tìm kiếm.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                key: const ValueKey('admin-empty-refresh'),
                label: 'Làm mới danh sách demo',
                icon: Icons.refresh,
                onPressed: () => context.go('/admin/dashboard'),
              ),
              const SizedBox(height: 8),
              AppSecondaryButton(
                label: 'Quay lại trang tổng quan',
                onPressed: () => context.go('/admin/dashboard'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const AdminDemoNotice(),
        const SizedBox(height: 8),
        const Text(
          'Mẫu giao diện tái sử dụng cho danh sách, hộp thông báo hoặc bộ lọc không có kết quả.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class AdminErrorStateScreen extends StatefulWidget {
  const AdminErrorStateScreen({super.key});

  @override
  State<AdminErrorStateScreen> createState() => _AdminErrorStateScreenState();
}

class _AdminErrorStateScreenState extends State<AdminErrorStateScreen> {
  int _retryCount = 0;

  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Trạng thái lỗi',
    login: true,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Row(
          children: [
            const AdminStatusChip('Hệ thống CareerMatch'),
            const Spacer(),
            Text(
              'Bảo mật chuẩn SDG-8',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Trạng thái lỗi', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        AdminCard(
          child: Column(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  color: AppColors.errorTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Đã xảy ra lỗi',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Không thể tải dữ liệu lúc này. Đây là trạng thái minh họa; ứng dụng hiện chưa có kết nối máy chủ để thử lại.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const AdminStatusChip('MÃ LỖI: DEMO-001'),
              if (_retryCount > 0) ...[
                const SizedBox(height: 10),
                Text(
                  'Đã thử lại $_retryCount lần · dữ liệu vẫn ở trạng thái demo.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
              const SizedBox(height: 18),
              AppPrimaryButton(
                key: const ValueKey('admin-error-retry'),
                label: 'Thử lại',
                icon: Icons.refresh,
                onPressed: () => setState(() => _retryCount++),
              ),
              const SizedBox(height: 8),
              AppSecondaryButton(
                label: 'Quay lại',
                icon: Icons.arrow_back,
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go('/admin/dashboard'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Nếu lỗi phát sinh trong bản demo, vui lòng kiểm tra thao tác cục bộ vừa thực hiện.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}

class AdminSuccessStateScreen extends StatelessWidget {
  const AdminSuccessStateScreen({this.title, super.key});
  final String? title;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timestamp =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return AdminPage(
      title: 'Thao tác hoàn tất',
      login: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Thao tác hoàn tất',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          AdminCard(
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    color: AppColors.successTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 54,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 14),
                const AdminStatusChip(
                  'CareerMatch AI · demo cục bộ',
                  positive: true,
                ),
                const SizedBox(height: 10),
                Text(
                  title ?? 'Thao tác demo hoàn tất',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thay đổi đã được ghi nhận trong bộ nhớ phiên ứng dụng. Không có dữ liệu nào được gửi tới máy chủ hoặc nhà tuyển dụng.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AdminCard(
                  padding: 12,
                  child: Column(
                    children: [
                      const _SuccessInfo(
                        label: 'Trạng thái',
                        value: 'Hoàn tất trong demo',
                      ),
                      const Divider(height: 16),
                      _SuccessInfo(
                        label: 'Thời gian ghi nhận',
                        value: timestamp,
                      ),
                      const Divider(height: 16),
                      const _SuccessInfo(
                        label: 'Mã tham chiếu',
                        value: 'DEMO-LOCAL',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const AdminStatusChip(
                  'Không có đồng bộ, mã hóa hoặc dịch vụ backend được thực hiện',
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  key: const ValueKey('admin-success-continue'),
                  label: 'Tiếp tục',
                  icon: Icons.arrow_forward,
                  onPressed: () => context.go('/admin/dashboard'),
                ),
                const SizedBox(height: 8),
                AppSecondaryButton(
                  label: 'Về trang tổng quan',
                  onPressed: () => context.go('/admin/dashboard'),
                ),
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

class _SuccessInfo extends StatelessWidget {
  const _SuccessInfo({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}
