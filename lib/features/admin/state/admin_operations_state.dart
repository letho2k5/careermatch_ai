import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUserRecord {
  const AdminUserRecord({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.status,
    required this.lastActive,
    this.school,
    this.phone,
    this.warning = false,
  });

  final String id;
  final String name;
  final String role;
  final String email;
  final String status;
  final String lastActive;
  final String? school;
  final String? phone;
  final bool warning;

  AdminUserRecord copyWith({String? status, bool? warning}) => AdminUserRecord(
    id: id,
    name: name,
    role: role,
    email: email,
    status: status ?? this.status,
    lastActive: lastActive,
    school: school,
    phone: phone,
    warning: warning ?? this.warning,
  );
}

class AdminReportRecord {
  const AdminReportRecord({
    required this.id,
    required this.title,
    required this.reason,
    required this.reporter,
    required this.date,
    required this.priority,
    required this.status,
    required this.description,
    required this.target,
  });

  final String id;
  final String title;
  final String reason;
  final String reporter;
  final String date;
  final String priority;
  final String status;
  final String description;
  final String target;

  AdminReportRecord copyWith({String? status}) => AdminReportRecord(
    id: id,
    title: title,
    reason: reason,
    reporter: reporter,
    date: date,
    priority: priority,
    status: status ?? this.status,
    description: description,
    target: target,
  );
}

class AdminSkillGroup {
  const AdminSkillGroup({
    required this.id,
    required this.name,
    required this.skills,
    this.enabled = true,
  });

  final String id;
  final String name;
  final List<String> skills;
  final bool enabled;

  AdminSkillGroup copyWith({
    String? name,
    List<String>? skills,
    bool? enabled,
  }) => AdminSkillGroup(
    id: id,
    name: name ?? this.name,
    skills: skills ?? this.skills,
    enabled: enabled ?? this.enabled,
  );
}

class AdminNotificationRecord {
  const AdminNotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.category,
    required this.destination,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final String category;
  final String destination;
  final bool read;

  AdminNotificationRecord copyWith({bool? read}) => AdminNotificationRecord(
    id: id,
    title: title,
    body: body,
    time: time,
    category: category,
    destination: destination,
    read: read ?? this.read,
  );
}

class AdminOperationsState {
  const AdminOperationsState({
    required this.users,
    required this.reports,
    required this.skillGroups,
    required this.notifications,
    this.settings = const {
      'auto_scan': true,
      'tax_check': true,
      'priority_push': true,
      'two_factor': true,
      'email_digest': false,
    },
  });

  final List<AdminUserRecord> users;
  final List<AdminReportRecord> reports;
  final List<AdminSkillGroup> skillGroups;
  final List<AdminNotificationRecord> notifications;
  final Map<String, bool> settings;

  static const seed = AdminOperationsState(
    users: [
      AdminUserRecord(
        id: 'user-tran-minh-quan',
        name: 'Trần Minh Quân',
        role: 'Sinh viên',
        email: 'quan.tm@student.edu.vn',
        status: 'Hoạt động',
        lastActive: '15/09/2024',
        school: 'Đại học Bách Khoa TP.HCM',
        phone: '0912 ••• 889',
      ),
      AdminUserRecord(
        id: 'user-nguyen-bich-ngoc',
        name: 'Nguyễn Bích Ngọc',
        role: 'Nhà tuyển dụng',
        email: 'hr@saoviet-tech.vn',
        status: 'Chờ xác minh',
        lastActive: '24/10/2024',
        school: 'Công ty TNHH Công nghệ Sao Việt',
        phone: '0903 ••• 214',
      ),
      AdminUserRecord(
        id: 'user-le-hoang-nam',
        name: 'Lê Hoàng Nam',
        role: 'Sinh viên',
        email: 'nam.lh_blocked@gmail.com',
        status: 'Đã khóa',
        lastActive: '02/08/2024',
        school: 'Đại học Công nghệ',
        phone: '0981 ••• 420',
      ),
    ],
    reports: [
      AdminReportRecord(
        id: 'REP-2024-041',
        title: 'Tuyển CTV gõ văn bản tại nhà 500k/ngày',
        reason: 'Tin tuyển dụng đáng ngờ / Thu phí cọc',
        reporter: 'Sinh viên ẩn danh (STU-882)',
        date: 'Hôm nay 08:20',
        priority: 'Khẩn cấp',
        status: 'Chưa xử lý',
        description: 'Người đăng được phản ánh yêu cầu ứng viên chuyển phí tài liệu qua Telegram trước khi nhận việc.',
        target: 'Việc làm thêm bán thời gian gõ văn bản · Alpha Media',
      ),
      AdminReportRecord(
        id: 'REP-2024-039',
        title: 'Tài khoản: HR_Fast_Recruit',
        reason: 'Tài khoản giả mạo doanh nghiệp',
        reporter: 'Công ty Cổ phần VNG',
        date: 'Hôm qua 14:10',
        priority: 'Trung bình',
        status: 'Đang xử lý',
        description: 'Báo cáo cho biết tài khoản dùng nhận diện doanh nghiệp chưa được xác minh.',
        target: 'Hồ sơ nhà tuyển dụng HR_Fast_Recruit',
      ),
      AdminReportRecord(
        id: 'REP-2024-035',
        title: 'Marketing Intern không hỗ trợ phụ cấp',
        reason: 'Thông tin sai lệch / Lương không đúng cam kết',
        reporter: 'Ứng viên đã nộp hồ sơ',
        date: '24/10/2024',
        priority: 'Thấp',
        status: 'Đã giải quyết',
        description:
            'Doanh nghiệp đã cập nhật thông tin phụ cấp sau khi nhận phản hồi.',
        target: 'Marketing Intern · CareerMatch demo company',
      ),
    ],
    skillGroups: [
      AdminSkillGroup(
        id: 'software',
        name: 'Lập trình & Phát triển phần mềm',
        skills: ['NodeJS', 'React', 'Python', 'Java', 'Docker', 'Git'],
      ),
      AdminSkillGroup(
        id: 'data',
        name: 'Cơ sở dữ liệu & Phân tích',
        skills: ['PostgreSQL', 'MongoDB', 'SQL Server', 'Excel'],
      ),
      AdminSkillGroup(
        id: 'design',
        name: 'Thiết kế UI/UX & Đồ họa',
        skills: ['Figma', 'Adobe XD', 'User Research'],
      ),
      AdminSkillGroup(
        id: 'soft',
        name: 'Kỹ năng mềm & Giao tiếp công sở',
        skills: ['Làm việc nhóm', 'Thuyết trình', 'Quản lý thời gian'],
      ),
    ],
    notifications: [
      AdminNotificationRecord(
        id: 'notice-company',
        title: 'Hồ sơ doanh nghiệp mới chờ',
        body: 'Công ty TNHH Công nghệ Sao Việt vừa gửi bộ hồ sơ đăng ký.',
        time: '15 phút trước',
        category: 'Tự động đồng bộ',
        destination: '/admin/companies/pending',
      ),
      AdminNotificationRecord(
        id: 'notice-job',
        title: 'Tin tuyển dụng mới cần kiểm',
        body: 'Thực tập sinh Backend đang đợi kiểm tra tiêu chuẩn SDG 8.',
        time: '42 phút trước',
        category: 'Chuẩn SDG 8',
        destination: '/admin/jobs/pending',
      ),
      AdminNotificationRecord(
        id: 'notice-report',
        title: 'Báo cáo vi phạm khẩn cấp',
        body: 'Một tin tuyển dụng bị phản ánh có dấu hiệu yêu cầu đặt cọc.',
        time: '2 giờ trước',
        category: 'Ưu tiên cao',
        destination: '/admin/reports/REP-2024-041',
      ),
      AdminNotificationRecord(
        id: 'notice-backup',
        title: 'Sao lưu dữ liệu định kỳ hoàn tất',
        body: 'Thông báo mẫu về tác vụ lưu trữ trong giao diện thiết kế.',
        time: 'Hôm qua lúc 23:00',
        category: 'An toàn',
        read: true,
        destination: '/admin/dashboard',
      ),
    ],
  );

  AdminOperationsState copyWith({
    List<AdminUserRecord>? users,
    List<AdminReportRecord>? reports,
    List<AdminSkillGroup>? skillGroups,
    List<AdminNotificationRecord>? notifications,
    Map<String, bool>? settings,
  }) => AdminOperationsState(
    users: users ?? this.users,
    reports: reports ?? this.reports,
    skillGroups: skillGroups ?? this.skillGroups,
    notifications: notifications ?? this.notifications,
    settings: settings ?? this.settings,
  );
}

class AdminOperationsController extends Notifier<AdminOperationsState> {
  @override
  AdminOperationsState build() => AdminOperationsState.seed;

  AdminUserRecord? user(String id) => _find(state.users, id, (item) => item.id);

  AdminReportRecord? report(String id) =>
      _find(state.reports, id, (item) => item.id);

  bool updateUser(String id, {String? status, bool? warning}) {
    if (user(id) == null) return false;
    state = state.copyWith(
      users: [
        for (final item in state.users)
          if (item.id == id)
            item.copyWith(status: status, warning: warning)
          else
            item,
      ],
    );
    return true;
  }

  bool updateReport(String id, String status) {
    if (report(id) == null) return false;
    state = state.copyWith(
      reports: [
        for (final item in state.reports)
          if (item.id == id) item.copyWith(status: status) else item,
      ],
    );
    return true;
  }

  void setSetting(String key, bool value) =>
      state = state.copyWith(settings: {...state.settings, key: value});

  void markRead(String id) => state = state.copyWith(
    notifications: [
      for (final item in state.notifications)
        if (item.id == id) item.copyWith(read: true) else item,
    ],
  );

  void markAllRead() => state = state.copyWith(
    notifications: [
      for (final item in state.notifications) item.copyWith(read: true),
    ],
  );

  bool upsertSkillGroup({
    String? id,
    required String name,
    required String skill,
  }) {
    final cleanName = name.trim();
    final cleanSkill = skill.trim();
    if (cleanName.isEmpty || cleanSkill.isEmpty) return false;
    final index = id == null
        ? -1
        : state.skillGroups.indexWhere((item) => item.id == id);
    if (id != null && index < 0) return false;
    if (index < 0) {
      final newId = 'group-${DateTime.now().microsecondsSinceEpoch}';
      state = state.copyWith(
        skillGroups: [
          ...state.skillGroups,
          AdminSkillGroup(id: newId, name: cleanName, skills: [cleanSkill]),
        ],
      );
    } else {
      final group = state.skillGroups[index];
      final skills = [...group.skills];
      if (!skills.any(
        (item) => item.toLowerCase() == cleanSkill.toLowerCase(),
      )) {
        skills.add(cleanSkill);
      }
      final groups = [...state.skillGroups];
      groups[index] = group.copyWith(name: cleanName, skills: skills);
      state = state.copyWith(skillGroups: groups);
    }
    return true;
  }

  void toggleSkillGroup(String id, bool enabled) => state = state.copyWith(
    skillGroups: [
      for (final item in state.skillGroups)
        if (item.id == id) item.copyWith(enabled: enabled) else item,
    ],
  );

  void removeSkillGroup(String id) => state = state.copyWith(
    skillGroups: state.skillGroups.where((item) => item.id != id).toList(),
  );
}

T? _find<T>(List<T> values, String id, String Function(T) getId) {
  for (final value in values) {
    if (getId(value) == id) return value;
  }
  return null;
}

final adminOperationsProvider =
    NotifierProvider<AdminOperationsController, AdminOperationsState>(
      AdminOperationsController.new,
    );
