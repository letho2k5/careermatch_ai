import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

const _practicePrompt =
    'Hãy kể về một lần bạn tối ưu truy vấn cơ sở dữ liệu. Bạn đã xác định vấn đề, cân nhắc các lựa chọn và đo lường kết quả như thế nào?';

class InterviewPracticeIntroScreen extends ConsumerStatefulWidget {
  const InterviewPracticeIntroScreen({super.key});
  @override
  ConsumerState<InterviewPracticeIntroScreen> createState() =>
      _InterviewPracticeIntroScreenState();
}

class _InterviewPracticeIntroScreenState
    extends ConsumerState<InterviewPracticeIntroScreen> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) => CareerPage(
    useStudentShell: false,
    bottomAction: CareerPrimaryButton(
      label: 'Bắt đầu luyện tập',
      icon: Icons.play_arrow,
      onPressed: accepted
          ? () => context.push('/career/interview-practice/question')
          : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CareerBackHeader(title: 'Luyện phỏng vấn'),
        const CareerDemoNote(
          text: 'Buổi luyện tập cục bộ · phản hồi theo quy tắc đơn giản',
        ),
        const SizedBox(height: 14),
        const CareerCard(
          color: AppColors.navy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backend Developer Intern',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1 câu hỏi hành vi/kỹ thuật · nhập câu trả lời bằng văn bản',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              SizedBox(height: 10),
              Text(
                'Không kết nối mô hình AI, mic hoặc dịch vụ tuyển dụng.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const CareerSectionTitle('Gợi ý cấu trúc câu trả lời'),
        const CareerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HintRow('Bối cảnh', 'Nêu vấn đề và tác động.'),
              _HintRow(
                'Hành động',
                'Giải thích lựa chọn, đánh đổi và cách làm.',
              ),
              _HintRow('Kết quả', 'Chia sẻ kết quả đo được nếu có.'),
            ],
          ),
        ),
        CheckboxListTile(
          value: accepted,
          onChanged: (value) => setState(() => accepted = value ?? false),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Tôi hiểu đây là bài luyện tập demo, không phải đánh giá tuyển dụng.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 80),
      ],
    ),
  );
}

class InterviewPracticeQuestionScreen extends ConsumerStatefulWidget {
  const InterviewPracticeQuestionScreen({super.key});
  @override
  ConsumerState<InterviewPracticeQuestionScreen> createState() =>
      _InterviewPracticeQuestionScreenState();
}

class _InterviewPracticeQuestionScreenState
    extends ConsumerState<InterviewPracticeQuestionScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(careerGuidanceProvider).interviewAnswer,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final answer = ref.watch(careerGuidanceProvider).interviewAnswer;
    return CareerPage(
      useStudentShell: false,
      bottomAction: CareerPrimaryButton(
        label: 'Xem phản hồi demo',
        icon: Icons.rate_review_outlined,
        onPressed: answer.trim().isEmpty
            ? null
            : () => context.push('/career/interview-practice/feedback'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Câu hỏi phỏng vấn'),
          const CareerDemoNote(text: 'Câu hỏi luyện tập minh họa'),
          const SizedBox(height: 12),
          const CareerCard(
            child: Text(
              _practicePrompt,
              style: TextStyle(
                fontSize: 16,
                height: 1.45,
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const CareerSectionTitle('Câu trả lời của bạn'),
          TextField(
            controller: _controller,
            maxLines: 8,
            maxLength: 800,
            textInputAction: TextInputAction.newline,
            onChanged: ref
                .read(careerGuidanceProvider.notifier)
                .updateInterviewAnswer,
            decoration: const InputDecoration(
              hintText: 'Nhập câu trả lời…',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const CareerCard(
            color: AppColors.blueTint,
            child: Text(
              'Nội dung được giữ trong state của ứng dụng trong phiên hiện tại. Không gửi đi và có thể mất khi ứng dụng đóng.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 84),
        ],
      ),
    );
  }
}

class InterviewPracticeFeedbackScreen extends ConsumerWidget {
  const InterviewPracticeFeedbackScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answer = ref.watch(careerGuidanceProvider).interviewAnswer.trim();
    if (answer.isEmpty) {
      return CareerPage(
        useStudentShell: false,
        child: Column(
          children: [
            const CareerBackHeader(title: 'Chưa có câu trả lời'),
            const CareerCard(
              child: Text('Hãy nhập câu trả lời trước khi xem phản hồi.'),
            ),
            CareerPrimaryButton(
              label: 'Quay lại câu hỏi',
              onPressed: () =>
                  context.go('/career/interview-practice/question'),
            ),
          ],
        ),
      );
    }
    final words = answer
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    final terms = ['vấn đề', 'tối ưu', 'index', 'đo', 'kết quả', 'đánh đổi'];
    final found = terms
        .where((term) => answer.toLowerCase().contains(term))
        .toList();
    return CareerPage(
      useStudentShell: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Phản hồi luyện tập'),
          const CareerDemoNote(
            text: 'Phản hồi demo theo từ khóa · không phải AI',
          ),
          const CareerCard(
            color: AppColors.navy,
            child: Text(
              'Đây là gợi ý dựa trên độ dài và một số từ khóa. Nội dung chưa được đánh giá ngữ nghĩa hoặc độ chính xác.',
              style: TextStyle(color: Colors.white, height: 1.4),
            ),
          ),
          CareerSectionTitle('Câu trả lời ($words từ)'),
          CareerCard(
            child: Text(
              answer,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
          const CareerSectionTitle('Quan sát theo quy tắc demo'),
          CareerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  words < 35
                      ? 'Câu trả lời còn ngắn; bạn có thể bổ sung bối cảnh và kết quả.'
                      : 'Độ dài có thể đủ để trình bày một ví dụ; hãy tự kiểm tra câu chuyện có rõ ràng không.',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  found.isEmpty
                      ? 'Chưa thấy từ khóa gợi ý về vấn đề, cách làm hoặc kết quả.'
                      : 'Từ khóa được nhận diện: ${found.join(', ')}.',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CareerPrimaryButton(
            label: 'Chỉnh sửa câu trả lời',
            icon: Icons.edit_outlined,
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.go('/career'),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Về tổng quan nghề nghiệp'),
          ),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow(this.title, this.body);
  final String title, body;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 8, color: AppColors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title — $body',
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ),
      ],
    ),
  );
}
