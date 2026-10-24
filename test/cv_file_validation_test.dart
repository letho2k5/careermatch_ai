import 'package:careermatch_ai/features/cv/cv_file_validation.dart';
import 'package:careermatch_ai/features/cv/screens/cv_upload_screen.dart';
import 'package:careermatch_ai/features/student_profile/student_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateCvFile', () {
    test('accepts supported extensions case-insensitively up to 5 MB', () {
      for (final extension in ['pdf', 'doc', 'docx', 'PDF', 'DOCX']) {
        expect(
          validateCvFile(
            name: 'resume.$extension',
            extension: extension,
            bytes: maxCvBytes,
          ),
          isNull,
        );
      }
    });

    test('rejects missing name, unsupported type, unknown and empty size', () {
      expect(
        validateCvFile(name: '  ', extension: 'pdf', bytes: 10),
        CvFileValidationError.emptyName,
      );
      expect(
        validateCvFile(name: 'resume.txt', extension: 'txt', bytes: 10),
        CvFileValidationError.unsupportedExtension,
      );
      expect(
        validateCvFile(name: 'resume.pdf', extension: 'pdf', bytes: null),
        CvFileValidationError.unknownSize,
      );
      expect(
        validateCvFile(name: 'resume.pdf', extension: 'pdf', bytes: 0),
        CvFileValidationError.emptyFile,
      );
    });

    test('rejects a file one byte above 5 MB', () {
      expect(
        validateCvFile(
          name: 'resume.pdf',
          extension: 'pdf',
          bytes: maxCvBytes + 1,
        ),
        CvFileValidationError.tooLarge,
      );
    });

    test(
      'rejects an extension that is missing from the selected file name',
      () {
        expect(
          validateCvFile(name: 'resume', extension: null, bytes: 64),
          CvFileValidationError.unsupportedExtension,
        );
      },
    );
  });

  testWidgets('canceling the file picker preserves the existing CV', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(careerDraftProvider.notifier)
        .update(
          container
              .read(careerDraftProvider)
              .copyWith(cvName: 'existing.pdf', cvBytes: 120),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: CvUploadScreen(pickFile: () async => null)),
      ),
    );
    await tester.pumpAndSettle();
    final pickerButton = find.byIcon(Icons.upload_file);
    await tester.ensureVisible(pickerButton);
    await tester.tap(pickerButton);
    await tester.pumpAndSettle();

    expect(container.read(careerDraftProvider).cvName, 'existing.pdf');
    expect(container.read(careerDraftProvider).cvBytes, 120);
  });
}
