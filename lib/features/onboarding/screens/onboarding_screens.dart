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

Widget _badge(String text) => DecoratedBox(
  decoration: BoxDecoration(
    color: AppColors.successTint.withValues(alpha: .34),
    borderRadius: BorderRadius.circular(30),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.success,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: .5,
      ),
    ),
  ),
);

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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _badge('AI MATCHING ENGINE LIVE'),
              const SizedBox(height: 34),
              Container(
                width: 116,
                height: 116,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(color: Color(0x18305B8D), blurRadius: 36),
                  ],
                ),
                child: Image.asset(
                  'assets/images/career_match_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'CareerMatch AI',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Cầu nối nghề nghiệp thông minh cho sinh viên',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(strokeWidth: 2),
              const SizedBox(height: 12),
              const Text(
                'Đang chuẩn bị hồ sơ...',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 30),
              _badge('SDG 8  •  DECENT WORK'),
              const SizedBox(height: 20),
              const Text(
                'v2.0 • Academic Prototype',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

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
            _badge('SDG 8: DECENT WORK'),
            TextButton(onPressed: () {}, child: const Text('VI  |  EN')),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Định hình tương lai nghề nghiệp của bạn',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blueTint.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'CAM KẾT GIÁ TRỊ\nAI gợi ý – Minh bạch giải thích – Bạn toàn quyền quyết định',
            style: TextStyle(color: AppColors.navy, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        const _Feature(title: 'Thực tập chuẩn xác', icon: Icons.track_changes),
        const SizedBox(height: 8),
        const _Feature(title: 'Lộ trình nâng tầm kỹ năng', icon: Icons.route),
        const SizedBox(height: 8),
        const _Feature(
          title: 'Minh bạch & Bảo mật',
          icon: Icons.shield_outlined,
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.topRight,
          children: [
            _image('assets/images/welcome_hero.png', height: 208),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _badge('98.4% MATCH'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppPrimaryButton(
          label: 'Bắt đầu ngay',
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
            'Được tin dùng bởi sinh viên và đối tác tuyển dụng',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const Icon(
          Icons.check_circle,
          color: AppColors.successAccent,
          size: 18,
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
            const Text(
              'Giới thiệu hệ thống',
              style: TextStyle(color: AppColors.textMuted),
            ),
            TextButton(
              onPressed: () => context.go('/choose-role'),
              child: const Text('Bỏ qua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: .5),
        const SizedBox(height: 30),
        _image('assets/images/onboarding_match_profile.png', height: 210),
        const SizedBox(height: 26),
        Text(
          'Khám phá việc làm phù hợp thực tế',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'Tìm cơ hội thực tập phù hợp với năng lực, sở thích và mục tiêu nghề nghiệp của bạn.',
        ),
        const SizedBox(height: 20),
        const _Feature(
          title: 'Match Score khách quan',
          icon: Icons.analytics_outlined,
        ),
        const SizedBox(height: 10),
        const _Feature(
          title: 'Không tự động loại trừ ứng viên',
          icon: Icons.balance,
        ),
        const SizedBox(height: 26),
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
            const Text(
              'Giới thiệu hệ thống',
              style: TextStyle(color: AppColors.textMuted),
            ),
            TextButton(
              onPressed: () => context.go('/choose-role'),
              child: const Text('Bỏ qua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 1),
        const SizedBox(height: 24),
        Row(
          children: [
            _badge('SKILL MATRIX'),
            const SizedBox(width: 8),
            _badge('SDG 8'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 10),
                  Expanded(child: Text('Kỹ năng hiện tại')),
                  Icon(Icons.arrow_forward, color: AppColors.blue),
                  SizedBox(width: 8),
                  Icon(Icons.work_outline),
                  SizedBox(width: 8),
                  Text('Yêu cầu công việc'),
                ],
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(value: .62),
              SizedBox(height: 8),
              Text(
                'Phân tích khoảng cách kỹ năng',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Nhận diện khoảng trống & lộ trình kỹ năng',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'Biết mình đang ở đâu và cần phát triển kỹ năng nào để sẵn sàng cho công việc tương lai.',
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _badge('Cá nhân hóa'),
            _badge('Minh bạch'),
            _badge('Có định hướng'),
          ],
        ),
        const SizedBox(height: 26),
        AppPrimaryButton(
          label: 'Bắt đầu chọn vai trò',
          onPressed: () => context.go('/choose-role'),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Tìm hiểu về nguyên tắc AI có trách nhiệm',
            style: TextStyle(color: AppColors.blue, fontSize: 12),
          ),
        ),
      ],
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
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            const Text(
              'Bước 1 / 3',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('Bạn là ai?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Chọn vai trò phù hợp để cá nhân hóa trải nghiệm của bạn.'),
        const SizedBox(height: 24),
        _RoleCard(
          title: 'Sinh viên & Người tìm việc',
          subtitle: 'Khám phá cơ hội và phát triển nghề nghiệp',
          icon: Icons.school_outlined,
          selected: selected == 0,
          onTap: () => setState(() => selected = 0),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          title: 'Nhà tuyển dụng',
          subtitle: 'Tìm ứng viên phù hợp cho doanh nghiệp',
          icon: Icons.business_center_outlined,
          selected: selected == 1,
          onTap: () => setState(() => selected = 1),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          title: 'Cố vấn học thuật',
          subtitle: 'Hỗ trợ định hướng nghề nghiệp sinh viên',
          icon: Icons.support_agent,
          selected: selected == 2,
          onTap: () => setState(() => selected = 2),
        ),
        const SizedBox(height: 20),
        const Text(
          'Bạn có thể thay đổi vai trò trong phần cài đặt.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 18),
        AppPrimaryButton(
          label: selected == 0 ? 'Tiếp tục với tư cách Sinh viên' : 'Tiếp tục',
          onPressed: () {
            if (selected == 0) {
              context.go('/student-signup');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Luồng này chưa thuộc phạm vi ST-01 đến ST-10.',
                  ),
                ),
              );
            }
          },
        ),
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
  });
  final String title, subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.blue : AppColors.outline,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: selected ? AppColors.blue : AppColors.textSecondary,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.blue : AppColors.textMuted,
          ),
        ],
      ),
    ),
  );
}
