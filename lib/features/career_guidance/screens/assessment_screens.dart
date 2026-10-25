import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../data/career_guidance_demo_data.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class SkillAssessmentIntroScreen extends ConsumerStatefulWidget {
  const SkillAssessmentIntroScreen({super.key});
  @override
  ConsumerState<SkillAssessmentIntroScreen> createState() =>
      _SkillAssessmentIntroScreenState();
}

class _SkillAssessmentIntroScreenState
    extends ConsumerState<SkillAssessmentIntroScreen> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) => CareerPage(
    useStudentShell: false,
    bottomAction: CareerPrimaryButton(
      label: 'Bắt đầu tự đánh giá',
      icon: Icons.play_arrow,
      onPressed: accepted
          ? () {
              ref.read(careerGuidanceProvider.notifier).startAssessment();
              context.push('/career/assessment/question');
            }
          : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CareerBackHeader(title: 'Tự đánh giá kỹ năng'),
        const CareerDemoNote(
          text: 'Bài tự đánh giá minh họa · không phải chứng chỉ',
        ),
        const SizedBox(height: 14),
        const CareerCard(
          color: AppColors.navy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Docker & DevOps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '10 câu hỏi · khoảng 15 phút',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 12),
              Text(
                'Câu trả lời chỉ được dùng để tạo kết quả minh họa trong phiên này.',
                style: TextStyle(color: Colors.white, height: 1.4),
              ),
            ],
          ),
        ),
        const CareerSectionTitle('Trước khi bắt đầu'),
        const CareerCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bullet('Chọn câu trả lời phù hợp nhất với hiểu biết hiện tại.'),
              _Bullet(
                'Có thể quay lại câu trước; đáp án đã chọn vẫn được giữ trong phiên.',
              ),
              _Bullet(
                'Điểm số không xác minh năng lực và không được gửi tới nhà tuyển dụng.',
              ),
            ],
          ),
        ),
        CheckboxListTile(
          value: accepted,
          onChanged: (value) => setState(() => accepted = value ?? false),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Tôi hiểu đây là bài tự đánh giá demo, không phải đánh giá AI hay chứng nhận.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 80),
      ],
    ),
  );
}

class SkillAssessmentQuestionScreen extends ConsumerWidget {
  const SkillAssessmentQuestionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerGuidanceProvider);
    final controller = ref.read(careerGuidanceProvider.notifier);
    if (!state.assessmentStarted) {
      return _AssessmentGuard(onStart: () => context.go('/career/assessment'));
    }
    final index = state.assessmentQuestionIndex
        .clamp(0, skillAssessmentQuestions.length - 1)
        .toInt();
    final question = skillAssessmentQuestions[index];
    final selected = state.assessmentAnswers[index];
    return CareerPage(
      useStudentShell: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CareerBackHeader(
            title: 'Câu ${index + 1}/${skillAssessmentQuestions.length}',
            trailing: Text(
              '${((index + 1) * 100 / skillAssessmentQuestions.length).round()}%',
            ),
          ),
          CareerProgressBar(
            value: (index + 1) / skillAssessmentQuestions.length,
          ),
          const SizedBox(height: 18),
          CareerDemoNote(text: question.topic),
          const SizedBox(height: 12),
          CareerCard(
            child: Text(
              question.prompt,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
          const CareerSectionTitle('Chọn một đáp án'),
          RadioGroup<int>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) {
                controller.answerAssessmentQuestion(index, value);
              }
            },
            child: Column(
              children: [
                for (
                  var optionIndex = 0;
                  optionIndex < question.options.length;
                  optionIndex++
                )
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Card(
                      child: RadioListTile<int>(
                        value: optionIndex,
                        title: Text(
                          question.options[optionIndex],
                          style: const TextStyle(fontSize: 13),
                        ),
                        dense: true,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (index > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        controller.setAssessmentQuestionIndex(index - 1),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Trước'),
                  ),
                ),
              if (index > 0) const SizedBox(width: 10),
              Expanded(
                child: CareerPrimaryButton(
                  label: index == skillAssessmentQuestions.length - 1
                      ? 'Xem kết quả'
                      : 'Tiếp theo',
                  onPressed: selected == null
                      ? null
                      : () {
                          if (index == skillAssessmentQuestions.length - 1) {
                            if (state.assessmentAnswers.length ==
                                skillAssessmentQuestions.length) {
                              context.push('/career/assessment/result');
                            }
                          } else {
                            controller.answerAssessmentQuestion(
                              index,
                              selected,
                            );
                            controller.setAssessmentQuestionIndex(index + 1);
                          }
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SkillAssessmentResultScreen extends ConsumerWidget {
  const SkillAssessmentResultScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(careerGuidanceProvider);
    final complete =
        state.assessmentStarted &&
        state.assessmentAnswers.length == skillAssessmentQuestions.length;
    if (!complete) {
      return _AssessmentGuard(onStart: () => context.go('/career/assessment'));
    }
    final score = skillAssessmentQuestions.indexed
        .where(
          (entry) => state.assessmentAnswers[entry.$1] == entry.$2.correctIndex,
        )
        .length;
    return CareerPage(
      useStudentShell: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Kết quả tự đánh giá'),
          CareerCard(
            color: AppColors.navy,
            child: Column(
              children: [
                const CareerDemoNote(text: 'Kết quả demo từ đáp án bạn chọn'),
                const SizedBox(height: 10),
                Text(
                  '$score/${skillAssessmentQuestions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Không phải chứng nhận năng lực',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Đáp án và giải thích'),
          for (var i = 0; i < skillAssessmentQuestions.length; i++) ...[
            CareerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${skillAssessmentQuestions[i].prompt}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bạn chọn: ${skillAssessmentQuestions[i].options[state.assessmentAnswers[i]!]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Đáp án trong bộ câu hỏi demo: ${skillAssessmentQuestions[i].options[skillAssessmentQuestions[i].correctIndex]}',
                    style: const TextStyle(fontSize: 12, color: AppColors.blue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    skillAssessmentQuestions[i].explanation,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          CareerPrimaryButton(
            label: 'Về tổng quan nghề nghiệp',
            onPressed: () => context.go('/career'),
          ),
        ],
      ),
    );
  }
}

class _AssessmentGuard extends StatelessWidget {
  const _AssessmentGuard({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => CareerPage(
    useStudentShell: false,
    child: Column(
      children: [
        const CareerBackHeader(title: 'Chưa có kết quả'),
        const CareerCard(
          child: Text('Hãy bắt đầu và hoàn thành các câu hỏi để xem kết quả.'),
        ),
        const SizedBox(height: 14),
        CareerPrimaryButton(label: 'Đến phần giới thiệu', onPressed: onStart),
      ],
    ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 17, color: AppColors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35)),
        ),
      ],
    ),
  );
}
