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

  EmployerJobListing? listing(String id) {
    for (final item in state.listings) {
      if (item.id == id) return item;
    }
    return null;
  }

  String? submitDraft() {
    final title = (state.job['title'] ?? '').trim();
    if (!state.hasJobDraft ||
        title.isEmpty ||
        (state.job['department'] ?? '').trim().isEmpty) {
      return null;
    }
    final id = 'em-${DateTime.now().microsecondsSinceEpoch}';
    state = state.copyWith(
      listings: [
        ...state.listings,
        EmployerJobListing(id: id, fields: Map.unmodifiable(state.job)),
      ],
      hasJobDraft: false,
    );
    return id;
  }

  void updateListing(String id, Map<String, String> fields) {
    state = state.copyWith(
      listings: [
        for (final item in state.listings)
          if (item.id == id)
            EmployerJobListing(
              id: item.id,
              fields: Map.unmodifiable(fields),
              status: item.status,
            )
          else
            item,
      ],
    );
  }

  void toggleShortlist(String candidateId) {
    final ids = {...state.shortlistedCandidateIds};
    if (!ids.add(candidateId)) ids.remove(candidateId);
    state = state.copyWith(shortlistedCandidateIds: ids);
  }

  void addInterviewInvite(EmployerInterviewInvite invite) {
    if (state.interviewInvites.any(
      (item) =>
          item.candidateId == invite.candidateId &&
          item.jobId == invite.jobId &&
          item.date == invite.date &&
          item.time == invite.time,
    )) {
      return;
    }
    state = state.copyWith(
      interviewInvites: [...state.interviewInvites, invite],
    );
  }

  void setCandidateFilters({int? minimumMatch, bool? verifiedOnly}) {
    state = state.copyWith(
      candidateMatchMinimum: minimumMatch,
      verifiedCandidatesOnly: verifiedOnly,
    );
  }

  void clearCandidateFilters() {
    state = state.copyWith(
      candidateMatchMinimum: 0,
      verifiedCandidatesOnly: false,
    );
  }
}

final employerDemoProvider =
    NotifierProvider<EmployerDemoController, EmployerDemoState>(
      EmployerDemoController.new,
    );
