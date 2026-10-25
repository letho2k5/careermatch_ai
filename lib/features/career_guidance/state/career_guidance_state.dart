import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';

class CareerGuidanceState {
  const CareerGuidanceState({
    this.selectedGoalId = 'backend-developer',
    this.completedResourceIds = const {},
    this.milestoneTaskDoneIds = const {},
    this.assessmentAnswers = const {},
    this.assessmentQuestionIndex = 0,
    this.assessmentStarted = false,
    this.interviewAnswer = '',
  });

  final String selectedGoalId;
  final Set<String> completedResourceIds;
  final Set<String> milestoneTaskDoneIds;
  final Map<int, int> assessmentAnswers;
  final int assessmentQuestionIndex;
  final bool assessmentStarted;
  final String interviewAnswer;

  CareerGuidanceState copyWith({
    String? selectedGoalId,
    Set<String>? completedResourceIds,
    Set<String>? milestoneTaskDoneIds,
    Map<int, int>? assessmentAnswers,
    int? assessmentQuestionIndex,
    bool? assessmentStarted,
    String? interviewAnswer,
  }) => CareerGuidanceState(
    selectedGoalId: selectedGoalId ?? this.selectedGoalId,
    completedResourceIds: completedResourceIds ?? this.completedResourceIds,
    milestoneTaskDoneIds: milestoneTaskDoneIds ?? this.milestoneTaskDoneIds,
    assessmentAnswers: assessmentAnswers ?? this.assessmentAnswers,
    assessmentQuestionIndex:
        assessmentQuestionIndex ?? this.assessmentQuestionIndex,
    assessmentStarted: assessmentStarted ?? this.assessmentStarted,
    interviewAnswer: interviewAnswer ?? this.interviewAnswer,
  );
}

class CareerGuidanceController extends Notifier<CareerGuidanceState> {
  @override
  CareerGuidanceState build() => const CareerGuidanceState();

  void selectGoal(String id) {
    if (careerGoals.any((goal) => goal.id == id)) {
      state = state.copyWith(selectedGoalId: id);
    }
  }

  void toggleResourceCompleted(String id) {
    final updated = {...state.completedResourceIds};
    if (!updated.add(id)) updated.remove(id);
    state = state.copyWith(completedResourceIds: updated);
  }

  void toggleMilestoneTask(String milestoneId, String taskId) {
    final updated = {...state.milestoneTaskDoneIds};
    final key = '$milestoneId:$taskId';
    if (!updated.add(key)) updated.remove(key);
    state = state.copyWith(milestoneTaskDoneIds: updated);
  }

  void startAssessment() => state = state.copyWith(
    assessmentAnswers: const {},
    assessmentQuestionIndex: 0,
    assessmentStarted: true,
  );

  void answerAssessmentQuestion(int questionIndex, int optionIndex) {
    final updated = {...state.assessmentAnswers, questionIndex: optionIndex};
    state = state.copyWith(assessmentAnswers: updated);
  }

  void setAssessmentQuestionIndex(int index) {
    state = state.copyWith(
      assessmentQuestionIndex: index
          .clamp(0, skillAssessmentQuestions.length - 1)
          .toInt(),
    );
  }

  void updateInterviewAnswer(String answer) =>
      state = state.copyWith(interviewAnswer: answer);
}

final careerGuidanceProvider =
    NotifierProvider<CareerGuidanceController, CareerGuidanceState>(
      CareerGuidanceController.new,
    );

CareerGoal? selectedCareerGoal(CareerGuidanceState state) {
  for (final goal in careerGoals) {
    if (goal.id == state.selectedGoalId) return goal;
  }
  return null;
}
