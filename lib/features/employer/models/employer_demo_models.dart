/// Local, in-memory draft only. This does not represent a verified company.
class EmployerDemoState {
  const EmployerDemoState({
    this.company = const <String, String>{},
    this.job = const <String, String>{},
    this.hasJobDraft = false,
    this.listings = const [],
    this.shortlistedCandidateIds = const {},
    this.interviewInvites = const [],
    this.candidateMatchMinimum = 0,
    this.verifiedCandidatesOnly = false,
  });

  final Map<String, String> company;
  final Map<String, String> job;
  final bool hasJobDraft;
  final List<EmployerJobListing> listings;
  final Set<String> shortlistedCandidateIds;
  final List<EmployerInterviewInvite> interviewInvites;
  final int candidateMatchMinimum;
  final bool verifiedCandidatesOnly;

  EmployerDemoState copyWith({
    Map<String, String>? company,
    Map<String, String>? job,
    bool? hasJobDraft,
    List<EmployerJobListing>? listings,
    Set<String>? shortlistedCandidateIds,
    List<EmployerInterviewInvite>? interviewInvites,
    int? candidateMatchMinimum,
    bool? verifiedCandidatesOnly,
  }) => EmployerDemoState(
    company: company ?? this.company,
    job: job ?? this.job,
    hasJobDraft: hasJobDraft ?? this.hasJobDraft,
    listings: listings ?? this.listings,
    shortlistedCandidateIds:
        shortlistedCandidateIds ?? this.shortlistedCandidateIds,
    interviewInvites: interviewInvites ?? this.interviewInvites,
    candidateMatchMinimum: candidateMatchMinimum ?? this.candidateMatchMinimum,
    verifiedCandidatesOnly:
        verifiedCandidatesOnly ?? this.verifiedCandidatesOnly,
  );
}

class EmployerJobListing {
  const EmployerJobListing({
    required this.id,
    required this.fields,
    this.status = 'Chờ duyệt',
  });
  final String id;
  final Map<String, String> fields;
  final String status;
}

class EmployerInterviewInvite {
  const EmployerInterviewInvite({
    required this.id,
    required this.candidateId,
    required this.candidateName,
    required this.jobId,
    required this.jobTitle,
    required this.date,
    required this.time,
    this.status = 'Đã lên lịch (demo)',
  });
  final String id;
  final String candidateId;
  final String candidateName;
  final String jobId;
  final String jobTitle;
  final DateTime date;
  final String time;
  final String status;
}

class EmployerCandidate {
  const EmployerCandidate({
    required this.id,
    required this.name,
    required this.school,
    required this.skills,
    required this.gpa,
    required this.match,
    required this.experience,
  });
  final String id;
  final String name;
  final String school;
  final List<String> skills;
  final String gpa;
  final int match;
  final String experience;
}

const employerDemoCandidates = <EmployerCandidate>[
  EmployerCandidate(
    id: 'candidate-an',
    name: 'Nguyễn Văn An',
    school: 'ĐH Bách Khoa TP.HCM',
    skills: ['Python', 'FastAPI', 'PostgreSQL', 'Docker'],
    gpa: '3.65',
    match: 96,
    experience: '3 dự án thực tế & đồ án mã nguồn mở',
  ),
  EmployerCandidate(
    id: 'candidate-bich',
    name: 'Trần Thị Bích',
    school: 'ĐH Công Nghệ - ĐHQGHN',
    skills: ['CI/CD', 'FastAPI', 'PyTest', 'Git'],
    gpa: '3.72',
    match: 92,
    experience: 'Thành viên CLB lập trình',
  ),
  EmployerCandidate(
    id: 'candidate-bao',
    name: 'Phạm Quốc Bảo',
    school: 'ĐH CNTT TP.HCM',
    skills: ['Docker', 'Linux', 'PostgreSQL'],
    gpa: '3.48',
    match: 89,
    experience: 'Dự án bảo mật và triển khai cloud',
  ),
];
