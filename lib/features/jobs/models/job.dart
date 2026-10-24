class Job {
  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.companyId,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.matchScore,
    required this.workMode,
    required this.type,
    required this.description,
    required this.skills,
    required this.requirements,
    required this.benefits,
    required this.postedHoursAgo,
    required this.daysUntilDeadline,
    this.searchKeywords = const [],
    this.sdg8 = true,
    this.isUrgent = false,
  });

  final String id;
  final String title;
  final String company;
  final String companyId;
  final String location;
  final int salaryMin;
  final int salaryMax;
  final int matchScore;
  final String workMode;
  final String type;
  final String description;
  final List<String> skills;
  final List<String> requirements;
  final List<String> benefits;
  final int postedHoursAgo;
  final int daysUntilDeadline;
  final List<String> searchKeywords;
  final bool sdg8;
  final bool isUrgent;

  String get salaryLabel =>
      '${_millions(salaryMin)} - ${_millions(salaryMax)} triệu/tháng';

  static String _millions(int amount) =>
      (amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 1);
}

/// Illustrative data copied from the CareerMatch AI Figma frames.
/// These records are local demo content, not live vacancies.
const demoJobs = <Job>[
  Job(
    id: 'fpt-backend',
    title: 'Thực tập sinh Lập trình Backend',
    company: 'FPT Software',
    companyId: 'fpt-software',
    location: 'TP. Thủ Đức, TP.HCM',
    salaryMin: 6000000,
    salaryMax: 8000000,
    matchScore: 96,
    workMode: 'Hybrid',
    type: 'Thực tập',
    description: 'Tham gia phát triển dịch vụ backend, tối ưu truy vấn dữ liệu và làm việc cùng đội ngũ kỹ sư giàu kinh nghiệm.',
    skills: ['Python', 'PostgreSQL', 'Git', 'RESTful API'],
    requirements: [
      'Sinh viên năm cuối ngành Công nghệ thông tin hoặc tương đương.',
      'Nắm vững Python và cấu trúc dữ liệu cơ bản.',
      'Có thể tham gia thực tập linh hoạt theo lịch học.',
    ],
    benefits: [
      'Mentor hướng dẫn 1:1.',
      'Trợ cấp thực tập minh bạch.',
      'Cơ hội tham gia dự án thực tế.',
    ],
    postedHoursAgo: 4,
    daysUntilDeadline: 12,
    searchKeywords: ['Backend Developer Intern', 'Backend Intern'],
    isUrgent: true,
  ),
  Job(
    id: 'vng-golang',
    title: 'Golang Junior Developer',
    company: 'VNG Corporation',
    companyId: 'vng',
    location: 'Quận 7, TP.HCM',
    salaryMin: 8500000,
    salaryMax: 12000000,
    matchScore: 92,
    workMode: 'On-site',
    type: 'Fresher',
    description: 'Phát triển dịch vụ có khả năng mở rộng, phối hợp cùng nhóm sản phẩm và học hỏi quy trình phát hành phần mềm.',
    skills: ['Golang', 'PostgreSQL', 'Docker', 'Git'],
    requirements: [
      'Tốt nghiệp hoặc sắp tốt nghiệp ngành phù hợp.',
      'Có kiến thức nền tảng về lập trình hướng đối tượng.',
      'Sẵn sàng làm việc theo nhóm đa chức năng.',
    ],
    benefits: [
      'Chương trình đào tạo fresher.',
      'Bảo hiểm theo chính sách công ty.',
    ],
    postedHoursAgo: 18,
    daysUntilDeadline: 18,
  ),
  Job(
    id: 'momo-python',
    title: 'Python Backend Intern',
    company: 'MoMo (M_Service)',
    companyId: 'momo',
    location: 'Phú Nhuận, TP.HCM',
    salaryMin: 6000000,
    salaryMax: 8000000,
    matchScore: 90,
    workMode: 'Hybrid',
    type: 'Thực tập',
    description:
        'Hỗ trợ xây dựng API và công cụ nội bộ cho nền tảng thanh toán số.',
    skills: ['Python', 'FastAPI', 'PostgreSQL', 'Docker'],
    requirements: [
      'Đang học ngành liên quan.',
      'Biết sử dụng Git và SQL cơ bản.',
    ],
    benefits: ['Lịch làm linh hoạt.', 'Được hướng dẫn bởi kỹ sư trong nhóm.'],
    postedHoursAgo: 30,
    daysUntilDeadline: 20,
  ),
  Job(
    id: 'axon-backend',
    title: 'Junior Backend Developer',
    company: 'Axon Vietnam',
    companyId: 'axon',
    location: 'Quận 7, TP.HCM',
    salaryMin: 8000000,
    salaryMax: 12000000,
    matchScore: 95,
    workMode: 'Hybrid',
    type: 'Fresher',
    description: 'Phát triển dịch vụ backend với Python và FastAPI trong một nhóm sản phẩm quốc tế.',
    skills: ['Python', 'FastAPI', 'PostgreSQL', 'Redis'],
    requirements: ['Có kiến thức API và cơ sở dữ liệu quan hệ.'],
    benefits: ['Mentor 1:1.', 'Hỗ trợ bữa trưa và đào tạo.'],
    postedHoursAgo: 10,
    daysUntilDeadline: 8,
    isUrgent: true,
  ),
  Job(
    id: 'tiki-node',
    title: 'NodeJS Backend Intern',
    company: 'Tiki Corporation',
    companyId: 'tiki',
    location: 'Quận 1, TP.HCM',
    salaryMin: 6000000,
    salaryMax: 8000000,
    matchScore: 89,
    workMode: 'On-site',
    type: 'Thực tập',
    description: 'Hỗ trợ xây dựng các dịch vụ thương mại điện tử với Node.js và Express.',
    skills: ['Node.js', 'Express', 'Redis', 'Git'],
    requirements: ['Sinh viên năm cuối hoặc mới tốt nghiệp.'],
    benefits: ['Trợ cấp ăn trưa.', 'Hỗ trợ dấu mộc thực tập.'],
    postedHoursAgo: 22,
    daysUntilDeadline: 16,
  ),
  Job(
    id: 'viettel-data',
    title: 'Data Engineer Intern',
    company: 'Viettel Solutions',
    companyId: 'viettel',
    location: 'Quận 10, TP.HCM',
    salaryMin: 8000000,
    salaryMax: 10000000,
    matchScore: 91,
    workMode: 'Hybrid',
    type: 'Thực tập',
    description: 'Tham gia xây dựng pipeline dữ liệu và thực hành với các nền tảng cloud.',
    skills: ['Python', 'SQL', 'Docker', 'AWS'],
    requirements: ['Có nền tảng cơ sở dữ liệu và xử lý dữ liệu.'],
    benefits: ['Linh hoạt 3 buổi mỗi tuần.', 'Hỗ trợ đào tạo chứng chỉ cloud.'],
    postedHoursAgo: 8,
    daysUntilDeadline: 10,
  ),
];
