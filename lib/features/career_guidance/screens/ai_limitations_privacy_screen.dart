import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/career_widgets.dart';

class AiLimitationsPrivacyScreen extends StatelessWidget {
  const AiLimitationsPrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => CareerPage(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CareerBackHeader(title: 'Giới hạn & quyền riêng tư'),
        const CareerDemoNote(text: 'Thông tin về bản demo hiện tại'),
        const SizedBox(height: 12),
        const CareerCard(
          color: AppColors.navy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minh bạch về dữ liệu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Các chức năng hướng nghiệp trong giai đoạn này dùng dữ liệu demo và state trong bộ nhớ của ứng dụng.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),
        const CareerSectionTitle('Ứng dụng hiện xử lý gì?'),
        const CareerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PrivacyRow(
                Icons.person_outline,
                'Hồ sơ và kỹ năng',
                'Có thể đọc từ student draft đang dùng trong ứng dụng; đây là state demo trong bộ nhớ.',
              ),
              _PrivacyRow(
                Icons.checklist,
                'Milestone và câu trả lời',
                'Các lựa chọn, tiến độ tự đánh dấu, kết quả tự đánh giá và câu trả lời phỏng vấn chỉ nằm trong state phiên hiện tại.',
              ),
              _PrivacyRow(
                Icons.cloud_off_outlined,
                'Dịch vụ bên ngoài',
                'Các màn hình này không gửi nội dung tới backend, API AI hoặc nhà tuyển dụng.',
              ),
            ],
          ),
        ),
        const CareerSectionTitle('Giới hạn'),
        const CareerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PrivacyRow(
                Icons.info_outline,
                'Không có phân tích AI thật',
                'Điểm tự đánh giá được tính từ đáp án trong bộ câu hỏi demo. Phản hồi phỏng vấn chỉ dựa trên vài quy tắc từ khóa và độ dài.',
              ),
              _PrivacyRow(
                Icons.restart_alt,
                'Không lưu bền vững',
                'Dữ liệu phiên có thể mất khi ứng dụng đóng hoặc state được khởi tạo lại.',
              ),
              _PrivacyRow(
                Icons.verified_user_outlined,
                'Không phải cam kết bảo mật',
                'Bản demo chưa xác minh mã hóa, cơ chế xóa dữ liệu, sao lưu hay bảo vệ dữ liệu trên thiết bị.',
              ),
            ],
          ),
        ),
        const CareerSectionTitle('Bạn nên làm gì?'),
        const CareerCard(
          child: Text(
            'Không nhập mật khẩu, thông tin định danh nhạy cảm hoặc dữ liệu bí mật vào câu trả lời luyện tập. Đây là bản demo phục vụ kiểm tra giao diện và luồng cục bộ.',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
        ),
        const SizedBox(height: 14),
        CareerPrimaryButton(
          label: 'Về tổng quan nghề nghiệp',
          icon: Icons.home_outlined,
          onPressed: () => context.go('/career'),
        ),
      ],
    ),
  );
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow(this.icon, this.title, this.body);
  final IconData icon;
  final String title, body;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: AppColors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.4,
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
