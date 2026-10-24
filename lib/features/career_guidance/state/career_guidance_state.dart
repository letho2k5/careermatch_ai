import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';

class CareerGuidanceState {
  const CareerGuidanceState({
    this.selectedGoalId = 'backend-developer',
    this.completedResourceIds = const {},
  });

  final String selectedGoalId;
  final Set<String> completedResourceIds;

  CareerGuidanceState copyWith({
    String? selectedGoalId,
    Set<String>? completedResourceIds,
  }) => CareerGuidanceState(
    selectedGoalId: selectedGoalId ?? this.selectedGoalId,
    completedResourceIds: completedResourceIds ?? this.completedResourceIds,
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
