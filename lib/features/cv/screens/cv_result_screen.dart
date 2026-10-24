import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../../student_profile/student_draft.dart';

class CvResultScreen extends ConsumerWidget {
  const CvResultScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(careerDraftProvider);
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Kết quả phân tích CV',
            trailing: IconButton(
              onPressed: () => _message(
                context,
                'Chia sẻ chưa được tích hợp trong bản demo.',
              ),
              icon: const Icon(Icons.share_outlined),
            ),
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 7,
              children: [
                const Icon(
                  Icons.circle,
                  size: 7,
                  color: AppColors.successAccent,
                ),
                const Text(
                  'AI Parser 4.2 Pro',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                const DemoPill(label: 'DEMO RESULT'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navyLight, AppColors.blue],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Phân tích hoàn tất • Demo Result',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: .8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'SDG 8\nALIGNED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    SizedBox(
                      width: 78,
                      height: 78,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircularProgressIndicator(
                            value: .88,
                            strokeWidth: 7,
                            color: AppColors.successAccent,
                            backgroundColor: Colors.white24,
                          ),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '88%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Tương thích',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Độ khớp mục tiêu ban đầu',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rất tiềm năng cho vị trí Backend Developer Intern.',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Hồ sơ đạt tiêu chuẩn sơ loại (minh họa)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Đánh giá trọng tâm',
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () => _message(
                  context,
                  'Chi tiết thuật toán chưa có trong phạm vi demo.',
                ),
                child: const Text('Chi tiết thuật toán'),
              ),
            ],
          ),
          SectionCard(
            title: 'Điểm mạnh nổi bật',
            trailing: const DemoPill(label: 'Demo'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phù hợp hoàn hảo với kiến trúc hệ thống hiện đại',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 3,
                  children:
                      [
                            'Python (FastAPI/Django)',
                            'RESTful API',
                            'Cơ sở dữ liệu quan hệ (PostgreSQL)',
                            'Kỹ năng làm việc nhóm Agile',
                          ]
                          .map(
                            (s) => Chip(
                              avatar: const Icon(
                                Icons.circle,
                                size: 7,
                                color: AppColors.blue,
                              ),
                              label: Text(
                                s,
                                style: const TextStyle(fontSize: 10),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SectionCard(
            title: 'Khoảng trống kỹ năng cần bổ sung',
            trailing: const DemoPill(label: 'Gợi ý demo'),
            child: Column(
              children: [
                for (final gap in const [
                  ('Docker container cơ bản', 'Học 3 giờ'),
                  ('CI/CD pipeline (GitHub Actions)', 'Học 4 giờ'),
                  ('Unit testing với Pytest', 'Học 2 giờ'),
                ])
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.blue,
                    ),
                    title: Text(gap.$1, style: const TextStyle(fontSize: 11)),
                    trailing: Text(
                      gap.$2,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SectionCard(
            title: 'Dữ liệu hồ sơ trích xuất tự động (demo)',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        Icons.school_outlined,
                        'HỌC VẤN',
                        d.university.isEmpty
                            ? 'Đại học Bách Khoa TP.HCM (mẫu)'
                            : d.university,
                        'GPA ${d.gpa.isEmpty ? '3.42' : d.gpa} / 4.0',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoTile(
                        Icons.star_outline,
                        'Kỹ năng tìm thấy',
                        '${d.extractedSkills.length} kỹ năng',
                        'Mẫu trích xuất',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        Icons.code,
                        'Dự án nổi bật',
                        d.experiences.isEmpty
                            ? 'Thông tin chưa có'
                            : d.experiences.first.title,
                        'Dữ liệu cục bộ',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoTile(
                        Icons.verified_outlined,
                        'Mức độ tin cậy',
                        'Minh họa',
                        'Không phải kết quả AI thật',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              children: [
                Icon(Icons.public, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cam kết tuyển dụng công bằng (SDG 8)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'Mức lương minh bạch và có người hướng dẫn dành riêng cho sinh viên thực tập.',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppPrimaryButton(
            label: 'Xác nhận & Chỉnh sửa kỹ năng',
            icon: Icons.tune,
            onPressed: () => context.go('/cv-edit-skills'),
          ),
          const SizedBox(height: 8),
          AppSecondaryButton(
            label: 'Khám phá ngay việc làm phù hợp',
            icon: Icons.search,
            onPressed: () =>
                _message(context, 'Tính năng việc làm sẽ nằm ở giai đoạn sau.'),
          ),
          if (d.cvName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'Tệp: ${d.cvName!} • Kết quả hiển thị là dữ liệu demo',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
    String subtitle,
  ) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.blue, size: 18),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
        ),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 9, color: AppColors.success),
        ),
      ],
    ),
  );
  static void _message(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
