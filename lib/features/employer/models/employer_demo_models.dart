/// Local, in-memory draft only. This does not represent a verified company.
class EmployerDemoState {
  const EmployerDemoState({
    this.company = const <String, String>{},
    this.job = const <String, String>{},
    this.hasJobDraft = false,
    this.listings = const [],
    this.adminListings = const [],
    this.companyApplications = const [],
    this.shortlistedCandidateIds = const {},
    this.interviewInvites = const [],
    this.candidateMatchMinimum = 0,
    this.verifiedCandidatesOnly = false,
  });

  final Map<String, String> company;
  final Map<String, String> job;
  final bool hasJobDraft;
  final List<EmployerJobListing> listings;

  /// Figma-backed local review samples, kept separate from employer drafts.
  final List<EmployerJobListing> adminListings;
  final List<EmployerCompanyApplication> companyApplications;
  final Set<String> shortlistedCandidateIds;
  final List<EmployerInterviewInvite> interviewInvites;
  final int candidateMatchMinimum;
  final bool verifiedCandidatesOnly;

  EmployerDemoState copyWith({
    Map<String, String>? company,
    Map<String, String>? job,
    bool? hasJobDraft,
    List<EmployerJobListing>? listings,
    List<EmployerJobListing>? adminListings,
    List<EmployerCompanyApplication>? companyApplications,
    Set<String>? shortlistedCandidateIds,
    List<EmployerInterviewInvite>? interviewInvites,
    int? candidateMatchMinimum,
    bool? verifiedCandidatesOnly,
  }) => EmployerDemoState(
    company: company ?? this.company,
    job: job ?? this.job,
    hasJobDraft: hasJobDraft ?? this.hasJobDraft,
    listings: listings ?? this.listings,
    adminListings: adminListings ?? this.adminListings,
    companyApplications: companyApplications ?? this.companyApplications,
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
    this.moderationReason,
  });
  final String id;
  final Map<String, String> fields;
  final String status;
  final String? moderationReason;
}

/// A submitted company verification request in the local admin demo queue.
class EmployerCompanyApplication {
  const EmployerCompanyApplication({
    required this.id,
    required this.fields,
    this.status = 'Chờ duyệt',
    this.moderationReason,
  });

  final String id;
  final Map<String, String> fields;
  final String status;
  final String? moderationReason;

  EmployerCompanyApplication copyWith({
    String? status,
    String? moderationReason,
  }) => EmployerCompanyApplication(
    id: id,
    fields: fields,
    status: status ?? this.status,
    moderationReason: moderationReason ?? this.moderationReason,
  );
}

const adminDemoCompanyApplications = <EmployerCompanyApplication>[
  EmployerCompanyApplication(
    id: 'company-saoviet',
    fields: {
      'name': 'Công ty TNHH Công nghệ Sao Việt',
      'taxId': '0315892341',
      'industry': 'Công nghệ thông tin',
      'email': 'contact@saoviet.example',
      'submissionId': 'DN-2024-089',
      'submittedAt': '20/10/2026',
      'address': 'Quận 1, TP. Hồ Chí Minh',
      'priority': 'true',
      'new': 'true',
      'needsDocuments': 'false',
    },
  ),
  EmployerCompanyApplication(
    id: 'company-abc-digital',
    fields: {
      'name': 'ABC Digital Solutions JSC',
      'taxId': '0109283746',
      'industry': 'Dịch vụ số',
      'email': 'hr@abcdigital.example',
      'submissionId': 'DN-2024-090',
      'submittedAt': '21/10/2026',
      'address': 'Cầu Giấy, Hà Nội',
      'priority': 'false',
      'new': 'true',
      'needsDocuments': 'false',
    },
  ),
  EmployerCompanyApplication(
    id: 'company-fintech-edu',
    fields: {
      'name': 'Tập đoàn Giáo dục FinTech Việt Nam',
      'taxId': '0317654321',
      'industry': 'Giáo dục và công nghệ tài chính',
      'email': 'people@fintechedu.example',
      'submissionId': 'DN-2024-091',
      'submittedAt': '22/10/2026',
      'address': 'Thủ Đức, TP. Hồ Chí Minh',
      'priority': 'false',
      'new': 'false',
      'needsDocuments': 'true',
    },
  ),
];

const adminDemoJobListings = <EmployerJobListing>[
  EmployerJobListing(
    id: 'admin-job-backend-intern',
    fields: {
      'title': 'Backend Intern (Node.js / Go)',
      'company': 'Công ty TNHH Công nghệ Sao Việt',
      'location': 'TP. Hồ Chí Minh',
      'salary': '8–12 triệu VNĐ',
      'experience': 'Sinh viên / chưa có kinh nghiệm',
      'department': 'Engineering',
      'description': 'Tham gia phát triển dịch vụ backend và API nội bộ.',
      'skills': 'Node.js, Go, PostgreSQL',
      'benefits': 'Đào tạo có hướng dẫn, hỗ trợ thực tập',
    },
  ),
  EmployerJobListing(
    id: 'admin-job-uiux-junior',
    fields: {
      'title': 'Junior UI/UX Designer',
      'company': 'ABC Digital Solutions JSC',
      'location': 'Hà Nội',
      'salary': '10–15 triệu VNĐ',
      'experience': 'Dưới 1 năm',
      'department': 'Design',
      'description': 'Thiết kế và cải thiện trải nghiệm cho sản phẩm số.',
      'skills': 'Figma, UX Research, Prototyping',
      'benefits': 'Môi trường cộng tác, ngân sách học tập',
    },
  ),
  EmployerJobListing(
    id: 'admin-job-data-analyst',
    fields: {
      'title': 'Data Analyst Intern',
      'company': 'Tập đoàn Giáo dục FinTech Việt Nam',
      'location': 'TP. Hồ Chí Minh',
      'salary': '6–9 triệu VNĐ',
      'experience': 'Không yêu cầu',
      'department': 'Data',
      'description': 'Hỗ trợ tổng hợp dữ liệu và báo cáo vận hành.',
      'skills': 'SQL, Excel, Data Visualization',
      'benefits': 'Được hướng dẫn và xác nhận thực tập',
    },
  ),
];

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
