import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';

class _AuthPage extends StatelessWidget {
  const _AuthPage({
    required this.child,
    this.title,
    this.back = true,
    this.progress,
  });
  final Widget child;
  final String? title;
  final bool back;
  final double? progress;
  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final authTheme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(primary: AppColors.navy),
      filledButtonTheme: FilledButtonThemeData(
        style: baseTheme.filledButtonTheme.style?.copyWith(
          backgroundColor: const WidgetStatePropertyAll(AppColors.navy),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Theme(
                data: authTheme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (back || title != null) ...[
                      Row(
                        children: [
                          if (back)
                            Material(
                              color: AppColors.surfaceMuted,
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/welcome');
                                  }
                                },
                                icon: const Icon(Icons.arrow_back, size: 20),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                          else
                            const SizedBox(width: 44),
                          const Spacer(),
                          if (title != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successTint.withValues(
                                  alpha: .45,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                title!,
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (progress != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: AppColors.outline,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
Widget _passwordRule(bool passed, String label) => Padding(
  padding: const EdgeInsets.only(top: 4),
  child: Row(
    children: [
      Icon(
        passed ? Icons.check_circle : Icons.circle_outlined,
        size: 14,
        color: passed ? AppColors.successAccent : AppColors.textMuted,
      ),
      const SizedBox(width: 7),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: passed ? AppColors.textSecondary : AppColors.textMuted,
        ),
      ),
    ],
  ),
);
Widget _social(BuildContext context) => Column(
  children: [
    const SizedBox(height: 10),
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
    const SizedBox(height: 8),
    Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                _message(context, 'Đăng nhập mạng xã hội chỉ là bản demo.'),
            icon: const Icon(Icons.g_mobiledata, size: 18),
            label: const Text('Google', overflow: TextOverflow.ellipsis),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                _message(context, 'Đăng nhập mạng xã hội chỉ là bản demo.'),
            icon: const Icon(Icons.business, size: 16),
            label: const Text('LinkedIn', overflow: TextOverflow.ellipsis),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
      ],
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
    title: 'Bước 1 / 2',
    progress: .5,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successTint.withValues(alpha: .24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/verified_campus.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified Campus',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hãy xác minh thông tin trường bằng email trường.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 13,
                  color: AppColors.success,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Hỗ trợ xác minh hồ sơ sinh viên và gợi ý việc làm phù hợp.',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
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
      title: 'SDG 8 · BẢO MẬT TÀI KHOẢN',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.blueTint.withValues(alpha: .5),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Color(0x22305B8D), blurRadius: 18),
                ],
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 42,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Xác thực email của bạn',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'Nhập mã xác minh 6 chữ số đã được gửi đến email trường của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: Stack(
              children: [
                IgnorePointer(
                  child: Row(
                    children: List.generate(6, (index) {
                      final value = _code.text;
                      final digit = index < value.length ? value[index] : '';
                      return Expanded(
                        child: Container(
                          height: 48,
                          margin: EdgeInsets.only(right: index == 5 ? 0 : 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text(
                            digit,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Positioned.fill(
                  child: TextField(
                    controller: _code,
                    focusNode: _focus,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.transparent),
                    cursorColor: Colors.transparent,
                    decoration: const InputDecoration(
                      counterText: '',
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    children: [
                      TextSpan(text: 'Gửi lại mã sau '),
                      TextSpan(
                        text: '00:45',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: ' ·'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _message(
                    context,
                    'Mã xác minh chỉ là minh họa; hệ thống chưa gửi email.',
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Gửi lại', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 18,
                  color: AppColors.navy,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mẹo kiểm tra hộp thư',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Nếu chưa thấy mã, hãy kiểm tra mục Spam hoặc thử gửi lại. Nội dung email chỉ là minh họa trong bản demo.',
                        style: TextStyle(fontSize: 10, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
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
              'CareerMatch AI  •  Sinh Viên',
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
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12002549),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Email trường'),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'ten@truong.edu.vn',
                  ),
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
                  validator: (v) =>
                      (v?.isEmpty ?? true) ? 'Nhập mật khẩu' : null,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Checkbox(
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Ghi nhớ đăng nhập',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                AppPrimaryButton(
                  label: 'Đăng nhập',
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      _message(
                        context,
                        'Đăng nhập chỉ là UI demo, chưa kết nối tài khoản.',
                      );
                      context.go('/student-home');
                    }
                  },
                ),
                _social(context),
                const SizedBox(height: 6),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/student-signup'),
                    child: const Text('Chưa có tài khoản? Đăng ký ngay'),
                  ),
                ),
              ],
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
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blueTint, width: 6),
                boxShadow: const [
                  BoxShadow(color: Color(0x14305B8D), blurRadius: 12),
                ],
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 36,
                color: AppColors.blue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Quên mật khẩu?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'Dùng email trường đã đăng ký để khôi phục quyền truy cập tài khoản.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, height: 1.35),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10002549),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blueTint.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 17, color: AppColors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Liên kết khôi phục có thời hạn 15 phút; bản hiện tại chỉ minh họa giao diện, không gửi email thật.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
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
              ],
            ),
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
      title: 'BẢO MẬT CHUẨN SDG 8',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.surface, Color(0xFFF0FFF4)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10002549),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.blueTint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.password,
                      color: AppColors.navy,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thiết lập mật khẩu mới',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Chọn mật khẩu mạnh để bảo vệ tài khoản của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10002549),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Column(
                    children: [
                      _passwordRule(p.length >= 8, 'Tối thiểu 8 ký tự'),
                      _passwordRule(
                        RegExp(r'[A-Z]').hasMatch(p),
                        'Chứa ít nhất một chữ hoa',
                      ),
                      _passwordRule(
                        RegExp(r'\d').hasMatch(p),
                        'Chứa ít nhất một chữ số',
                      ),
                    ],
                  ),
                  _label('Xác nhận mật khẩu'),
                  TextFormField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Nhập lại mật khẩu',
                    ),
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
                ],
              ),
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
