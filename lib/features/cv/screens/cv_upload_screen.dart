import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../student_home/student_app_shell.dart';
import '../../student_profile/student_draft.dart';
import '../cv_file_validation.dart';

typedef CvFilePicker = Future<PlatformFile?> Function();

class CvUploadScreen extends ConsumerStatefulWidget {
  const CvUploadScreen({this.pickFile, super.key});
  final CvFilePicker? pickFile;
  @override
  ConsumerState<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends ConsumerState<CvUploadScreen> {
  bool _busy = false;

  Future<void> _pickFile() async {
    setState(() => _busy = true);
    try {
      final file = widget.pickFile == null
          ? await FilePicker.pickFile(
              type: FileType.custom,
              allowedExtensions: const ['pdf', 'doc', 'docx'],
              dialogTitle: 'Chọn CV / Resume',
            )
          : await widget.pickFile!();
      if (!mounted || file == null) return;
      int? bytes;
      try {
        bytes = file.lengthSync() ?? await file.length();
      } catch (_) {
        bytes = null;
      }
      if (!mounted) return;
      final validationError = validateCvFile(
        name: file.name,
        extension: file.extension,
        bytes: bytes,
      );
      if (validationError != null) {
        _message(_validationMessage(validationError));
        return;
      }
      final current = ref.read(careerDraftProvider);
      ref
          .read(careerDraftProvider.notifier)
          .update(current.copyWith(cvName: file.name.trim(), cvBytes: bytes));
    } catch (_) {
      if (mounted) _message('Không thể mở bộ chọn tệp. Hãy thử lại.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _validationMessage(CvFileValidationError error) => switch (error) {
    CvFileValidationError.emptyName => 'Tệp được chọn không có tên hợp lệ.',
    CvFileValidationError.unsupportedExtension =>
      'Chỉ hỗ trợ tệp PDF, DOC hoặc DOCX.',
    CvFileValidationError.unknownSize =>
      'Không xác định được dung lượng tệp đã chọn.',
    CvFileValidationError.emptyFile => 'Tệp đã chọn đang trống.',
    CvFileValidationError.tooLarge => 'Tệp vượt quá giới hạn 5 MB.',
  };

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(careerDraftProvider);
    return StudentPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentBackRow(
            title: 'Tải lên CV / Resume',
            trailing: IconButton(
              onPressed: () =>
                  _message('CV chỉ được giữ cục bộ trong demo này.'),
              icon: const Icon(Icons.shield_outlined, color: AppColors.blue),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F7EA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHẾ ĐỘ DEMO • TỆP KHÔNG RỜI THIẾT BỊ',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tệp được chọn không tải lên máy chủ. Bản demo chỉ lưu tên và dung lượng tạm trong bộ nhớ ứng dụng.',
                        style: TextStyle(
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
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: _busy ? null : _pickFile,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.blueTint,
                      shape: BoxShape.circle,
                    ),
                    child: _busy
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.cloud_upload_outlined,
                            color: AppColors.blue,
                            size: 38,
                          ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Kéo thả hoặc chạm để chọn tệp',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Định dạng hỗ trợ: PDF, DOC, DOCX (tối đa 5 MB)',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  AppPrimaryButton(
                    label: 'Chọn tệp từ thiết bị',
                    icon: Icons.upload_file,
                    onPressed: _busy ? null : _pickFile,
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: AppColors.successAccent,
                      ),
                      Text(
                        'Sẵn sàng quét OCR',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.success,
                        ),
                      ),
                      Icon(Icons.bolt, size: 14, color: AppColors.blue),
                      Text(
                        'Nhận diện kỹ năng tức thì',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'HOẶC',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
          ),
          SectionCard(
            title: 'Tạo CV nhanh từ hồ sơ đã nhập',
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Dành cho sinh viên chưa có sẵn file CV hoàn chỉnh.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.go('/student-profile-setup-1'),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          if (d.cvName != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'TỆP SẴN SÀNG XỬ LÝ',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ),
                const DemoPill(label: 'Đã xác thực cục bộ'),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    color: AppColors.error,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.cvName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatSize(d.cvBytes ?? 0),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _message(
                      'Tệp không được tải lên; chỉ lưu tên/dung lượng.',
                    ),
                    icon: const Icon(Icons.visibility_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      final current = ref.read(careerDraftProvider);
                      ref
                          .read(careerDraftProvider.notifier)
                          .update(current.copyWith(clearCv: true));
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _miniBadge(
                  Icons.public,
                  'Phân tích SDG 8',
                  'Thực tập thỏa đáng',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _miniBadge(
                  Icons.shield_outlined,
                  'Bảo mật hồ sơ',
                  'Mã hóa demo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'Quét & Phân tích bằng AI',
            icon: Icons.auto_awesome,
            onPressed: d.cvName == null
                ? null
                : () => context.go('/cv-progress'),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Gợi ý tối ưu hóa CV',
            trailing: const DemoPill(label: 'AI Insights • demo'),
            child: const Text(
              'Bản demo chưa phân tích tệp thật. Kết quả minh họa sẽ hiển thị ở bước tiếp theo.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(IconData icon, String title, String subtitle) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.blue, size: 19),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
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
  String _formatSize(int bytes) => bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(0)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  void _message(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}
