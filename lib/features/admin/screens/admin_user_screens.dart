import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/admin_operations_state.dart';
import '../widgets/admin_widgets.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _search = TextEditingController();
  String _role = 'Tất cả';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(adminOperationsProvider).users.where((user) {
      final query = _search.text.trim().toLowerCase();
      return (_role == 'Tất cả' || user.role == _role) &&
          (query.isEmpty ||
              user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query));
    }).toList();
    return AdminPage(
      title: 'Quản lý người dùng',
      bottom: const AdminConsoleNav(selectedIndex: 2),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quản lý người dùng',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const AdminStatusChip('12.450'),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _search,
            key: const ValueKey('admin-user-search'),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Tìm theo tên hoặc email...',
              suffixIcon: IconButton(
                tooltip: 'Xóa tìm kiếm',
                onPressed: () {
                  _search.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final role in ['Tất cả', 'Sinh viên', 'Nhà tuyển dụng'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(role),
                      selected: _role == role,
                      onSelected: (_) => setState(() => _role = role),
                    ),
                  ),
              ],
            ),
          ),
          if (users.isEmpty) ...[
            const SizedBox(height: 20),
            AdminCard(
              child: Column(
                children: [
                  const Icon(Icons.person_search_outlined, size: 40),
                  const SizedBox(height: 8),
                  const Text('Không có người dùng phù hợp.'),
                  TextButton(
                    onPressed: () => context.push('/admin/empty'),
                    child: const Text('Xem mẫu trạng thái rỗng'),
                  ),
                ],
              ),
            ),
          ] else ...[
            for (final user in users) ...[
              const SizedBox(height: 10),
              _UserCard(user: user),
            ],
          ],
          const SizedBox(height: 12),
          Text(
            'Hiển thị ${users.length} trong 12.450 hồ sơ tài khoản · dữ liệu danh sách là demo',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});
  final AdminUserRecord user;

  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blueTint,
              child: Text(user.name.characters.first),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(user.email, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Thao tác người dùng',
              onSelected: (_) => context.push('/admin/users/${user.id}'),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'detail', child: Text('Xem chi tiết')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            AdminStatusChip(user.role),
            AdminStatusChip(user.status, positive: user.status == 'Hoạt động'),
            if (user.warning)
              const AdminStatusChip('Đã gửi cảnh báo', positive: true),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Hoạt động gần nhất · ${user.lastActive}',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            TextButton.icon(
              key: ValueKey('admin-user-detail-${user.id}'),
              onPressed: () => context.push('/admin/users/${user.id}'),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Xem chi tiết'),
            ),
          ],
        ),
      ],
    ),
  );
}

class AdminUserDetailScreen extends ConsumerWidget {
  const AdminUserDetailScreen({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(adminOperationsProvider.notifier);
    final matches = ref
        .watch(adminOperationsProvider)
        .users
        .where((item) => item.id == userId)
        .toList();
    final user = matches.isEmpty ? null : matches.first;
    if (user == null) {
      return _AdminUserNotFound(userId: userId);
    }
    return AdminPage(
      title: 'Chi tiết người dùng',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AdminCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  child: Text(user.name.characters.first),
                ),
                const SizedBox(height: 10),
                Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                Text(user.role),
                Text(user.email),
                const SizedBox(height: 10),
                AdminStatusChip(
                  user.status,
                  positive: user.status == 'Hoạt động',
                ),
                Text('ID: ${user.id}', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Thông tin tài khoản'),
          AdminCard(
            child: Column(
              children: [
                _InfoLine(label: 'Email trường', value: user.email),
                _InfoLine(
                  label: 'Số điện thoại',
                  value: user.phone ?? 'Chưa cung cấp',
                ),
                _InfoLine(
                  label: 'Đơn vị',
                  value: user.school ?? 'Chưa cung cấp',
                ),
                _InfoLine(label: 'Hoạt động gần nhất', value: user.lastActive),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AdminDemoNotice(),
          const SizedBox(height: 14),
          AppSecondaryButton(
            key: const ValueKey('admin-user-warning'),
            label: user.warning ? 'Đã gửi cảnh báo demo' : 'Gửi cảnh báo',
            icon: Icons.notifications_active_outlined,
            onPressed: user.warning
                ? null
                : () {
                    controller.updateUser(user.id, warning: true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã ghi nhận cảnh báo trong phiên demo.'),
                      ),
                    );
                  },
          ),
          const SizedBox(height: 8),
          AppPrimaryButton(
            key: const ValueKey('admin-user-toggle-lock'),
            label: user.status == 'Đã khóa'
                ? 'Mở khóa tài khoản demo'
                : 'Tạm khóa tài khoản demo',
            icon: user.status == 'Đã khóa'
                ? Icons.lock_open
                : Icons.lock_outline,
            onPressed: () => _confirmStatus(context, controller, user),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push(
              '/admin/success?title=${Uri.encodeComponent('Đã cập nhật hồ sơ demo')}',
            ),
            child: const Text('Mở mẫu trạng thái thành công'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmStatus(
    BuildContext context,
    AdminOperationsController controller,
    AdminUserRecord user,
  ) async {
    final lock = !user.status.startsWith('Đã khóa');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lock ? 'Tạm khóa tài khoản?' : 'Mở khóa tài khoản?'),
        content: const Text(
          'Thay đổi chỉ có hiệu lực trong phiên demo hiện tại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    controller.updateUser(
      user.id,
      status: lock ? 'Đã khóa (demo)' : 'Hoạt động',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lock
              ? 'Đã khóa tài khoản trong demo.'
              : 'Đã mở khóa tài khoản trong demo.',
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 128,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _AdminUserNotFound extends StatelessWidget {
  const _AdminUserNotFound({required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) => AdminPage(
    title: 'Không tìm thấy',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text('Không tìm thấy người dùng: $userId'),
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Về danh sách',
              onPressed: () => context.go('/admin/users'),
            ),
          ],
        ),
      ),
    ),
  );
}
