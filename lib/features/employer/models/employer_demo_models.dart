/// Local, in-memory draft only. This does not represent a verified company.
class EmployerDemoState {
  const EmployerDemoState({
    this.company = const <String, String>{},
    this.job = const <String, String>{},
    this.hasJobDraft = false,
  });

  final Map<String, String> company;
  final Map<String, String> job;
  final bool hasJobDraft;

  EmployerDemoState copyWith({
    Map<String, String>? company,
    Map<String, String>? job,
    bool? hasJobDraft,
  }) => EmployerDemoState(
    company: company ?? this.company,
    job: job ?? this.job,
    hasJobDraft: hasJobDraft ?? this.hasJobDraft,
  );
}
