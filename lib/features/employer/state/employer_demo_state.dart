import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employer_demo_models.dart';

class EmployerDemoController extends Notifier<EmployerDemoState> {
  @override
  EmployerDemoState build() => const EmployerDemoState();

  void setCompanyField(String key, String value) {
    state = state.copyWith(company: {...state.company, key: value});
  }

  void setJobField(String key, String value) {
    state = state.copyWith(job: {...state.job, key: value}, hasJobDraft: true);
  }
}

final employerDemoProvider =
    NotifierProvider<EmployerDemoController, EmployerDemoState>(
      EmployerDemoController.new,
    );
