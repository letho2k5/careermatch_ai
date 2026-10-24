import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';

class _AuthPage extends StatelessWidget {
  const _AuthPage({required this.child, this.title, this.back = true});
  final Widget child;
  final String? title;
  final bool back;
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title: title == null ? null : Text(title!),
      leading: back
          ? IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/welcome');
                }
              },
              icon: const Icon(Icons.arrow_back),
            )
          : null,
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: child,
          ),
        ),
      ),
    ),
  );
}

Widget _heading(BuildContext context, String title, String subtitle) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(title, style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 8),
    Text(subtitle),
  ],
);
Widget _label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6, top: 14),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.navy,
    ),
  ),
);
Widget _social(BuildContext context) => Column(
  children: [
    const SizedBox(height: 14),
    const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc tiếp tục với',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
        Expanded(child: Divider()),
      ],
    ),
    const SizedBox(height: 12),
    OutlinedButton.icon(
      onPressed: () =>
          _message(context, 'Đăng nhập mạng xã hội chỉ là bản demo.'),
      icon: const Icon(Icons.g_mobiledata),
      label: const Text('Tiếp tục với Google'),
    ),
    const SizedBox(height: 8),
    OutlinedButton.icon(
      onPressed: () =>
          _message(context, 'Đăng nhập mạng xã hội chỉ là bản demo.'),
      icon: const Icon(Icons.business),
      label: const Text('Tiếp tục với LinkedIn'),
    ),
  ],
);
void _message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
Widget _sdgFooter() => const Padding(
  padding: EdgeInsets.only(top: 20),
  child: Center(
    child: Text(
      'SDG 8  •  DECENT WORK & ECONOMIC GROWTH',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.success,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: .3,
      ),
    ),
  ),
);

class StudentSignupScreen extends StatefulWidget {
  const StudentSignupScreen({super.key});
  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController(),
      _confirm = TextEditingController();
  bool _terms = false, _obscure = true;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _emailError(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
      return 'Nhập email hợp lệ';
    }
    if (!v.toLowerCase().endsWith('.edu.vn')) {
      return 'Vui lòng dùng email trường (.edu.vn)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => _AuthPage(
    title: 'Tạo tài khoản',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Bước 1 / 2',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              Image.asset(
                'assets/images/verified_campus.png',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _heading(
            context,
            'Tạo tài khoản sinh viên',
            'Dùng email trường để xác minh tư cách sinh viên.',
          ),
          _label('Họ và tên'),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Nguyễn An'),
            validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Nhập họ và tên' : null,
          ),
          _label('Email trường (.edu.vn)'),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'ten@truong.edu.vn'),
            validator: _emailError,
          ),
          _label('Mật khẩu'),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Ít nhất 8 ký tự',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (v) =>
                (v == null ||
                    v.length < 8 ||
                    !RegExp(r'[A-Z]').hasMatch(v) ||
                    !RegExp(r'\d').hasMatch(v))
                ? 'Cần 8 ký tự, chữ hoa và chữ số'
                : null,
          ),
          _label('Xác nhận mật khẩu'),
          TextFormField(
            controller: _confirm,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Nhập lại mật khẩu'),
            validator: (v) =>
                v != _password.text ? 'Mật khẩu không khớp' : null,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _terms,
            onChanged: (v) => setState(() => _terms = v ?? false),
            title: const Text(
              'Tôi đồng ý với Điều khoản và Chính sách bảo mật',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          AppPrimaryButton(
            label: 'Tạo tài khoản',
            onPressed: () {
              if (_form.currentState!.validate() && _terms) {
                context.go('/email-verification', extra: _email.text.trim());
              } else if (!_terms) {
                _message(context, 'Vui lòng đồng ý với điều khoản.');
              }
            },
          ),
          _social(context),
          _sdgFooter(),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context.go('/student-login'),
              child: const Text('Đã có tài khoản? Đăng nhập ngay'),
            ),
          ),
        ],
      ),
    ),
  );
}

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _code = TextEditingController();
  final _focus = FocusNode();
  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email =
        GoRouterState.of(context).extra as String? ?? 'an.nguyen@hcmut.edu.vn';
    return _AuthPage(
      title: 'Xác minh bảo mật',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: AppColors.blueTint.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 56,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _heading(
            context,
            'Xác thực email của bạn',
            'Nhập mã xác minh 6 chữ số đã được gửi đến',
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _code,
            focusNode: _focus,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 12,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              counterText: '',
              hintText: '• • • • • •',
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Gửi lại mã sau 00:45',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Không thấy email? Kiểm tra thư mục spam hoặc thư rác.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          const LinearProgressIndicator(value: .5),
          const SizedBox(height: 8),
          const Text(
            'Hoàn tất xác minh • 50%',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Xác thực & Tiếp tục',
            onPressed: () {
              if (_code.text.length == 6) {
                _message(
                  context,
                  'Mã demo được chấp nhận. Chưa có xác thực email thật.',
                );
                context.go('/student-login');
              } else {
                _message(context, 'Nhập đủ 6 chữ số để tiếp tục.');
              }
            },
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Đổi địa chỉ email khác',
            onPressed: () => context.go('/student-signup'),
          ),
        ],
      ),
    );
  }
}

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});
  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  bool _remember = false, _obscure = true;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _AuthPage(
    back: false,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/career_match_logo.png',
              width: 72,
              height: 72,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Sinh Viên',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Chào mừng trở lại! 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Đăng nhập để tiếp tục hành trình nghề nghiệp.',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 22),
          _label('Email trường'),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'ten@truong.edu.vn'),
            validator: (v) =>
                (v == null || !v.contains('@') || !v.contains('.'))
                ? 'Nhập email hợp lệ'
                : null,
          ),
          _label('Mật khẩu'),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (v) => (v?.isEmpty ?? true) ? 'Nhập mật khẩu' : null,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _remember,
            onChanged: (v) => setState(() => _remember = v ?? false),
            title: const Text(
              'Ghi nhớ đăng nhập',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            secondary: TextButton(
              onPressed: () => context.go('/forgot-password'),
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          AppPrimaryButton(
            label: 'Đăng nhập',
            onPressed: () {
              if (_form.currentState!.validate()) {
                _message(
                  context,
                  'Đăng nhập chỉ là UI demo, chưa kết nối tài khoản.',
                );
              }
            },
          ),
          _social(context),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context.go('/student-signup'),
              child: const Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
          ),
          _sdgFooter(),
        ],
      ),
    ),
  );
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _AuthPage(
    title: 'SDG 8 Secure Portal',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: AppColors.blueTint.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 52,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _heading(
            context,
            'Quên mật khẩu?',
            'Nhập email trường đã đăng ký. Chúng tôi sẽ gửi liên kết khôi phục có hiệu lực trong 15 phút.',
          ),
          _label('Email đã đăng ký'),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'ten@truong.edu.vn',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            validator: (v) =>
                (v == null || !v.contains('@') || !v.contains('.'))
                ? 'Nhập email hợp lệ'
                : null,
          ),
          const SizedBox(height: 14),
          const Text(
            'Liên kết demo có hiệu lực 15 phút sau khi được gửi.',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            label: 'Gửi liên kết khôi phục',
            onPressed: () {
              if (_form.currentState!.validate()) {
                _message(
                  context,
                  'Demo: không gửi email thật. Mở bước đặt mật khẩu mới.',
                );
                context.go('/reset-password');
              }
            },
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => context.go('/student-login'),
              child: const Text('Quay lại Đăng nhập'),
            ),
          ),
          _sdgFooter(),
        ],
      ),
    ),
  );
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController(), _confirm = TextEditingController();
  bool _obscure = true;
  @override
  void initState() {
    super.initState();
    _password.addListener(_refresh);
  }

  void _refresh() => setState(() {});
  @override
  void dispose() {
    _password.removeListener(_refresh);
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _password.text;
    final strong =
        p.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(p) &&
        RegExp(r'\d').hasMatch(p);
    return _AuthPage(
      title: 'SDG 8 Secure Portal',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.blueTint.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.password,
                  size: 48,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: 22),
            _heading(
              context,
              'Thiết lập mật khẩu mới',
              'Chọn mật khẩu mạnh để bảo vệ tài khoản của bạn.',
            ),
            _label('Mật khẩu mới'),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu mới',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null ||
                      v.length < 8 ||
                      !RegExp(r'[A-Z]').hasMatch(v) ||
                      !RegExp(r'\d').hasMatch(v))
                  ? 'Cần 8 ký tự, chữ hoa và chữ số'
                  : null,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: p.isEmpty
                  ? 0
                  : strong
                  ? 1
                  : .4,
              color: strong ? AppColors.successAccent : Colors.orange,
            ),
            const SizedBox(height: 8),
            Text(
              strong
                  ? 'Mật khẩu mạnh'
                  : 'Ít nhất 8 ký tự • Có chữ hoa • Có chữ số',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            _label('Xác nhận mật khẩu'),
            TextFormField(
              controller: _confirm,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Nhập lại mật khẩu'),
              validator: (v) =>
                  v != _password.text ? 'Mật khẩu không khớp' : null,
            ),
            const SizedBox(height: 22),
            AppPrimaryButton(
              label: 'Cập nhật mật khẩu',
              onPressed: () {
                if (_form.currentState!.validate()) {
                  _message(
                    context,
                    'Đã hoàn tất demo. Mật khẩu không được lưu.',
                  );
                  context.go('/student-login');
                }
              },
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Cần hỗ trợ? Liên hệ quản trị viên trường.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
            _sdgFooter(),
          ],
        ),
      ),
    );
  }
}
