import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
    ),
  );
}

Widget _image(String asset, {double height = 210}) => ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.asset(
    asset,
    width: double.infinity,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => const SizedBox(
      height: 120,
      child: Icon(Icons.auto_awesome, size: 48, color: AppColors.blue),
    ),
  ),
);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go('/welcome');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  const Positioned(
                    left: -90,
                    top: -100,
                    child: _Glow(size: 320, color: Color(0x66D4E3FF)),
                  ),
                  const Positioned(
                    right: -110,
                    top: 330,
                    child: _Glow(size: 288, color: Color(0x66DBE1FF)),
                  ),
                  const Positioned(
                    left: 110,
                    bottom: 95,
                    child: _Glow(size: 320, color: Color(0x4D96F7B5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _pill(
                          'AI MATCHING ENGINE LIVE',
                          background: const Color(0xFFECEEF0),
                          foreground: AppColors.textSecondary,
                          dot: AppColors.blue,
                        ),
                        Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                const _Glow(
                                  size: 144,
                                  color: Color(0x66316BF3),
                                ),
                                Container(
                                  width: 112,
                                  height: 112,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x1A000000),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/career_match_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: AppColors.blue,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'CareerMatch AI',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            const SizedBox(
                              width: 270,
                              child: Text(
                                'Cầu nối nghề nghiệp thông minh cho sinh viên',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueTint.withValues(
                                      alpha: .65,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(7),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const Text(
                                  'Đang chuẩn bị hồ sơ...',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            _pill(
                              'SDG 8: Decent Work & Economic Growth',
                              background: AppColors.successTint,
                              foreground: AppColors.success,
                              icon: Icons.work,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'v2.0 • Academic UX/UI Prototype',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 44, spreadRadius: 16)],
      ),
    ),
  );
}

Widget _pill(
  String text, {
  required Color background,
  required Color foreground,
  IconData? icon,
  Color? dot,
}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(999),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (dot != null) ...[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
      ],
      if (icon != null) ...[
        Icon(icon, color: foreground, size: 14),
        const SizedBox(width: 5),
      ],
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: .35,
          ),
        ),
      ),
    ],
  ),
);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => _OnboardingPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _pill(
              'SDG 8: DECENT WORK',
              background: AppColors.success,
              foreground: AppColors.successAccent,
              icon: Icons.work,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8EA),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                children: [
                  _LanguageChip(label: 'Tiếng Việt', selected: true),
                  _LanguageChip(label: 'English'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _image('assets/images/welcome_hero.png', height: 208),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _pill(
                '98.4% Match Rate • AI-Driven',
                background: Colors.white,
                foreground: AppColors.navy,
                icon: Icons.auto_awesome,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.stars_outlined, color: AppColors.blue, size: 14),
            const SizedBox(width: 4),
            Text(
              'CAREERMATCH AI PLATFORM',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.blue,
                fontSize: 12,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Định hình tương lai nghề\nnghiệp của bạn',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: -.65,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDBE1FF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bolt, color: AppColors.blue),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAM KẾT GIÁ TRỊ',
                      style: TextStyle(
                        color: Color(0xFF003EA8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .3,
                      ),
                    ),
                    Text(
                      'AI gợi ý – Minh bạch giải thích – Bạn toàn quyền quyết định',
                      style: TextStyle(
                        color: Color(0xFF00174B),
                        fontSize: 14,
                        height: 1.38,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _Feature(
          title: 'Thực tập chuẩn xác',
          subtitle: 'Gợi ý việc làm theo năng lực thực tế & định hướng',
          icon: Icons.workspace_premium_outlined,
        ),
        const SizedBox(height: 8),
        const _Feature(
          title: 'Lộ trình nâng tầm kỹ năng',
          subtitle: 'Phân tích khoảng trống kỹ năng & gợi ý khóa bổ sung',
          icon: Icons.insights,
        ),
        const SizedBox(height: 8),
        const _Feature(
          title: 'Minh bạch & Bảo mật',
          subtitle: 'Rõ ràng tiêu chí tuyển dụng, mã hóa hồ sơ CV an toàn',
          icon: Icons.shield_outlined,
        ),
        const SizedBox(height: 22),
        AppPrimaryButton(
          label: 'Bắt đầu ngay  →',
          onPressed: () => context.go('/onboarding-one'),
        ),
        const SizedBox(height: 8),
        AppSecondaryButton(
          label: 'Tôi đã có tài khoản • Đăng nhập',
          onPressed: () => context.go('/student-login'),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Đồng hành cùng 120+ trường đại học & doanh nghiệp đạt chuẩn SDG 8',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      boxShadow: selected
          ? const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ]
          : null,
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? AppColors.navy : AppColors.textSecondary,
        fontSize: 11,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.title, required this.icon, this.subtitle});
  final String title;
  final String? subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: subtitle == null ? Colors.white : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      boxShadow: subtitle == null
          ? const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ]
          : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: subtitle == null ? 44 : 32,
          height: subtitle == null ? 44 : 32,
          decoration: BoxDecoration(
            color: subtitle == null ? AppColors.blueTint : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: subtitle == null ? AppColors.navy : AppColors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: subtitle == null ? 14 : 18,
                  height: 1.25,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});
  @override
  Widget build(BuildContext context) => _OnboardingPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _ProgressDots(secondStep: false),
            TextButton(
              onPressed: () => context.go('/choose-role'),
              child: const Text('Bỏ qua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const _MatchPreview(),
        const SizedBox(height: 20),
        const Text(
          'Khám phá việc làm phù hợp\nthực tế',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: -.65,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Hệ thống AI đối chiếu kỹ năng thực tế trong hồ sơ của bạn với hàng ngàn tin tuyển dụng thực tập & fresher, hiển thị lý do phù hợp chi tiết.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const _Feature(
          title: 'Match Score khách quan có căn cứ',
          subtitle: 'Minh bạch từng tiêu chí kinh nghiệm, dự án học thuật và kỹ năng mềm mà nhà tuyển dụng yêu cầu.',
          icon: Icons.analytics,
        ),
        const SizedBox(height: 8),
        const _Feature(
          title: 'Không tự động loại trừ ứng viên',
          subtitle: 'Trao cơ hội bình đẳng cho ứng viên trái ngành hoặc chưa có nhiều kinh nghiệm nhờ phân tích tiềm năng học hỏi.',
          icon: Icons.groups,
        ),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'Tiếp tục',
          onPressed: () => context.go('/onboarding-two'),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Bước 1 trên 2 • Giới thiệu hệ thống',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({super.key});
  @override
  Widget build(BuildContext context) => _OnboardingPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBE1FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Color(0xFF00174B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'BƯỚC 2 / 2',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .6,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.go('/choose-role'),
              child: const Text('Bỏ qua'),
            ),
          ],
        ),
        const _ProgressDots(secondStep: true),
        const SizedBox(height: 8),
        const _SkillRoadmapPreview(),
        const SizedBox(height: 16),
        const Text(
          'Nhận diện khoảng trống & lộ\ntrình kỹ năng',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: -.65,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Không chỉ gợi ý công việc, CareerMatch AI chỉ rõ những kỹ năng còn thiếu so với yêu cầu tuyển dụng và đề xuất tài nguyên học tập chuẩn xác.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            _BenefitPill(icon: Icons.query_stats, label: 'Phân tích Skill Gap'),
            _BenefitPill(
              icon: Icons.menu_book,
              label: 'Gợi ý khóa học miễn phí',
            ),
            _BenefitPill(
              icon: Icons.psychology,
              label: 'Chuẩn bị phỏng vấn tự tin',
            ),
          ],
        ),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'Bắt đầu chọn vai trò',
          onPressed: () => context.go('/choose-role'),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => context.go('/choose-role'),
            icon: const Icon(Icons.verified_user_outlined, size: 16),
            label: const Text('Tìm hiểu về nguyên tắc AI có trách nhiệm'),
          ),
        ),
      ],
    ),
  );
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.secondStep});
  final bool secondStep;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(active: !secondStep),
        const SizedBox(width: 4),
        Container(
          width: secondStep ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: secondStep ? AppColors.navyLight : const Color(0xFFC3C6D0),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    ),
  );

  Widget _dot({required bool active}) => Container(
    width: active ? 28 : 8,
    height: 8,
    decoration: BoxDecoration(
      color: active ? AppColors.navyLight : const Color(0xFFC3C6D0),
      borderRadius: BorderRadius.circular(999),
    ),
  );
}

class _MatchPreview extends StatelessWidget {
  const _MatchPreview();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F4F6),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/student_avatar.png',
                  width: 40,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hồ sơ năng lực  ✹',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Đã đối chiếu 14 kỹ năng thực tiễn',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _SmallTag('AI Scan', const Color(0xFFD4E3FF), AppColors.navy),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x330051D5),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.hub_outlined, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8FBF0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEFE5),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.terminal,
                      color: AppColors.navy,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Junior Product Analyst',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Fintech Global • Toàn thời gian',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SmallTag(
                    '✦ 92% Phù hợp',
                    const Color(0xFFDBE1FF),
                    AppColors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  _SmallTag(
                    'SQL & Python',
                    Color(0xFFDDF1E7),
                    AppColors.textSecondary,
                  ),
                  _SmallTag(
                    'Phân tích hành vi',
                    Color(0xFFE6E8EA),
                    AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: _SmallTag(
                  'SDG 8 Lương công bằng',
                  const Color(0xFFE2F4E9),
                  AppColors.successAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SkillRoadmapPreview extends StatelessWidget {
  const _SkillRoadmapPreview();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
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
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SmallTag('⚒ AI Skill Matrix', Color(0xFFDBE1FF), AppColors.navy),
            _SmallTag(
              '♙ SDG 8 Chuẩn hóa',
              AppColors.successTint,
              AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkillBar(
                title: 'Phân tích dữ liệu kinh doanh (SQL/BI)',
                value: '88% / 95%',
                progress: .88,
                target: .95,
              ),
              const SizedBox(height: 8),
              const Text(
                '♧ Đã đạt chuẩn tuyển dụng                 Mục tiêu 95%',
                style: TextStyle(color: AppColors.success, fontSize: 10),
              ),
              const SizedBox(height: 10),
              const _SkillBar(
                title: 'Quản lý vòng đời sản phẩm (Agile)',
                value: '54% / 85%',
                progress: .54,
                target: .85,
                missing: true,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school, color: AppColors.navy, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agile Scrum Practitioner Fast-Track',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '2.5 giờ • Chứng chỉ xác minh SDG',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SmallTag('0đ', AppColors.successTint, AppColors.success),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: _Milestone(
                label: 'Đánh giá',
                icon: Icons.check,
                active: true,
              ),
            ),
            Expanded(
              child: _Milestone(
                label: 'Lấp lỗ hổng',
                icon: Icons.circle,
                active: true,
              ),
            ),
            Expanded(
              child: _Milestone(
                label: 'Ứng tuyển',
                icon: Icons.looks_3_outlined,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({
    required this.title,
    required this.value,
    required this.progress,
    required this.target,
    this.missing = false,
  });
  final String title, value;
  final double progress, target;
  final bool missing;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: missing ? AppColors.error : AppColors.blue,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      LayoutBuilder(
        builder: (context, c) => Stack(
          children: [
            Container(
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E3E5),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Container(
              width: c.maxWidth * progress,
              height: 9,
              decoration: BoxDecoration(
                color: missing
                    ? const Color(0xFFFFDAD6)
                    : const Color(0xFF3874FF),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Positioned(
              left: c.maxWidth * target - 2,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Milestone extends StatelessWidget {
  const _Milestone({
    required this.label,
    required this.icon,
    this.active = false,
  });
  final String label;
  final IconData icon;
  final bool active;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: active
              ? (icon == Icons.check ? AppColors.success : AppColors.blue)
              : const Color(0xFFE0E3E5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active ? Colors.white : AppColors.textMuted,
          size: 13,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: active ? AppColors.textSecondary : AppColors.textMuted,
          fontSize: 9,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ],
  );
}

class _BenefitPill extends StatelessWidget {
  const _BenefitPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE6E8EA),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.navy),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _SmallTag extends StatelessWidget {
  const _SmallTag(this.label, this.background, this.foreground);
  final String label;
  final Color background, foreground;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: foreground,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});
  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => _OnboardingPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFECEEF0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
            _SmallTag(
              '✦  Bước 1/3',
              const Color(0xFFECEEF0),
              AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _pill(
          'SDG 8 • Việc làm bền vững',
          background: AppColors.successTint,
          foreground: const Color(0xFF00522C),
          icon: Icons.work,
        ),
        const SizedBox(height: 8),
        Text(
          'Chọn vai trò của bạn',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        const Text(
          'Trải nghiệm giao diện sẽ được tối ưu theo vai trò bạn lựa chọn.',
        ),
        const SizedBox(height: 16),
        _RoleCard(
          title: 'Sinh viên & Người tìm việc',
          roleBadge: 'Ứng viên',
          subtitle: 'Tìm việc thực tập, phân tích CV, xem mức độ phù hợp và nhận lộ trình nâng cao kỹ năng.',
          icon: Icons.school_outlined,
          selected: selected == 0,
          badge: 'Khuyên dùng',
          metricLabel: 'Độ chuẩn xác đề xuất AI',
          metricValue: '98% match',
          onTap: () => setState(() => selected = 0),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          title: 'Doanh nghiệp & Recruiter',
          roleBadge: 'HR & Lead',
          subtitle: 'Đăng tin tuyển dụng, xem danh sách ứng viên đối soát năng lực và gửi lời mời phỏng vấn.',
          icon: Icons.business_center_outlined,
          selected: selected == 1,
          metricLabel: 'Lọc hồ sơ tự động',
          metricValue: 'Tối ưu 70% thời gian',
          onTap: () => setState(() => selected = 1),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          title: 'Cố vấn học tập & Quản trị',
          roleBadge: 'Đại học',
          subtitle: 'Theo dõi tiến độ định hướng nghề nghiệp của sinh viên, kết nối cơ hội thực tập theo ngành.',
          icon: Icons.support_agent,
          selected: selected == 2,
          metricLabel: 'Báo cáo việc làm',
          metricValue: 'Real-time sync',
          onTap: () => setState(() => selected = 2),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFECEEF0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bạn có thể chuyển đổi vai trò bất kỳ lúc nào trong Cài đặt.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppPrimaryButton(
          label: switch (selected) {
            0 => 'Tiếp tục với tư cách Sinh viên',
            1 => 'Đăng nhập Nhà tuyển dụng',
            _ => 'Mở Career Guidance demo',
          },
          onPressed: () {
            final location = switch (selected) {
              0 => '/student-signup',
              1 => '/employer/login',
              _ => '/admin/login',
            };
            context.go(location);
          },
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.roleBadge,
    required this.metricLabel,
    required this.metricValue,
    this.badge,
  });
  final String title, subtitle, roleBadge, metricLabel, metricValue;
  final String? badge;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.blue : const Color(0xFFF2F4F6),
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.blue : const Color(0xFFE6E8EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : AppColors.navy,
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (badge != null) ...[
                  _SmallTag(
                    '✦  $badge',
                    const Color(0xFFDBE1FF),
                    const Color(0xFF00174B),
                  ),
                  const SizedBox(width: 6),
                ],
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.blue,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _SmallTag(
                  roleBadge,
                  const Color(0xFFE6E8EA),
                  AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    selected ? Icons.verified_user_outlined : Icons.bolt,
                    color: selected ? AppColors.blue : AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      metricLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    metricValue,
                    style: TextStyle(
                      color: selected
                          ? AppColors.blue
                          : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
