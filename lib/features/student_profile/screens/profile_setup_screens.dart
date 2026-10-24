import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../student_draft.dart';

class ProfileSetupOneScreen extends ConsumerStatefulWidget {
  const ProfileSetupOneScreen({super.key});
  @override
  ConsumerState<ProfileSetupOneScreen> createState() =>
      _ProfileSetupOneScreenState();
}

class _ProfileSetupOneScreenState extends ConsumerState<ProfileSetupOneScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name, _phone, _university, _major;
  @override
  void initState() {
    super.initState();
    final d = ref.read(careerDraftProvider);
    _name = TextEditingController(text: d.fullName);
    _phone = TextEditingController(text: d.phone);
    _university = TextEditingController(text: d.university);
    _major = TextEditingController(text: d.major);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _university.dispose();
    _major.dispose();
    super.dispose();
  }

  void _save() {
    final current = ref.read(careerDraftProvider);
    ref
        .read(careerDraftProvider.notifier)
        .update(
          current.copyWith(
            fullName: _name.text.trim(),
            phone: _phone.text.trim(),
            university: _university.text.trim(),
            major: _major.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(careerDraftProvider);
    return StudentPage(
      bottomAction: AppPrimaryButton(
        label: 'Tiếp tục bước 2: Kỹ năng & Mục tiêu',
        icon: Icons.arrow_forward,
        onPressed: () {
          if (_form.currentState!.validate()) {
            _save();
            context.go('/student-profile-setup-2');
          }
        },
      ),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentBackRow(
              title: 'Thiết lập hồ sơ',
              trailing: TextButton(
                onPressed: () => context.go('/student-home'),
                child: const Text('Bỏ qua'),
              ),
            ),
            const ProfileStepIndicator(step: 1, label: 'Cá nhân & Học vấn'),
            const SizedBox(height: 12),
            _infoBanner(),
            const SizedBox(height: 12),
            _avatarCard(context),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Thông tin cá nhân',
              trailing: const DemoPill(label: 'Bước 1/3'),
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: profileInput(
                      'Họ và tên *',
                      hint: 'Nguyễn Văn An',
                    ),
                    validator: (v) => v == null || v.trim().length < 2
                        ? 'Nhập họ và tên'
                        : null,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: profileInput(
                      'Số điện thoại *',
                      hint: '0912 345 678',
                    ),
                    validator: (v) =>
                        v == null || v.replaceAll(RegExp(r'\D'), '').length < 9
                        ? 'Nhập số điện thoại hợp lệ'
                        : null,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _university,
                    decoration: profileInput(
                      'Trường Đại học *',
                      hint: 'Tên trường',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nhập trường đại học'
                        : null,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _major,
                    decoration: profileInput(
                      'Chuyên ngành đào tạo *',
                      hint: 'Chuyên ngành',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nhập chuyên ngành'
                        : null,
                    onChanged: (_) => _save(),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: draft.schoolYear.isEmpty
                        ? null
                        : draft.schoolYear,
                    decoration: profileInput('Niên khóa dự kiến tốt nghiệp *'),
                    items: const ['2024', '2025', '2026', '2027', '2028']
                        .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                        .toList(),
                    onChanged: (v) => ref
                        .read(careerDraftProvider.notifier)
                        .update(
                          ref
                              .read(careerDraftProvider)
                              .copyWith(schoolYear: v ?? ''),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Tình trạng tìm việc',
              trailing: const DemoPill(label: 'Ưu tiên AI'),
              child: Column(
                children: [
                  const Text(
                    'Chọn mục tiêu nghề nghiệp để nhà tuyển dụng tiếp cận đúng thời điểm.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  for (final choice in const [
                    (
                      'Thực tập',
                      'Đang tìm thực tập',
                      'Khuyến nghị Năm 3-4',
                      'Tìm kiếm kỳ thực tập tốt nghiệp (3 - 6 tháng) có trợ cấp công bằng',
                    ),
                    (
                      'Full-time',
                      'Đang tìm việc Full-time',
                      'Sắp tốt nghiệp',
                      'Sẵn sàng nhận việc chính thức, lộ trình đào tạo Junior rõ ràng',
                    ),
                    (
                      'Tham khảo',
                      'Chỉ tham khảo thị trường',
                      'Chế độ ẩn danh',
                      'Khảo sát dải lương, tiêu chuẩn kỹ năng cho các năm sau',
                    ),
                  ])
                    _statusOption(
                      draft.jobStatus == choice.$1,
                      choice.$2,
                      choice.$3,
                      choice.$4,
                      () {
                        final current = ref.read(careerDraftProvider);
                        ref
                            .read(careerDraftProvider.notifier)
                            .update(current.copyWith(jobStatus: choice.$1));
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Bảo mật chuẩn ISO theo tiêu chuẩn việc làm SDG 8',
              style: TextStyle(fontSize: 11, color: AppColors.success),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _infoBanner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.blueTint.withValues(alpha: .46),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.navy, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Hồ sơ thông minh với SDG 8\nDữ liệu cá nhân & trường học giúp AI đề xuất đúng học bổng, vị trí thực tập phù hợp và mức đãi ngộ minh bạch.',
            style: TextStyle(fontSize: 12, height: 1.35, color: AppColors.navy),
          ),
        ),
      ],
    ),
  );
  Widget _avatarCard(BuildContext context) => Center(
    child: Column(
      children: [
        Stack(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/verified_campus.png',
                width: 86,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.blue,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chọn ảnh đại diện sẽ được bổ sung sau.'),
                    ),
                  ),
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Chạm biểu tượng để đổi ảnh chụp',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    ),
  );
  Widget _statusOption(
    bool selected,
    String title,
    String tag,
    String subtitle,
    VoidCallback onTap,
  ) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF1FF) : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.blue : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.blue : AppColors.textMuted,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ProfileSetupTwoScreen extends ConsumerStatefulWidget {
  const ProfileSetupTwoScreen({super.key});
  @override
  ConsumerState<ProfileSetupTwoScreen> createState() =>
      _ProfileSetupTwoScreenState();
}

class _ProfileSetupTwoScreenState extends ConsumerState<ProfileSetupTwoScreen> {
  final _newRole = TextEditingController();
  static const _suggestedDistricts = ['Tân Bình', 'Bình Thạnh', 'Q.7'];
  @override
  void dispose() {
    _newRole.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    final ctrl = ref.read(careerDraftProvider.notifier);
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Thiết lập hồ sơ',
            trailing: TextButton(
              onPressed: () => context.go('/education'),
              child: const Text('Bỏ qua'),
            ),
          ),
          const ProfileStepIndicator(step: 2, label: 'Định hướng'),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Định hướng & Mục tiêu nghề nghiệp',
            trailing: const DemoPill(label: 'AI Match'),
            child: const Text(
              'Hệ sinh thái AI sẽ đối sánh các cơ hội việc làm theo đúng kỳ vọng và năng lực của bạn. Khuyến nghị theo tiêu chuẩn việc làm SDG 8.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '1. Vị trí mong muốn *',
            trailing: Text(
              'Tối đa 3 vị trí',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final role in d.targetRoles)
                      InputChip(
                        label: Text(role),
                        onDeleted: () => ctrl.update(
                          d.copyWith(
                            targetRoles: [...d.targetRoles]..remove(role),
                          ),
                        ),
                      ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _addRole(context, d, ctrl),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Thêm vị trí'),
                ),
                const Text(
                  'Backend & Data đang là các nhóm nghề có nhu cầu tuyển dụng cao. (Gợi ý minh họa)',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '2. Hình thức làm việc',
            trailing: const Text(
              'Chọn nhiều hình thức',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            child: Wrap(
              spacing: 8,
              children: [
                for (final mode in ['On-site', 'Hybrid', 'Remote'])
                  FilterChip(
                    label: Text(mode),
                    selected: d.workModes.contains(mode),
                    onSelected: (v) {
                      final modes = [...d.workModes];
                      v ? modes.add(mode) : modes.remove(mode);
                      ctrl.update(d.copyWith(workModes: modes));
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '3. Địa điểm ưu tiên',
            trailing: const DemoPill(label: 'Khu vực TP.HCM'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: d.city,
                  isExpanded: true,
                  decoration: profileInput('Thành phố'),
                  items:
                      const ['TP. Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng', 'Cần Thơ']
                          .map(
                            (x) => DropdownMenuItem(value: x, child: Text(x)),
                          )
                          .toList(),
                  onChanged: (v) => ctrl.update(d.copyWith(city: v ?? d.city)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gợi ý gần bạn:',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                Wrap(
                  spacing: 4,
                  children: _suggestedDistricts
                      .map(
                        (x) => ActionChip(
                          label: Text('+ $x'),
                          onPressed: () =>
                              ctrl.update(d.copyWith(city: '${d.city} • $x')),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '4. Mức trợ cấp / lương mong đợi',
            trailing: const DemoPill(label: 'SDG 8 • công bằng'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Định kỳ thực nhận hàng tháng',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                Center(
                  child: Text(
                    '${d.salary.toStringAsFixed(1)} - ${(d.salary + 4).toStringAsFixed(1)} triệu VNĐ / tháng',
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Slider(
                  value: d.salary,
                  min: 0,
                  max: 16,
                  divisions: 16,
                  label: '${d.salary.round()} triệu',
                  onChanged: (v) => ctrl.update(d.copyWith(salary: v)),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 triệu', style: TextStyle(fontSize: 10)),
                    Text('10 triệu', style: TextStyle(fontSize: 10)),
                    Text('20+ triệu', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '5. Thời gian có thể bắt đầu làm việc',
            child: RadioGroup<String>(
              groupValue: d.startAvailability,
              onChanged: (value) {
                if (value != null) {
                  ctrl.update(d.copyWith(startAvailability: value));
                }
              },
              child: Column(
                children: [
                  for (final value in [
                    'Sẵn sàng ngay trong 2 tuần tới',
                    'Sau 1 tháng (Sau kỳ thi tốt nghiệp)',
                    'Linh hoạt theo thỏa thuận tuyển dụng',
                  ])
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: value,
                      title: Text(value, style: const TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: 'Quay lại',
                  onPressed: () => context.go('/student-profile-setup-1'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppPrimaryButton(
                  label: 'Tiếp tục (Bước 3)',
                  onPressed: () {
                    if (d.targetRoles.isEmpty || d.workModes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Chọn ít nhất một vị trí và hình thức làm việc.',
                          ),
                        ),
                      );
                      return;
                    }
                    context.go('/education');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addRole(
    BuildContext context,
    CareerDraft d,
    CareerDraftController ctrl,
  ) async {
    if (d.targetRoles.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn có thể chọn tối đa 3 vị trí.')),
      );
      return;
    }
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm vị trí mong muốn'),
        content: TextField(
          controller: _newRole,
          decoration: const InputDecoration(hintText: 'Ví dụ: UX Designer'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _newRole.text.trim()),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    _newRole.clear();
    if (value != null && value.isNotEmpty) {
      ctrl.update(
        ref
            .read(careerDraftProvider)
            .copyWith(
              targetRoles: [
                ...ref.read(careerDraftProvider).targetRoles,
                value,
              ],
            ),
      );
    }
  }
}
