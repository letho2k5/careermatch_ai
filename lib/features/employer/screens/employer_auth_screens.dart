import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../state/employer_demo_state.dart';
import 'employer_widgets.dart';

class EmployerSignupScreen extends StatefulWidget {
  const EmployerSignupScreen({super.key});
  @override
  State<EmployerSignupScreen> createState() => _EmployerSignupScreenState();
}

class _EmployerSignupScreenState extends State<EmployerSignupScreen> {
  final _form = GlobalKey<FormState>();
  String _password = '';
  bool _accepted = false;

  @override
  Widget build(BuildContext context) => EmployerPage(
    title: 'Đăng ký nhà tuyển dụng',
    child: Form(
      key: _form,
      child: EmployerFormBody(
        children: [
          const SizedBox(height: 12),
          const Text(
            'CAREERMATCH RECRUITER',
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          employerSectionTitle('Tạo tài khoản doanh nghiệp'),
          const Text(
            'Đăng ký tài khoản nhà tuyển dụng để quản lý cơ hội nghề nghiệp.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          const _AuthField(
            label: 'Người đại diện',
            requiredField: true,
            companyKey: 'representative',
          ),
          const _AuthField(
            label: 'Email công việc',
            requiredField: true,
            email: true,
            companyKey: 'email',
          ),
          const _AuthField(
            label: 'Tên miền công ty',
            requiredField: true,
            hint: 'congty.vn',
            companyKey: 'domain',
          ),
          const _AuthField(
            label: 'Số điện thoại',
            requiredField: true,
            phone: true,
            companyKey: 'phone',
          ),
          const _AuthField(
            label: 'Tên pháp lý doanh nghiệp',
            requiredField: true,
            companyKey: 'name',
          ),
          const _AuthField(
            label: 'Mã số thuế',
            requiredField: true,
            companyKey: 'tax',
          ),
          _AuthField(
            label: 'Mật khẩu',
            requiredField: true,
            obscure: true,
            onChanged: (v) => _password = v,
          ),
          _AuthField(
            label: 'Xác nhận mật khẩu',
            requiredField: true,
            obscure: true,
            validator: (v) => (v?.isEmpty ?? true)
                ? 'Vui lòng xác nhận mật khẩu'
                : v == _password
                ? null
                : 'Mật khẩu chưa khớp',
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _accepted,
            onChanged: (value) => setState(() => _accepted = value ?? false),
            title: const Text(
              'Tôi đồng ý với Điều khoản và Chính sách bảo mật',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          employerDemoNotice(
            'Đăng ký chỉ là minh họa trên thiết bị; chưa tạo tài khoản thật.',
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: 'Tạo tài khoản',
            onPressed: () {
              if (!_form.currentState!.validate()) return;
              if (!_accepted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng đồng ý với điều khoản.'),
                  ),
                );
                return;
              }
              context.go('/employer/company/setup');
            },
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/employer/login'),
              child: const Text('Đã có tài khoản? Đăng nhập'),
            ),
          ),
        ],
      ),
    ),
  );
}

class EmployerLoginScreen extends StatefulWidget {
  const EmployerLoginScreen({super.key});
  @override
  State<EmployerLoginScreen> createState() => _EmployerLoginScreenState();
}

class _EmployerLoginScreenState extends State<EmployerLoginScreen> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => EmployerPage(
    title: 'Đăng nhập nhà tuyển dụng',
    child: Form(
      key: _form,
      child: EmployerFormBody(
        children: [
          const SizedBox(height: 28),
          const Icon(
            Icons.business_center_rounded,
            color: AppColors.navy,
            size: 56,
          ),
          employerSectionTitle('Chào mừng trở lại'),
          const Text(
            'Cổng thông tin nhà tuyển dụng CareerMatch',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          const _AuthField(
            label: 'Email công việc',
            requiredField: true,
            email: true,
          ),
          const _AuthField(
            label: 'Mật khẩu',
            requiredField: true,
            obscure: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Khôi phục mật khẩu chưa có trong demo.'),
                ),
              ),
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          employerDemoNotice(
            'Đăng nhập demo không xác thực tài khoản với máy chủ.',
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: 'Đăng nhập',
            onPressed: () {
              if (_form.currentState!.validate()) {
                context.go('/employer/dashboard');
              }
            },
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('hoặc'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SSO chưa được kết nối trong bản demo.'),
              ),
            ),
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Google Workspace'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SSO chưa được kết nối trong bản demo.'),
              ),
            ),
            icon: const Icon(Icons.window),
            label: const Text('Microsoft Azure'),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/employer/signup'),
              child: const Text('Tạo tài khoản nhà tuyển dụng'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AuthField extends ConsumerWidget {
  const _AuthField({
    required this.label,
    this.requiredField = false,
    this.email = false,
    this.phone = false,
    this.obscure = false,
    this.hint,
    this.validator,
    this.onChanged,
    this.companyKey,
  });
  final String label;
  final bool requiredField, email, phone, obscure;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? companyKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
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
          obscureText: obscure,
          keyboardType: email
              ? TextInputType.emailAddress
              : phone
              ? TextInputType.phone
              : null,
          decoration: InputDecoration(hintText: hint ?? label),
          onChanged: (value) {
            onChanged?.call(value);
            if (companyKey != null) {
              ref
                  .read(employerDemoProvider.notifier)
                  .setCompanyField(companyKey!, value);
            }
          },
          validator:
              validator ??
              (value) {
                final text = value?.trim() ?? '';
                if (requiredField && text.isEmpty) {
                  return 'Vui lòng nhập $label';
                }
                if (email &&
                    !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
                  return 'Email chưa hợp lệ';
                }
                if (phone && text.replaceAll(RegExp(r'\D'), '').length < 9) {
                  return 'Số điện thoại chưa hợp lệ';
                }
                if (obscure && text.length < 8) {
                  return 'Mật khẩu cần ít nhất 8 ký tự';
                }
                return null;
              },
        ),
      ],
    ),
  );
}
