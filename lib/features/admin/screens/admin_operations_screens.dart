import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/admin_operations_state.dart';
import '../widgets/admin_widgets.dart';

class AdminSkillsScreen extends ConsumerStatefulWidget {
  const AdminSkillsScreen({super.key});

  @override
  ConsumerState<AdminSkillsScreen> createState() => _AdminSkillsScreenState();
}

class _AdminSkillsScreenState extends ConsumerState<AdminSkillsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(adminOperationsProvider).skillGroups.where((
      group,
    ) {
      final query = _search.text.trim().toLowerCase();
      return query.isEmpty ||
          group.name.toLowerCase().contains(query) ||
          group.skills.any((skill) => skill.toLowerCase().contains(query));
    }).toList();
    final tagCount = ref
        .watch(adminOperationsProvider)
        .skillGroups
        .fold<int>(0, (count, group) => count + group.skills.length);
    return AdminPage(
      title: 'Danh mục kỹ năng',
      bottom: const AdminConsoleNav(selectedIndex: 4),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chuẩn hóa khung năng lực SDG 8',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton.icon(
                key: const ValueKey('admin-skill-add'),
                onPressed: () => _editGroup(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm mới'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Hệ sinh thái kỹ năng tuyển dụng · dữ liệu demo trong phiên',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CountCard(
                  label: 'Tổng phân nhóm',
                  value:
                      '${ref.watch(adminOperationsProvider).skillGroups.length} nhóm',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CountCard(
                  label: 'Kỹ năng chuẩn',
                  value: '$tagCount tags',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Nhóm kỹ năng ưu tiên'),
          TextField(
            controller: _search,
            key: const ValueKey('admin-skill-search'),
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Tìm kỹ năng, nhóm kỹ năng...',
            ),
          ),
          const SizedBox(height: 10),
          if (groups.isEmpty)
            AdminCard(
              child: Column(
                children: [
                  const Text('Không có nhóm kỹ năng phù hợp.'),
                  TextButton(
                    onPressed: () => context.push('/admin/empty'),
                    child: const Text('Xem trạng thái rỗng'),
                  ),
                ],
              ),
            )
          else
            for (final group in groups) ...[
              const SizedBox(height: 8),
              _SkillGroupCard(
                group: group,
                onEdit: () => _editGroup(context, group: group),
                onDelete: () => _confirmDelete(context, group),
                onEnabled: (value) => ref
                    .read(adminOperationsProvider.notifier)
                    .toggleSkillGroup(group.id, value),
              ),
            ],
        ],
      ),
    );
  }

  Future<void> _editGroup(
    BuildContext context, {
    AdminSkillGroup? group,
  }) async {
    final name = TextEditingController(text: group?.name ?? '');
    final skill = TextEditingController();
    final valid = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group == null ? 'Thêm nhóm kỹ năng' : 'Thêm kỹ năng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Tên nhóm'),
            ),
            TextField(
              controller: skill,
              decoration: const InputDecoration(labelText: 'Kỹ năng mới'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lưu demo'),
          ),
        ],
      ),
    );
    if (valid == true && context.mounted) {
      final saved = ref
          .read(adminOperationsProvider.notifier)
          .upsertSkillGroup(id: group?.id, name: name.text, skill: skill.text);
      if (!saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập tên nhóm và kỹ năng.')),
        );
      }
    }
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      name.dispose();
      skill.dispose();
    });
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AdminSkillGroup group,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa nhóm kỹ năng demo?'),
        content: Text(
          'Nhóm “${group.name}” sẽ bị xóa khỏi state phiên hiện tại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(adminOperationsProvider.notifier).removeSkillGroup(group.id);
    }
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _SkillGroupCard extends StatelessWidget {
  const _SkillGroupCard({
    required this.group,
    required this.onEdit,
    required this.onDelete,
    required this.onEnabled,
  });
  final AdminSkillGroup group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onEnabled;
  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.category_outlined, color: AppColors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                group.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              tooltip: 'Thêm kỹ năng',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 19),
            ),
            IconButton(
              tooltip: 'Xóa nhóm demo',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 19),
            ),
          ],
        ),
        Text(
          '${group.skills.length} kỹ năng chuẩn',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          'Tiêu biểu: ${group.skills.join(', ')}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            AdminStatusChip(
              group.enabled ? 'Đang áp dụng' : 'Tạm ẩn',
              positive: group.enabled,
            ),
            const Spacer(),
            Switch(value: group.enabled, onChanged: onEnabled),
          ],
        ),
      ],
    ),
  );
}

class AdminNotificationsScreen extends ConsumerWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminOperationsProvider);
    final unread = state.notifications.where((item) => !item.read).length;
    return AdminPage(
      title: 'Trung tâm thông báo',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hộp thư quản trị',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton.icon(
                key: const ValueKey('admin-notifications-read-all'),
                onPressed: unread == 0
                    ? null
                    : () => ref
                          .read(adminOperationsProvider.notifier)
                          .markAllRead(),
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text('Đánh dấu tất cả đã đọc'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              AdminStatusChip('Tất cả ${state.notifications.length}'),
              AdminStatusChip('Chưa đọc $unread'),
              const AdminStatusChip('Cảnh báo hệ thống 2'),
            ],
          ),
          const SizedBox(height: 14),
          const AdminSectionTitle('Mới nhất hôm nay'),
          for (final notice in state.notifications) ...[
            const SizedBox(height: 8),
            AdminCard(
              padding: 0,
              child: ListTile(
                key: ValueKey('admin-notification-${notice.id}'),
                leading: CircleAvatar(
                  backgroundColor: notice.read
                      ? AppColors.surfaceMuted
                      : AppColors.blueTint,
                  child: Icon(
                    notice.category == 'Ưu tiên cao'
                        ? Icons.warning_amber
                        : Icons.notifications_none,
                  ),
                ),
                title: Text(
                  notice.title,
                  style: TextStyle(
                    fontWeight: notice.read ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notice.body),
                    const SizedBox(height: 4),
                    Text(
                      '${notice.time} · ${notice.category}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: notice.read
                    ? const Icon(Icons.done, color: AppColors.success)
                    : const Icon(Icons.circle, size: 9, color: AppColors.blue),
                onTap: () {
                  ref
                      .read(adminOperationsProvider.notifier)
                      .markRead(notice.id);
                  context.push(notice.destination);
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          const AdminDemoNotice(),
        ],
      ),
    );
  }
}

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminOperationsProvider);
    return AdminPage(
      title: 'Cài đặt hệ thống',
      bottom: const AdminConsoleNav(selectedIndex: 4),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AdminCard(
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.admin_panel_settings_outlined),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trần Tuấn Anh',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('Quản trị viên trưởng · demo'),
                      Text(
                        'admin.moderator@careermatch.edu.vn',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hồ sơ demo',
                  onPressed: () =>
                      _message(context, 'Hồ sơ quản trị là nội dung minh họa.'),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const AdminDemoNotice(),
          const SizedBox(height: 14),
          const AdminSectionTitle('Cấu hình kiểm duyệt & SDG 8'),
          _SettingsCard(
            children: [
              _setting(
                context,
                ref,
                state,
                'auto_scan',
                'Tự động quét từ khóa nhạy cảm / thu phí',
                'Tùy chọn giao diện demo; không có bộ quét nền.',
              ),
              _setting(
                context,
                ref,
                state,
                'tax_check',
                'Đối soát mã số thuế qua cổng quốc gia',
                'Không gọi cổng dữ liệu bên ngoài.',
              ),
              _setting(
                context,
                ref,
                state,
                'sla',
                'Thời gian giới hạn xử lý tin tuyển dụng',
                'Giá trị minh họa: 24 giờ.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const AdminSectionTitle('Thông báo & bảo mật'),
          _SettingsCard(
            children: [
              _setting(
                context,
                ref,
                state,
                'priority_push',
                'Thông báo ưu tiên',
                'Chỉ cập nhật lựa chọn trong phiên.',
              ),
              _setting(
                context,
                ref,
                state,
                'two_factor',
                'Xác thực 2 bước (2FA)',
                'Không có xác thực thật trong bản demo.',
              ),
              _setting(
                context,
                ref,
                state,
                'email_digest',
                'Tóm tắt qua email',
                'Không gửi email.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const AdminSectionTitle('Ngôn ngữ & pháp lý'),
          AdminCard(
            padding: 4,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Ngôn ngữ hiển thị'),
                  subtitle: const Text('Tiếng Việt (mặc định)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _message(
                    context,
                    'Tiếng Việt là ngôn ngữ hiện có trong bản demo.',
                  ),
                ),
                ListTile(
                  title: const Text('Chính sách bảo mật dữ liệu'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _message(
                    context,
                    'Chưa có chính sách hoặc lưu trữ máy chủ được cấu hình trong bản demo.',
                  ),
                ),
                ListTile(
                  title: const Text('Tiêu chuẩn việc làm bền vững (SDG 8)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _message(
                    context,
                    'Nội dung tiêu chuẩn ở đây chỉ dùng để minh họa giao diện.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppSecondaryButton(
            label: 'Đăng xuất demo',
            icon: Icons.logout,
            onPressed: () => context.go('/admin/login'),
          ),
          const SizedBox(height: 8),
          const Text(
            'CareerMatch Admin · giao diện mẫu',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _setting(
    BuildContext context,
    WidgetRef ref,
    AdminOperationsState state,
    String key,
    String title,
    String subtitle,
  ) => SwitchListTile(
    key: ValueKey('admin-setting-$key'),
    value: state.settings[key] ?? false,
    onChanged: (value) =>
        ref.read(adminOperationsProvider.notifier).setSetting(key, value),
    title: Text(title),
    subtitle: Text(subtitle),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
  );

  void _message(BuildContext context, String text) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => AdminCard(
    padding: 4,
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          children[i],
        ],
      ],
    ),
  );
}
