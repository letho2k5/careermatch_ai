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

const skillAssessmentQuestions = <AssessmentQuestion>[
  AssessmentQuestion(
    id: 'dockerfile-from',
    topic: 'Dockerfile & Multi-stage build',
    prompt: 'Trong Dockerfile, FROM thường được dùng để làm gì?',
    options: [
      'Chọn image nền cho một stage build',
      'Mở cổng mạng cho container',
      'Tạo volume lưu dữ liệu',
      'Khởi động container ngay lập tức',
    ],
    correctIndex: 0,
    explanation: 'FROM khai báo image nền và có thể mở đầu một build stage.',
  ),
  AssessmentQuestion(
    id: 'image-container',
    topic: 'Docker cơ bản',
    prompt: 'Mối quan hệ nào mô tả đúng giữa image và container?',
    options: [
      'Container là một instance đang chạy từ image',
      'Image luôn chứa trạng thái runtime đang chạy',
      'Container là một loại network của Docker',
      'Hai khái niệm này hoàn toàn giống nhau',
    ],
    correctIndex: 0,
    explanation:
        'Image là mẫu bất biến; container là instance được tạo từ image.',
  ),
  AssessmentQuestion(
    id: 'docker-volume',
    topic: 'Docker storage',
    prompt: 'Khi cần giữ dữ liệu PostgreSQL qua lần tạo lại container, nên dùng gì?',
    options: [
      'Docker volume',
      'Build argument',
      'Container label',
      'Port mapping',
    ],
    correctIndex: 0,
    explanation: 'Volume tách dữ liệu khỏi vòng đời của container.',
  ),
  AssessmentQuestion(
    id: 'multi-stage-copy',
    topic: 'Dockerfile & Multi-stage build',
    prompt:
        'Trong multi-stage build, COPY --from=builder thường dùng để làm gì?',
    options: [
      'Chép artifact cần thiết giữa các stage',
      'Sao chép toàn bộ host vào image runtime',
      'Tải image từ registry',
      'Gắn volume vào container',
    ],
    correctIndex: 0,
    explanation: 'COPY --from lấy file từ một stage trước sang stage hiện tại.',
  ),
  AssessmentQuestion(
    id: 'compose-service',
    topic: 'Docker Compose',
    prompt:
        'Docker Compose giúp mô tả điều gì trong một ứng dụng nhiều dịch vụ?',
    options: [
      'Các service, cấu hình và quan hệ chạy cùng nhau',
      'Chỉ mã nguồn của một service',
      'Chứng chỉ TLS cho mọi môi trường',
      'Lịch sử câu lệnh shell của developer',
    ],
    correctIndex: 0,
    explanation:
        'Compose khai báo các service và cấu hình liên quan trong một file.',
  ),
  AssessmentQuestion(
    id: 'postgres-index',
    topic: 'PostgreSQL',
    prompt: 'Index thường hữu ích nhất trong trường hợp nào?',
    options: [
      'Tăng tốc truy vấn lọc theo cột phù hợp, đổi lại tốn dung lượng ghi',
      'Thay thế hoàn toàn khóa ngoại',
      'Mã hóa mọi giá trị trong bảng',
      'Tự sửa dữ liệu trùng lặp',
    ],
    correctIndex: 0,
    explanation: 'Index có thể giúp truy vấn phù hợp nhanh hơn nhưng tốn dung lượng và chi phí cập nhật.',
  ),
  AssessmentQuestion(
    id: 'secret-config',
    topic: 'Cấu hình ứng dụng',
    prompt: 'Thông tin bí mật như mật khẩu database nên được quản lý thế nào?',
    options: [
      'Đưa vào cơ chế quản lý secret phù hợp, không commit vào source',
      'Ghi trực tiếp vào Dockerfile',
      'Đặt trong log để dễ kiểm tra',
      'Đặt tên biến thật khó đoán trong repository',
    ],
    correctIndex: 0,
    explanation: 'Secret không nên được commit hoặc ghi ra log; môi trường thật cần cơ chế quản lý riêng.',
  ),
  AssessmentQuestion(
    id: 'healthcheck',
    topic: 'Vận hành container',
    prompt: 'Health check thường dùng để theo dõi điều gì?',
    options: [
      'Ứng dụng có sẵn sàng phản hồi kiểm tra hay không',
      'Container đã được ký bởi nhà cung cấp chưa',
      'Image có bao nhiêu layer',
      'Máy có bao nhiêu tài khoản người dùng',
    ],
    correctIndex: 0,
    explanation:
        'Health check báo trạng thái sức khỏe theo tiêu chí probe đã cấu hình.',
  ),
  AssessmentQuestion(
    id: 'ci-test',
    topic: 'CI/CD',
    prompt: 'Một pipeline CI cơ bản nên chạy bước nào trước khi tạo artifact phát hành?',
    options: [
      'Kiểm tra chất lượng và chạy test tự động',
      'Xóa toàn bộ lịch sử Git',
      'Tắt kiểm tra lỗi để build nhanh hơn',
      'Đưa secret vào artifact',
    ],
    correctIndex: 0,
    explanation: 'CI thường tự động kiểm tra định dạng, phân tích và chạy test trước các bước tiếp theo.',
  ),
  AssessmentQuestion(
    id: 'pytest-assert',
    topic: 'Unit Test với PyTest',
    prompt: 'Trong một unit test, assert chủ yếu dùng để làm gì?',
    options: [
      'So sánh kết quả thực tế với điều kiện mong đợi',
      'Khởi chạy server production',
      'Tạo dữ liệu cho mọi test khác',
      'Tự động sửa lỗi trong hàm được kiểm thử',
    ],
    correctIndex: 0,
    explanation:
        'Assert làm test thất bại khi điều kiện mong đợi không được đáp ứng.',
  ),
];

List<CareerMilestone> milestonesForGoal(CareerGoal goal, CareerDraft draft) {
  final gaps = goal.skills
      .where((skill) => !draftHasSkill(draft, skill))
      .toList();
  final targets = gaps.isEmpty ? goal.skills.take(2).toList() : gaps;
  if (targets.isEmpty) return const [];
  final groups = <List<String>>[];
  for (var index = 0; index < targets.length; index += 2) {
    groups.add(targets.skip(index).take(2).toList());
  }
  return [
    for (var groupIndex = 0; groupIndex < groups.length; groupIndex++)
      _milestone(goal, groups[groupIndex], groupIndex),
  ];
}

CareerMilestone _milestone(CareerGoal goal, List<String> skills, int index) {
  final hasDocker = skills.any(
    (skill) => skill.toLowerCase().contains('docker'),
  );
  final hasCicd = skills.any((skill) => skill.toLowerCase().contains('ci/cd'));
  final hasTest = skills.any((skill) => skill.toLowerCase().contains('test'));
  final title = hasDocker && hasCicd
      ? 'Container hóa & DevOps'
      : hasTest
      ? 'Kiểm thử & chất lượng'
      : index == 0
      ? 'Nền tảng ${skills.first}'
      : 'Thực hành ${skills.first}';
  final milestoneId = '${goal.id}-${skills.map(careerSkillId).join('-')}';
  final taskTitles = hasDocker && hasCicd
      ? const [
          'Cài đặt Docker và kiến trúc container',
          'Viết Dockerfile cho ứng dụng mẫu',
          'Tạo Dockerfile multi-stage',
          'Chạy nhiều dịch vụ với Compose',
          'Kiểm tra pipeline build và test',
        ]
      : hasTest
      ? const [
          'Ôn tập cấu trúc unit test',
          'Viết test case với PyTest',
          'Mock dependency trong test',
        ]
      : [
          'Ôn tập khái niệm ${skills.first}',
          'Thực hành bài tập có hướng dẫn',
          'Áp dụng vào dự án cá nhân',
        ];
  return CareerMilestone(
    id: milestoneId,
    title: title,
    description:
        'Các hoạt động gợi ý cho ${goal.title}. Chưa có nội dung học trực tuyến được kết nối.',
    skills: skills,
    tasks: [
      for (var taskIndex = 0; taskIndex < taskTitles.length; taskIndex++)
        CareerMilestoneTask(
          id: 'task-${taskIndex + 1}',
          title: taskTitles[taskIndex],
          description: taskIndex == 0
              ? 'Đọc nội dung và ghi lại các khái niệm liên quan.'
              : 'Thực hành cục bộ rồi tự kiểm tra kết quả.',
          duration: taskIndex == 0 ? '30 phút' : '45 phút',
        ),
    ],
  );
}

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
