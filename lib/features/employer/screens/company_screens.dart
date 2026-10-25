import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/employer_demo_state.dart';
import 'employer_widgets.dart';

class CompanySetupScreen extends ConsumerStatefulWidget {
  const CompanySetupScreen({super.key});
  @override
  ConsumerState<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends ConsumerState<CompanySetupScreen> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final company = ref.watch(employerDemoProvider).company;
    final set = ref.read(employerDemoProvider.notifier).setCompanyField;
    return EmployerPage(
      title: 'Thiết lập công ty',
      bottom: AppPrimaryButton(
        label: 'Lưu hồ sơ công ty',
        icon: Icons.arrow_forward,
        onPressed: () {
          if (_form.currentState!.validate()) {
            context.go('/employer/company/profile');
          }
        },
      ),
      child: Form(
        key: _form,
        child: EmployerFormBody(
          children: [
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              value: 1 / 3,
              minHeight: 7,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bước 1 / 3 · Hồ sơ doanh nghiệp',
              style: TextStyle(color: AppColors.blue, fontSize: 12),
            ),
            employerSectionTitle('Thông tin công ty'),
            employerDemoNotice(
              'Hồ sơ demo trong phiên chạy; thông tin chưa được gửi để xác minh.',
            ),
            const SizedBox(height: 16),
            Container(
              height: 116,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.blue,
                      size: 32,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Logo công ty · chưa có asset tải lên',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CompanyField(
              label: 'Tên pháp lý công ty',
              value: company['name'] ?? '',
              requiredField: true,
              onChanged: (v) => set('name', v),
            ),
            _CompanyField(
              label: 'Mã số thuế',
              value: company['tax'] ?? '',
              requiredField: true,
              onChanged: (v) => set('tax', v),
            ),
            _CompanyField(
              label: 'Quy mô nhân sự',
              value: company['scale'] ?? '',
              requiredField: true,
              hint: 'Ví dụ: 50–200 nhân viên',
              onChanged: (v) => set('scale', v),
            ),
            _CompanyField(
              label: 'Lĩnh vực hoạt động',
              value: company['sector'] ?? '',
              requiredField: true,
              hint: 'Công nghệ, tài chính...',
              onChanged: (v) => set('sector', v),
            ),
            _CompanyField(
              label: 'Địa chỉ trụ sở',
              value: company['address'] ?? '',
              requiredField: true,
              onChanged: (v) => set('address', v),
            ),
            _CompanyField(
              label: 'Website',
              value: company['website'] ?? '',
              hint: 'https://',
              onChanged: (v) => set('website', v),
            ),
            _CompanyField(
              label: 'LinkedIn',
              value: company['linkedin'] ?? '',
              onChanged: (v) => set('linkedin', v),
            ),
            _CompanyField(
              label: 'Văn hóa và sứ mệnh',
              value: company['mission'] ?? '',
              lines: 4,
              onChanged: (v) => set('mission', v),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CompanyField extends StatelessWidget {
  const _CompanyField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.requiredField = false,
    this.hint,
    this.lines = 1,
  });
  final String label, value;
  final ValueChanged<String> onChanged;
  final bool requiredField;
  final String? hint;
  final int lines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          initialValue: value,
          maxLines: lines,
          minLines: lines > 1 ? 3 : 1,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: hint ?? label),
          validator: requiredField
              ? (v) =>
                    v?.trim().isNotEmpty == true ? null : 'Vui lòng nhập $label'
              : null,
        ),
      ],
    ),
  );
}

class CompanyProfileScreen extends ConsumerWidget {
  const CompanyProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(employerDemoProvider).company;
    return EmployerPage(
      title: 'Hồ sơ công ty',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business_rounded,
                color: Colors.white,
                size: 54,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company['name']?.isNotEmpty == true
                          ? company['name']!
                          : 'Chưa thiết lập tên công ty',
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        const _Pill('Hồ sơ demo'),
                        if (company['sector']?.isNotEmpty == true)
                          _Pill(company['sector']!),
                        if (company['scale']?.isNotEmpty == true)
                          _Pill(company['scale']!),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoLine(
                      icon: Icons.location_on_outlined,
                      text: company['address']?.isNotEmpty == true
                          ? company['address']!
                          : 'Chưa có địa chỉ',
                    ),
                    _InfoLine(
                      icon: Icons.language,
                      text: company['website']?.isNotEmpty == true
                          ? company['website']!
                          : 'Chưa có website',
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Giới thiệu',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      company['mission']?.isNotEmpty == true
                          ? company['mission']!
                          : 'Chưa có nội dung giới thiệu.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Expanded(
                      child: _DemoCompanyMetric(
                        value: '14+',
                        label: 'Vị trí demo',
                      ),
                    ),
                    Expanded(
                      child: _DemoCompanyMetric(
                        value: '1.2k',
                        label: 'Ứng viên demo',
                      ),
                    ),
                    Expanded(
                      child: _DemoCompanyMetric(
                        value: '4.8',
                        label: 'Đánh giá demo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cam kết với ứng viên',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _PromiseLine(
                      text: 'Mô tả công việc và mức lương minh bạch',
                    ),
                    const _PromiseLine(text: 'Tôn trọng cơ hội bình đẳng'),
                    const _PromiseLine(
                      text: 'Hỗ trợ học tập và phát triển nghề nghiệp',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Không gian làm việc',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Ảnh văn phòng chưa được cung cấp · placeholder',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            employerDemoNotice(
              'Trạng thái hồ sơ không được xác minh bởi bên thứ ba.',
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Cập nhật hồ sơ',
              onPressed: () => context.go('/employer/company/setup'),
            ),
            const SizedBox(height: 8),
            AppSecondaryButton(
              label: 'Xem trạng thái xác minh',
              onPressed: () => context.go('/employer/company/verification'),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyVerificationScreen extends StatelessWidget {
  const CompanyVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) => EmployerPage(
    title: 'Trạng thái xác minh',
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.pending_actions, size: 56, color: AppColors.blue),
          employerSectionTitle('Đang chờ hồ sơ xác minh'),
          const Text(
            'Minh họa tiến trình xét duyệt tích hợp SDG 8. Đây không phải trạng thái xét duyệt thật.',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _TimelineItem(
                    title: 'Tạo hồ sơ công ty',
                    detail: 'Thông tin được lưu trong phiên demo',
                    done: true,
                  ),
                  _TimelineItem(
                    title: 'Gửi tài liệu',
                    detail: 'Chưa gửi tới máy chủ',
                    done: false,
                  ),
                  _TimelineItem(
                    title: 'Kiểm tra thông tin',
                    detail: 'Chưa thực hiện',
                    done: false,
                  ),
                  _TimelineItem(
                    title: 'Xác minh hoàn tất',
                    detail: 'Chưa được xác minh',
                    done: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Tài liệu doanh nghiệp'),
              subtitle: Text('Chưa có tài liệu đính kèm trong bản demo'),
            ),
          ),
          const SizedBox(height: 20),
          AppSecondaryButton(
            label: 'Cập nhật hồ sơ công ty',
            onPressed: () => context.go('/employer/company/setup'),
          ),
          const SizedBox(height: 8),
          AppPrimaryButton(
            label: 'Về bảng điều khiển',
            onPressed: () => context.go('/employer/dashboard'),
          ),
        ],
      ),
    ),
  );
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.title,
    required this.detail,
    required this.done,
  });
  final String title, detail;
  final bool done;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? AppColors.successAccent : AppColors.textMuted,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Chip(
    label: Text(label, style: const TextStyle(fontSize: 11)),
    visualDensity: VisualDensity.compact,
    backgroundColor: AppColors.blueTint,
    side: BorderSide.none,
  );
}

class _DemoCompanyMetric extends StatelessWidget {
  const _DemoCompanyMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
      ),
    ],
  );
}

class _PromiseLine extends StatelessWidget {
  const _PromiseLine({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 18, color: AppColors.blue),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
