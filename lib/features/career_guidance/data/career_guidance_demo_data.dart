import '../models/career_guidance_models.dart';
import '../../student_profile/student_draft.dart';

const careerGoals = <CareerGoal>[
  CareerGoal(
    id: 'backend-developer',
    title: 'Backend Developer',
    subtitle: 'Cấp bậc: Intern / Fresher',
    skills: [
      'Python',
      'PostgreSQL',
      'Docker & Containerization',
      'CI/CD Pipeline',
      'Unit Test với PyTest / Mocking',
    ],
    description: 'Xây dựng API và dịch vụ phía máy chủ, làm việc với cơ sở dữ liệu và quy trình triển khai.',
    matchPercent: 82,
  ),
  CareerGoal(
    id: 'data-analyst',
    title: 'Data Analyst',
    subtitle: 'Cấp bậc: Intern / Fresher',
    skills: ['Python', 'SQL', 'Data Visualization', 'Statistics', 'Power BI'],
    description: 'Phân tích dữ liệu, xây dựng báo cáo và chuyển dữ liệu thành thông tin hỗ trợ quyết định.',
    matchPercent: 71,
  ),
  CareerGoal(
    id: 'cloud-engineer',
    title: 'Cloud Engineer',
    subtitle: 'Cấp bậc: Intern / Fresher',
    skills: [
      'Linux',
      'Docker & Containerization',
      'AWS',
      'Networking',
      'CI/CD Pipeline',
    ],
    description: 'Vận hành hạ tầng cloud, tự động hóa triển khai và theo dõi độ tin cậy của hệ thống.',
    matchPercent: 58,
  ),
];

const learningResources = <LearningResource>[
  LearningResource(
    id: 'docker-101',
    title: 'Docker 101 cho sinh viên CNTT',
    provider: 'FPT Software Academy',
    skill: 'Docker & Containerization',
    description: 'Tìm hiểu container, Dockerfile và cách đóng gói một ứng dụng backend nhỏ.',
    duration: '2.5 giờ',
    format: '4 module · Video và thực hành',
  ),
  LearningResource(
    id: 'pytest-mocking',
    title: 'Thực chiến PyTest & Mocking',
    provider: 'Vietnam Open Source Lab',
    skill: 'Unit Test với PyTest / Mocking',
    description:
        'Viết unit test, mock dependency và kiểm tra API trong dự án Python.',
    duration: '3 giờ',
    format: '3 module · Bài lab',
  ),
  LearningResource(
    id: 'cicd-github-actions',
    title: 'CI/CD căn bản với GitHub Actions',
    provider: 'F-Code & GDSC HCMC',
    skill: 'CI/CD Pipeline',
    description:
        'Tạo workflow kiểm thử và triển khai tự động cho một ứng dụng mẫu.',
    duration: '4 giờ',
    format: '4 module · Thực hành',
  ),
  LearningResource(
    id: 'postgresql-query',
    title: 'PostgreSQL Query Optimization',
    provider: 'Khoa CNTT · ĐH Bách Khoa',
    skill: 'PostgreSQL',
    description:
        'Ôn tập truy vấn, index và các nguyên tắc tối ưu cơ sở dữ liệu.',
    duration: '5 giờ',
    format: '5 module · Tài liệu học',
  ),
  LearningResource(
    id: 'python-api',
    title: 'Xây dựng REST API với Python',
    provider: 'CareerMatch Learning · Demo',
    skill: 'Python',
    description:
        'Tài liệu minh họa cấu trúc API, xử lý request và kiểm thử cơ bản.',
    duration: '3 giờ',
    format: '3 module · Nội dung demo',
  ),
];

const missingSkillSteps = <String, List<String>>{
  'docker-containerization': [
    'Khám phá Docker 101',
    'Tạo Dockerfile cho ứng dụng Python',
    'Chạy ứng dụng và kiểm tra container',
  ],
  'cicd-pipeline': [
    'Tìm hiểu workflow CI/CD',
    'Tự động chạy test bằng GitHub Actions',
    'Thực hành pipeline trên repository demo',
  ],
  'pytest-mocking': [
    'Ôn tập unit test với PyTest',
    'Mock dependency và dữ liệu đầu vào',
    'Viết test cho một REST API mẫu',
  ],
};

String careerSkillId(String value) {
  if (value.toLowerCase().contains('docker')) return 'docker-containerization';
  if (value.toLowerCase().contains('ci/cd')) return 'cicd-pipeline';
  if (value.toLowerCase().contains('pytest')) return 'pytest-mocking';
  return value
      .toLowerCase()
      .replaceAll('&', 'and')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+$'), '');
}

bool draftHasSkill(CareerDraft draft, String requiredSkill) {
  final needle = _normalize(requiredSkill);
  final allSkills = <String>{
    ...draft.hardSkills.keys,
    ...draft.extractedSkills.keys,
    ...draft.softSkills,
    for (final experience in draft.experiences) ...experience.skills,
  };
  return allSkills.any((skill) {
    final candidate = _normalize(skill);
    return candidate == needle ||
        (needle.length > 4 && candidate.contains(needle)) ||
        (candidate.length > 4 && needle.contains(candidate));
  });
}

List<CareerSkill> skillsFromDraft(CareerDraft draft) {
  final skills = <String, CareerSkill>{};
  for (final entry in draft.extractedSkills.entries) {
    skills[_normalize(entry.key)] = CareerSkill(
      name: entry.key,
      level: entry.value,
      source: SkillSource.cvDemo,
    );
  }
  for (final entry in draft.hardSkills.entries) {
    skills[_normalize(entry.key)] = CareerSkill(
      name: entry.key,
      level: entry.value,
      source: SkillSource.profile,
    );
  }
  for (final entry in draft.softSkills) {
    skills.putIfAbsent(
      _normalize(entry),
      () => CareerSkill(
        name: entry,
        level: 'Chưa tự đánh giá',
        source: SkillSource.profile,
      ),
    );
  }
  return skills.values.toList();
}

String _normalize(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9+#]'), '');
