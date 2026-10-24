import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_home/student_app_shell.dart';
import '../../student_profile/student_draft.dart';

class CvProgressScreen extends ConsumerStatefulWidget {
  const CvProgressScreen({super.key});
  @override
  ConsumerState<CvProgressScreen> createState() => _CvProgressScreenState();
}

class _CvProgressScreenState extends ConsumerState<CvProgressScreen> {
  Timer? _timer;
  int _progress = 78;
  int _step = 2;
  bool _cancelled = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (!mounted || _cancelled) return;
      setState(() {
        _progress = (_progress + 4).clamp(0, 100);
        if (_progress >= 84) _step = 3;
      });
      if (_progress >= 100) {
        _timer?.cancel();
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_cancelled) context.go('/cv-analysis-result');
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    return StudentPage(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Đang phân tích CV',
            trailing: const DemoPill(label: 'AI Demo'),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        size: 88,
                        color: AppColors.blueTint,
                      ),
                      Positioned(
                        top: 34,
                        child: Container(
                          width: 110,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 12,
                        child: Row(
                          children: [
                            Chip(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              label: Text(
                                'Python',
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                            Chip(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              label: Text(
                                'React',
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                            Chip(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              label: Text(
                                'SDG 8',
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const DemoPill(label: 'AI Parsing in progress (Demo Mode)'),
                const SizedBox(height: 8),
                Text(
                  '$_progress%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const Text(
                  'hoàn tất',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress / 100,
                    minHeight: 8,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 13,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Tệp chỉ xử lý cục bộ trong bản demo',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Tốc độ: 1.4s/trang (demo)',
                      style: TextStyle(fontSize: 10, color: AppColors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Tiến trình chi tiết',
            trailing: Text(
              '$_step / 4 giai đoạn',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            child: Column(
              children: [
                _progressStep(
                  1,
                  'Trích xuất thông tin học vấn & đại học',
                  'Xác thực bằng cấp, GPA và niên khóa từ dữ liệu gốc.',
                  true,
                ),
                _progressStep(
                  2,
                  'Nhận diện kỹ năng công nghệ cốt lõi',
                  'Ánh xạ kỹ năng lập trình, framework và công cụ phân tích.',
                  true,
                ),
                _progressStep(
                  3,
                  'Đối chiếu từ khóa tuyển dụng SDG 8',
                  'Phân tích mức độ đáp ứng tiêu chuẩn làm việc bình đẳng & bền vững.',
                  _step >= 3,
                ),
                _progressStep(
                  4,
                  'Chuẩn bị bảng giải thích Match Score',
                  'Khởi tạo báo cáo minh họa cùng gợi ý cải thiện kỹ năng.',
                  false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _stat(
                  Icons.public,
                  'Chuẩn SDG 8',
                  'Mức đãi ngộ minh bạch',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _stat(
                  Icons.trending_up,
                  'Tỉ lệ tương thích',
                  'Dự báo vị trí phù hợp',
                ),
              ),
            ],
          ),
          if (d.cvName != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Tệp đang xử lý cục bộ: ${d.cvName!}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blueTint.withValues(alpha: .42),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Đây là tiến trình UI minh họa. Không có tệp nào được tải lên máy chủ hoặc phân tích bởi AI thật.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.navy,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _cancelled = true;
                _timer?.cancel();
                context.go('/cv-upload');
              },
              icon: const Icon(Icons.close),
              label: const Text('Hủy phân tích'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressStep(
    int number,
    String title,
    String subtitle,
    bool active,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: active
              ? AppColors.successAccent
              : AppColors.surfaceMuted,
          child: Icon(
            active ? Icons.check : Icons.circle_outlined,
            size: 15,
            color: active ? Colors.white : AppColors.textMuted,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Text(
          active
              ? 'Đã xong'
              : number == 3
              ? 'Đang chạy'
              : 'Chờ',
          style: TextStyle(
            fontSize: 9,
            color: active ? AppColors.success : AppColors.textMuted,
          ),
        ),
      ],
    ),
  );
  Widget _stat(IconData icon, String title, String subtitle) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.blue, size: 17),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
