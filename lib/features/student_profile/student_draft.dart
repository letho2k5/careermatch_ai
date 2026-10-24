import 'package:flutter_riverpod/flutter_riverpod.dart';

class CareerDraft {
  const CareerDraft({
    this.fullName = '',
    this.phone = '',
    this.university = '',
    this.degree = '',
    this.major = '',
    this.schoolYear = '',
    this.jobStatus = 'Thực tập',
    this.targetRoles = const [
      'Backend Developer Intern',
      'Data Analyst Trainee',
    ],
    this.workModes = const ['On-site', 'Hybrid'],
    this.city = 'TP. Hồ Chí Minh',
    this.salary = 4,
    this.startAvailability = 'Sẵn sàng ngay trong 2 tuần tới',
    this.educationFrom = '09/2021',
    this.educationTo = '06/2025',
    this.educationHistory = const [],
    this.gpa = '3.42',
    this.thesis = '',
    this.showGpa = true,
    this.hardSkills = const {
      'Python': 'Thành thạo',
      'Node.js / Express': 'Trung cấp',
      'PostgreSQL & MongoDB': 'Trung cấp',
      'Git & CI/CD': 'Cơ bản',
      'RESTful API': 'Thành thạo',
    },
    this.softSkills = const [
      'Làm việc nhóm (Teamwork)',
      'Tư duy phản biện (Critical Thinking)',
      'Giải quyết vấn đề (Problem Solving)',
      'Giao tiếp học thuật',
    ],
    this.experiences = const [],
    this.cvName,
    this.cvBytes,
    this.extractedSkills = const {
      'Python': 'Nâng cao',
      'Express.js': 'Trung cấp',
      'PostgreSQL': 'Trung cấp',
      'Git': 'Cơ bản',
      'Data Structures': 'Thành thạo',
    },
    this.suspectedSkills = const ['Docker', 'AWS EC2 Basics'],
    this.confirmedExtractedSkills = false,
  });

  final String fullName, phone, university, degree, major, schoolYear;
  final String jobStatus, city, startAvailability, educationFrom, educationTo;
  final String gpa, thesis;
  final List<String> targetRoles, workModes, softSkills, suspectedSkills;
  final double salary;
  final bool showGpa, confirmedExtractedSkills;
  final Map<String, String> hardSkills, extractedSkills;
  final List<ExperienceDraft> experiences;
  final List<EducationRecord> educationHistory;
  final String? cvName;
  final int? cvBytes;

  CareerDraft copyWith({
    String? fullName,
    String? phone,
    String? university,
    String? degree,
    String? major,
    String? schoolYear,
    String? jobStatus,
    List<String>? targetRoles,
    List<String>? workModes,
    String? city,
    double? salary,
    String? startAvailability,
    String? educationFrom,
    String? educationTo,
    List<EducationRecord>? educationHistory,
    String? gpa,
    String? thesis,
    bool? showGpa,
    Map<String, String>? hardSkills,
    List<String>? softSkills,
    List<ExperienceDraft>? experiences,
    String? cvName,
    int? cvBytes,
    Map<String, String>? extractedSkills,
    List<String>? suspectedSkills,
    bool? confirmedExtractedSkills,
    bool clearCv = false,
  }) => CareerDraft(
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    university: university ?? this.university,
    degree: degree ?? this.degree,
    major: major ?? this.major,
    schoolYear: schoolYear ?? this.schoolYear,
    jobStatus: jobStatus ?? this.jobStatus,
    targetRoles: targetRoles ?? this.targetRoles,
    workModes: workModes ?? this.workModes,
    city: city ?? this.city,
    salary: salary ?? this.salary,
    startAvailability: startAvailability ?? this.startAvailability,
    educationFrom: educationFrom ?? this.educationFrom,
    educationTo: educationTo ?? this.educationTo,
    educationHistory: educationHistory ?? this.educationHistory,
    gpa: gpa ?? this.gpa,
    thesis: thesis ?? this.thesis,
    showGpa: showGpa ?? this.showGpa,
    hardSkills: hardSkills ?? this.hardSkills,
    softSkills: softSkills ?? this.softSkills,
    experiences: experiences ?? this.experiences,
    cvName: clearCv ? null : cvName ?? this.cvName,
    cvBytes: clearCv ? null : cvBytes ?? this.cvBytes,
    extractedSkills: extractedSkills ?? this.extractedSkills,
    suspectedSkills: suspectedSkills ?? this.suspectedSkills,
    confirmedExtractedSkills:
        confirmedExtractedSkills ?? this.confirmedExtractedSkills,
  );
}

class ExperienceDraft {
  const ExperienceDraft({
    required this.title,
    required this.organization,
    required this.period,
    required this.description,
    this.skills = const [],
  });
  final String title, organization, period, description;
  final List<String> skills;
}

class EducationRecord {
  const EducationRecord({
    required this.school,
    required this.degree,
    required this.period,
  });
  final String school, degree, period;
}

class CareerDraftController extends Notifier<CareerDraft> {
  @override
  CareerDraft build() => const CareerDraft();
  void update(CareerDraft next) => state = next;
}

final careerDraftProvider =
    NotifierProvider<CareerDraftController, CareerDraft>(
      CareerDraftController.new,
    );
