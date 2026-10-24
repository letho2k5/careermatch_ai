import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_buttons.dart';
import 'student_app_shell.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => StudentPage(
    selectedTab: 0,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _welcomeCard(context),
        const SizedBox(height: 16),
        _uploadBanner(context),
        const SizedBox(height: 16),
        _profileChecklist(context),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Khám phá việc làm nổi bật tuần này',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _message(
                context,
                'Danh sách việc làm chưa thuộc phạm vi hiện tại.',
              ),
              child: const Text('2 vị trí hot'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _jobCard(
          context,
          company: 'FPT',
          title: 'Junior AI & Data Engineer',
          subtitle: 'FPT Software • Quận 9, TP.HCM',
          salary: '12 - 18 triệu VNĐ',
          icon: Icons.auto_awesome,
          color: AppColors.blueTint,
        ),
        const SizedBox(height: 10),
        _jobCard(
          context,
          company: 'VNG',
          title: 'Product Analyst Intern (Paid)',
          subtitle: 'VNG Campus • Quận 7, TP.HCM',
          salary: '8 - 10 triệu VNĐ',
          icon: Icons.insights,
          color: AppColors.successTint,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F7EA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.public, color: AppColors.success),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cam kết Việc làm Bền vững (SDG 8)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mọi vị trí dành cho sinh viên đều được xác minh mức thù lao và lộ trình cố vấn.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _welcomeCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/student_avatar.png',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào An! 👋',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hãy hoàn thiện hồ sơ để mở khóa gợi ý việc làm chuẩn xác nhất từ AI.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.verified, color: AppColors.success, size: 19),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(
                      value: .3,
                      strokeWidth: 4,
                      backgroundColor: AppColors.outline,
                    ),
                    const Text(
                      '30%',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30% Hoàn thành',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Còn 3 bước để sẵn sàng nhận việc',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () => context.go('/student-profile-setup-1'),
                child: const Text('Tiếp tục'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _uploadBanner(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.navyLight, AppColors.navy],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x18002549),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const DemoPill(label: 'AI Parsing 2.0'),
            const Spacer(),
            const Icon(Icons.document_scanner_outlined, color: Colors.white70),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Tải CV để AI quét kỹ năng tức thì',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hệ thống tự động trích xuất chứng chỉ, kỹ năng và kết nối nhà tuyển dụng chuẩn SDG 8 trong 15 giây.',
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 14),
        AppPrimaryButton(
          label: 'Tải CV lên (PDF)',
          icon: Icons.upload_file,
          onPressed: () => context.go('/cv-upload'),
        ),
      ],
    ),
  );

  Widget _profileChecklist(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Lộ trình hoàn thiện',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            const DemoPill(label: '1 / 4 Bước'),
          ],
        ),
        const SizedBox(height: 10),
        _step(
          Icons.check_circle,
          'Tạo tài khoản sinh viên',
          'Đã xác thực email trường',
          true,
          null,
        ),
        _step(
          Icons.person,
          'Thiết lập thông tin cá nhân & trường học',
          'Chỉ mất 1 phút',
          false,
          () => context.go('/student-profile-setup-1'),
        ),
        _step(
          Icons.tune,
          'Chọn mục tiêu nghề nghiệp & kỹ năng',
          'Định hướng AI Career Path',
          false,
          () => context.go('/student-profile-setup-2'),
        ),
        _step(
          Icons.description_outlined,
          'Tải CV hoặc tạo hồ sơ năng lực',
          'Mở khóa gợi ý tuyển dụng 90%+',
          false,
          () => context.go('/cv-upload'),
        ),
      ],
    ),
  );

  Widget _step(
    IconData icon,
    String title,
    String subtitle,
    bool done,
    VoidCallback? onTap,
  ) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: done ? AppColors.success : AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              done ? Icons.check : icon,
              size: 16,
              color: done ? Colors.white : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (!done)
            Icon(
              onTap == null ? Icons.lock_outline : Icons.chevron_right,
              size: 17,
              color: AppColors.textMuted,
            ),
        ],
      ),
    ),
  );

  Widget _jobCard(
    BuildContext context, {
    required String company,
    required String title,
    required String subtitle,
    required String salary,
    required IconData icon,
    required Color color,
  }) => InkWell(
    onTap: () => _message(context, 'Hoàn thiện hồ sơ để xem Match Score.'),
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  salary,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline, size: 18, color: AppColors.textMuted),
        ],
      ),
    ),
  );

  static void _message(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}
