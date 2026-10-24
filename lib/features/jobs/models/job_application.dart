class ApplicationDraft {
  const ApplicationDraft({
    this.jobId = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.university = '',
    this.major = '',
    this.availability = '',
    this.selectedCvName = '',
    this.selectedCvBytes,
    this.coverLetter = '',
    this.submittedApplicationId,
  });

  final String jobId;
  final String fullName;
  final String email;
  final String phone;
  final String university;
  final String major;
  final String availability;
  final String selectedCvName;
  final int? selectedCvBytes;
  final String coverLetter;
  final String? submittedApplicationId;

  bool get hasRequiredDetails =>
      fullName.trim().isNotEmpty &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim()) &&
      RegExp(r'^\+?[0-9() .-]{8,20}$').hasMatch(phone.trim()) &&
      university.trim().isNotEmpty &&
      availability.trim().isNotEmpty;

  bool get hasSelectedCv =>
      selectedCvName.trim().isNotEmpty &&
      selectedCvBytes != null &&
      selectedCvBytes! > 0;

  ApplicationDraft copyWith({
    String? jobId,
    String? fullName,
    String? email,
    String? phone,
    String? university,
    String? major,
    String? availability,
    String? selectedCvName,
    int? selectedCvBytes,
    String? coverLetter,
    String? submittedApplicationId,
    bool clearSelectedCv = false,
    bool clearSubmittedApplicationId = false,
  }) => ApplicationDraft(
    jobId: jobId ?? this.jobId,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    university: university ?? this.university,
    major: major ?? this.major,
    availability: availability ?? this.availability,
    selectedCvName: clearSelectedCv
        ? ''
        : selectedCvName ?? this.selectedCvName,
    selectedCvBytes: clearSelectedCv
        ? null
        : selectedCvBytes ?? this.selectedCvBytes,
    coverLetter: coverLetter ?? this.coverLetter,
    submittedApplicationId: clearSubmittedApplicationId
        ? null
        : submittedApplicationId ?? this.submittedApplicationId,
  );
}

class JobApplication {
  const JobApplication({
    required this.id,
    required this.jobId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.university,
    required this.major,
    required this.availability,
    required this.cvName,
    required this.cvBytes,
    required this.coverLetter,
    required this.submittedAt,
  });

  final String id;
  final String jobId;
  final String fullName;
  final String email;
  final String phone;
  final String university;
  final String major;
  final String availability;
  final String cvName;
  final int cvBytes;
  final String coverLetter;
  final DateTime submittedAt;

  String get demoStatusLabel => 'Ứng tuyển demo · lưu trong phiên';
}
