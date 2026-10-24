import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_profile/student_draft.dart';
import '../models/job.dart';
import '../state/job_application_state.dart';
import '../widgets/application_widgets.dart';
import '../widgets/job_widgets.dart';

class SelectCvScreen extends ConsumerStatefulWidget {
  const SelectCvScreen({required this.jobId, super.key});
  final String jobId;

  @override
  ConsumerState<SelectCvScreen> createState() => _SelectCvScreenState();
}

class _SelectCvScreenState extends ConsumerState<SelectCvScreen> {
  late final TextEditingController _coverLetter;

  @override
  void initState() {
    super.initState();
    _coverLetter = TextEditingController(
      text: ref.read(jobApplicationProvider).draft.coverLetter,
    );
  }

  @override
  void dispose() {
    _coverLetter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = demoJobs.where((job) => job.id == widget.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Chọn CV',
        body: Center(child: Text('Không tìm thấy việc làm.')),
      );
    }
    final student = ref.watch(careerDraftProvider);
    final appDraft = ref.watch(jobApplicationProvider).draft;
    final hasCv =
        student.cvName != null &&
        student.cvName!.trim().isNotEmpty &&
        student.cvBytes != null &&
        student.cvBytes! > 0;
    final selected = hasCv && appDraft.selectedCvName == student.cvName;

    return JobScreenScaffold(
      title: 'Quick Apply Flow',
      bottomAction: FilledButton.icon(
        onPressed: appDraft.hasSelectedCv
            ? () {
                ref
                    .read(jobApplicationProvider.notifier)
                    .updateDraft(
                      appDraft.copyWith(coverLetter: _coverLetter.text),
                    );
                context.push('/jobs/${widget.jobId}/application-review');
              }
            : null,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Tiếp tục: Xem lại hồ sơ'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          const ApplicationStepHeader(step: 2),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.blueTint.withValues(alpha: .55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Chọn CV đã lưu trong hồ sơ. Tệp trong bản demo chỉ có tên và dung lượng trong bộ nhớ; không được tải lên máy chủ.',
              style: TextStyle(fontSize: 11, height: 1.4),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Hồ sơ CV có trong phiên này',
            style: TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (!hasCv)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 34,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chưa có CV trong bộ nhớ phiên này.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bạn có thể chọn PDF, DOC hoặc DOCX tối đa 5 MB trong màn hình tải CV.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            _CvOption(
              name: student.cvName!,
              bytes: student.cvBytes!,
              selected: selected,
              onTap: () => ref
                  .read(jobApplicationProvider.notifier)
                  .selectCv(student.cvName!, student.cvBytes!),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.push('/cv-upload'),
            icon: const Icon(Icons.upload_file),
            label: Text(hasCv ? 'Thay CV từ thiết bị' : 'Tải CV từ thiết bị'),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _coverLetter,
            minLines: 4,
            maxLines: 7,
            maxLength: 500,
            onChanged: (value) => ref
                .read(jobApplicationProvider.notifier)
                .updateDraft(appDraft.copyWith(coverLetter: value)),
            decoration: const InputDecoration(
              labelText: 'Thư giới thiệu ngắn (tùy chọn)',
              hintText: 'Viết vài dòng giới thiệu về bản thân…',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Không có CV thật trên thiết bị? Hãy quay lại sau khi chọn tệp. Bản ghi ứng tuyển demo chỉ chứa metadata tên và dung lượng.',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CvOption extends StatelessWidget {
  const _CvOption({
    required this.name,
    required this.bytes,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final int bytes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.blue : AppColors.textMuted,
            ),
            const SizedBox(width: 9),
            const Icon(Icons.picture_as_pdf, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${formatApplicationFileSize(bytes)} · CV lưu cục bộ trong phiên',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.successAccent),
          ],
        ),
      ),
    ),
  );
}
