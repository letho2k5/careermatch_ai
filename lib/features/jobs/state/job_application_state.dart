import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../student_profile/student_draft.dart';
import '../models/job_application.dart';

class JobApplicationState {
  const JobApplicationState({
    this.draft = const ApplicationDraft(),
    this.applications = const [],
  });

  final ApplicationDraft draft;
  final List<JobApplication> applications;

  JobApplicationState copyWith({
    ApplicationDraft? draft,
    List<JobApplication>? applications,
  }) => JobApplicationState(
    draft: draft ?? this.draft,
    applications: applications ?? this.applications,
  );
}

class JobApplicationController extends Notifier<JobApplicationState> {
  @override
  JobApplicationState build() => const JobApplicationState();

  void begin(String jobId, CareerDraft student) {
    final current = state.draft;
    if (current.jobId == jobId && current.submittedApplicationId == null) {
      return;
    }
    state = state.copyWith(
      draft: ApplicationDraft(
        jobId: jobId,
        fullName: student.fullName,
        phone: student.phone,
        university: student.university,
        major: student.major,
        availability: student.startAvailability,
      ),
    );
  }

  void updateDraft(ApplicationDraft draft) =>
      state = state.copyWith(draft: draft);

  void selectCv(String name, int bytes) => state = state.copyWith(
    draft: state.draft.copyWith(
      selectedCvName: name.trim(),
      selectedCvBytes: bytes,
    ),
  );

  void clearSelectedCv() => state = state.copyWith(
    draft: state.draft.copyWith(clearSelectedCv: true),
  );

  JobApplication? find(String id) {
    for (final application in state.applications) {
      if (application.id == id) return application;
    }
    return null;
  }

  String? submit() {
    final draft = state.draft;
    if (!draft.hasRequiredDetails || !draft.hasSelectedCv) return null;

    final id = 'CM-DEMO-${DateTime.now().microsecondsSinceEpoch}';
    final application = JobApplication(
      id: id,
      jobId: draft.jobId,
      fullName: draft.fullName.trim(),
      email: draft.email.trim(),
      phone: draft.phone.trim(),
      university: draft.university.trim(),
      major: draft.major.trim(),
      availability: draft.availability.trim(),
      cvName: draft.selectedCvName.trim(),
      cvBytes: draft.selectedCvBytes!,
      coverLetter: draft.coverLetter.trim(),
      submittedAt: DateTime.now(),
    );
    state = state.copyWith(
      draft: draft.copyWith(submittedApplicationId: id),
      applications: [application, ...state.applications],
    );
    return id;
  }

  void remove(String id) => state = state.copyWith(
    applications: state.applications.where((item) => item.id != id).toList(),
  );
}

final jobApplicationProvider =
    NotifierProvider<JobApplicationController, JobApplicationState>(
      JobApplicationController.new,
    );
