const maxCvBytes = 5 * 1024 * 1024;
const supportedCvExtensions = {'pdf', 'doc', 'docx'};

enum CvFileValidationError {
  emptyName,
  unsupportedExtension,
  unknownSize,
  emptyFile,
  tooLarge,
}

CvFileValidationError? validateCvFile({
  required String? name,
  required String? extension,
  required int? bytes,
}) {
  if (name == null || name.trim().isEmpty) {
    return CvFileValidationError.emptyName;
  }
  if (!supportedCvExtensions.contains(extension?.toLowerCase())) {
    return CvFileValidationError.unsupportedExtension;
  }
  if (bytes == null) return CvFileValidationError.unknownSize;
  if (bytes <= 0) return CvFileValidationError.emptyFile;
  if (bytes > maxCvBytes) return CvFileValidationError.tooLarge;
  return null;
}
