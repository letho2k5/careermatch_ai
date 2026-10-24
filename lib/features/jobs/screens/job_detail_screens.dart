import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../models/job.dart';
import '../state/job_discovery_state.dart';
import '../widgets/job_widgets.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  const JobDetailScreen({required this.jobId, super.key});
  final String jobId;

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    final jobs = demoJobs.where((item) => item.id == widget.jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Không tìm thấy việc làm',
        body: Center(child: Text('Việc làm này không tồn tại.')),
      );
    }
    final job = jobs.first;
    final saved = ref.watch(
      jobDiscoveryProvider.select((s) => s.savedIds.contains(job.id)),
    );
    final controller = ref.read(jobDiscoveryProvider.notifier);
    return JobScreenScaffold(
      title: 'Chi tiết việc làm',
      actions: [
        IconButton(
          tooltip: saved ? 'Bỏ lưu việc làm' : 'Lưu việc làm',
          onPressed: () {
            controller.toggleSaved(job.id);
            context.push('/jobs/${job.id}/save-confirmation');
          },
          icon: Icon(
            saved ? Icons.favorite : Icons.favorite_border,
            color: saved ? AppColors.error : null,
          ),
        ),
        IconButton(
          tooltip: 'Chia sẻ việc làm',
          onPressed: () =>
              _message(context, 'Chia sẻ chưa được kết nối trong bản demo.'),
          icon: const Icon(Icons.share_outlined),
        ),
      ],
      bottomAction: Row(
        children: [
          IconButton.filledTonal(
            tooltip: saved ? 'Bỏ lưu việc làm' : 'Lưu việc làm',
            onPressed: () {
              controller.toggleSaved(job.id);
              context.push('/jobs/${job.id}/save-confirmation');
            },
            icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => context.push('/jobs/${job.id}/apply'),
              icon: const Icon(Icons.send_outlined),
              label: const Text('Ứng tuyển ngay'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              const Icon(Icons.verified, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Tin tuyển dụng đã xác thực',
                  style: TextStyle(fontSize: 11, color: AppColors.success),
                ),
              ),
              const SizedBox(width: 4),
              TextButton.icon(
                onPressed: () => context.push('/companies/${job.companyId}'),
                icon: const Icon(Icons.business_outlined, size: 15),
                label: const Text('Công ty', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          _jobIdentity(job),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => context.push('/jobs/${job.id}/match'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.navyLight],
                ),
              ),
              child: Row(
                children: [
                  _scoreRing(job.matchScore, color: AppColors.blueTint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const JobPill(
                          'Rất phù hợp với bạn',
                          color: AppColors.blue,
                          textColor: Colors.white,
                          icon: Icons.auto_awesome,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Khớp mạnh các kỹ năng ${job.skills.take(2).join(', ')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push('/jobs/${job.id}/match'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Xem giải thích chi tiết →'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _factsGrid(job),
          const SizedBox(height: 18),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Mô tả')),
              ButtonSegment(value: 1, label: Text('Yêu cầu')),
              ButtonSegment(value: 2, label: Text('Quyền lợi')),
              ButtonSegment(value: 3, label: Text('Công ty')),
            ],
            selected: {_selectedSection},
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              setState(() => _selectedSection = selection.first);
              if (selection.first == 3) {
                context.push('/companies/${job.companyId}');
              }
            },
          ),
          const SizedBox(height: 12),
          _sectionContent(job),
          const SizedBox(height: 12),
          _skillsCard(context, job),
          const SizedBox(height: 12),
          _roadmapCard(),
        ],
      ),
    );
  }

  Widget _jobIdentity(Job job) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        JobLogo(company: job.company, size: 54),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.company,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                job.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                job.location,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Hạn ứng tuyển: còn ${job.daysUntilDeadline} ngày',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _scoreRing(int score, {Color color = AppColors.blue}) => SizedBox(
    width: 58,
    height: 58,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: score / 100,
          strokeWidth: 5,
          color: color,
          backgroundColor: Colors.white24,
        ),
        Text(
          '$score%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );

  Widget _factsGrid(Job job) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 2.7,
    children: [
      _fact(Icons.payments_outlined, 'Trợ cấp hỗ trợ', job.salaryLabel),
      _fact(Icons.groups_outlined, 'Quy mô tuyển', '05 vị trí'),
      _fact(Icons.schedule, 'Thời gian dự kiến', '3–6 tháng'),
      _fact(Icons.school_outlined, 'Hình thức đào tạo', 'Mentor 1:1'),
    ],
  );

  Widget _fact(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.blue),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    ),
  );

  Widget _sectionContent(Job job) {
    final (title, entries) = switch (_selectedSection) {
      1 => ('Yêu cầu ứng viên', job.requirements),
      2 => ('Quyền lợi & SDG 8', job.benefits),
      _ => ('Nhiệm vụ trọng tâm', [job.description]),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < entries.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedSection == 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 2),
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: AppColors.blueTint,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(right: 8, top: 3),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: AppColors.success,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      entries[i],
                      style: const TextStyle(fontSize: 12, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _skillsCard(BuildContext context, Job job) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CÔNG NGHỆ SẼ LÀM VIỆC',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: job.skills
              .map((skill) => JobPill(skill, color: AppColors.surfaceMuted))
              .toList(),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => context.push('/jobs/${job.id}/compare-skills'),
          icon: const Icon(Icons.compare_arrows),
          label: const Text('Đối chiếu kỹ năng'),
        ),
      ],
    ),
  );

  Widget _roadmapCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quy trình tuyển dụng tinh gọn',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RoadmapStep('1', 'Nộp CV & AI', true),
            _RoadmapStep('2', 'Phỏng vấn Tech', false),
            _RoadmapStep('3', 'Nhận Offer', false),
          ],
        ),
      ],
    ),
  );

  static void _message(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}

class _RoadmapStep extends StatelessWidget {
  const _RoadmapStep(this.number, this.label, this.active);
  final String number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CircleAvatar(
        radius: 14,
        backgroundColor: active ? AppColors.blue : AppColors.surfaceMuted,
        foregroundColor: active ? Colors.white : AppColors.textMuted,
        child: Text(number, style: const TextStyle(fontSize: 11)),
      ),
      const SizedBox(height: 5),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10),
      ),
    ],
  );
}

class CompanyDetailScreen extends ConsumerWidget {
  const CompanyDetailScreen({required this.companyId, super.key});
  final String companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = demoJobs.where((job) => job.companyId == companyId).toList();
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Không tìm thấy công ty',
        body: Center(child: Text('Công ty này không tồn tại.')),
      );
    }
    final company = switch (companyId) {
      'vng' => 'VNG Corporation',
      'momo' => 'MoMo (M_Service)',
      'tiki' => 'Tiki Corporation',
      'axon' => 'Axon Vietnam',
      'viettel' => 'Viettel Solutions',
      _ => 'FPT Software',
    };
    return JobScreenScaffold(
      title: 'Chi tiết công ty',
      actions: [
        IconButton(
          onPressed: () =>
              _message(context, 'Chia sẻ chưa được kết nối trong bản demo.'),
          icon: const Icon(Icons.share_outlined),
        ),
      ],
      bottomAction: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/jobs/results'),
              icon: const Icon(Icons.support_agent),
              label: const Text('Hỗ trợ sinh viên'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => context.push('/jobs/results'),
              icon: const Icon(Icons.work_outline),
              label: const Text('Xem việc làm'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF153B65), Color(0xFF9CC8EE)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.apartment, size: 48, color: Colors.white70),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: AppColors.blueTint,
                    child: Icon(Icons.business, color: AppColors.navy),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const Text(
                          'Đối tác đại học • Đã xác minh',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _message(
                      context,
                      'Đang theo dõi công ty trong bản demo.',
                    ),
                    child: const Text('Theo dõi'),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tập đoàn Công nghệ Thông tin & Chuyển đổi số',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successTint.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Bảo chứng SDG 8: vị trí dành cho sinh viên có phụ cấp minh bạch, chương trình hướng dẫn và cơ hội bình đẳng.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(child: _MetricBox('★ 4.8', '142 đánh giá')),
                    SizedBox(width: 8),
                    Expanded(child: _MetricBox('10.000+', 'Quy mô nhân sự')),
                    SizedBox(width: 8),
                    Expanded(child: _MetricBox('12', 'Vị trí mở')),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '📍 Khu Công nghệ Cao, TP. Thủ Đức, TP.HCM',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                const JobSectionTitle('Chương trình Green Internship 2025'),
                const SizedBox(height: 7),
                const Text(
                  'Chiến dịch tìm kiếm và ươm mầm tài năng trẻ ngành phần mềm, với cơ hội học tập và trải nghiệm văn hóa công nghệ cởi mở.',
                  style: TextStyle(fontSize: 12, height: 1.45),
                ),
                const SizedBox(height: 8),
                const _InfoPanel(
                  lines: [
                    '100% trả lương công bằng và minh bạch.',
                    'Senior Mentor 1:1 hướng dẫn trực tiếp.',
                    'Bình đẳng cơ hội tuyển dụng.',
                  ],
                ),
                const SizedBox(height: 16),
                const JobSectionTitle(
                  'Không gian làm việc & Đời sống',
                  trailing: Text(
                    '8 hình ảnh',
                    style: TextStyle(fontSize: 10, color: AppColors.blue),
                  ),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                  childAspectRatio: 1.45,
                  children: const [
                    _PhotoPlaceholder(
                      'Khu vực làm việc',
                      Icons.meeting_room_outlined,
                    ),
                    _PhotoPlaceholder(
                      'Pantry & Chill Zone',
                      Icons.coffee_outlined,
                    ),
                    _PhotoPlaceholder(
                      'Khu thể thao',
                      Icons.sports_basketball_outlined,
                    ),
                    _PhotoPlaceholder(
                      'Khu sinh hoạt nhóm',
                      Icons.groups_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                JobSectionTitle(
                  'Vị trí tiêu biểu đang tuyển',
                  trailing: TextButton(
                    onPressed: () => context.push('/jobs/results'),
                    child: const Text('Xem tất cả'),
                  ),
                ),
                const SizedBox(height: 8),
                for (final job in jobs) ...[
                  JobCard(job: job, compact: true),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _message(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}

class _MetricBox extends StatelessWidget {
  const _MetricBox(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.lines});
  final List<String> lines;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 15,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      line,
                      style: const TextStyle(fontSize: 11, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder(this.caption, this.icon);
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFE4EAF0),
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(
        colors: [Color(0xFFE4EAF0), Color(0xFFCAD6E2)],
      ),
    ),
    child: Stack(
      children: [
        const Center(
          child: Icon(Icons.image_outlined, size: 34, color: Color(0xFF8293A4)),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(6),
            color: Colors.black45,
            child: Row(
              children: [
                Icon(icon, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class RecommendedJobsScreen extends ConsumerWidget {
  const RecommendedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = [demoJobs[1], demoJobs[5], demoJobs[0]];
    return JobScreenScaffold(
      title: 'Việc làm AI gợi ý cho bạn',
      bottomNavigationBar: const _JobsBottomBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
        children: [
          const Text(
            'Cập nhật thời gian thực theo hồ sơ CV',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.navyLight],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobPill(
                  'THUẬT TOÁN SDG-8 MATCHER',
                  color: Color(0x33203459),
                  textColor: Colors.white,
                  icon: Icons.auto_awesome,
                ),
                SizedBox(height: 9),
                Text(
                  'Gợi ý dựa trên hồ sơ và kỹ năng của bạn.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Các điểm phù hợp và vị trí bên dưới là nội dung minh họa cục bộ.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: const [
              JobPill(
                'Tất cả (15)',
                color: AppColors.blue,
                textColor: Colors.white,
              ),
              JobPill('Match > 90%'),
              JobPill('Match > 80%'),
            ],
          ),
          const SizedBox(height: 12),
          for (final job in jobs) ...[
            _recommendedJobCard(context, job),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _recommendedJobCard(BuildContext context, Job job) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Row(
          children: [
            JobLogo(company: job.company, size: 42),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    '${job.company} • ${job.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            JobPill('${job.matchScore}% Match', icon: Icons.bolt),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.payments_outlined,
              size: 15,
              color: AppColors.blue,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                job.salaryLabel,
                style: const TextStyle(fontSize: 11),
              ),
            ),
            Text(
              job.workMode,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: job.matchScore / 100,
          minHeight: 5,
          borderRadius: BorderRadius.circular(99),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Lý do gợi ý: ${job.skills.take(3).join(', ')} phù hợp với yêu cầu vị trí.',
            style: const TextStyle(fontSize: 11, height: 1.4),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.push('/jobs/${job.id}/match'),
                child: const Text(
                  'Xem phân tích lý do',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => context.push('/jobs/${job.id}/apply'),
                icon: const Icon(Icons.send_outlined, size: 15),
                label: const Text(
                  'Ứng tuyển ngay',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _JobsBottomBar extends StatelessWidget {
  const _JobsBottomBar();
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: 1,
    height: 62,
    onDestinationSelected: (index) {
      if (index == 0 || index == 1) context.go('/jobs/home');
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        label: 'Trang chủ',
      ),
      NavigationDestination(icon: Icon(Icons.work_outline), label: 'Việc làm'),
      NavigationDestination(
        icon: Icon(Icons.route_outlined),
        label: 'Lộ trình',
      ),
      NavigationDestination(
        icon: Icon(Icons.assignment_outlined),
        label: 'Đã ứng tuyển',
      ),
      NavigationDestination(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
    ],
  );
}

class MatchExplanationScreen extends ConsumerWidget {
  const MatchExplanationScreen({required this.jobId, super.key});
  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = demoJobs.where((item) => item.id == jobId);
    if (jobs.isEmpty) {
      return const JobScreenScaffold(
        title: 'Không tìm thấy việc làm',
        body: Center(child: Text('Việc làm này không tồn tại.')),
      );
    }
    final job = jobs.first;
    return JobScreenScaffold(
      title: 'Phân tích mức độ phù hợp',
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: () => context.push('/jobs/$jobId/apply'),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Tiến hành nộp đơn ứng tuyển'),
          ),
          const SizedBox(height: 5),
          TextButton.icon(
            onPressed: () => context.push('/jobs/$jobId/compare-skills'),
            icon: const Icon(Icons.compare_arrows, size: 16),
            label: const Text('So sánh trực quan kỹ năng'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const JobSectionTitle(
            'Phân tích chuẩn xác',
            trailing: JobPill(
              'Minh bạch thuật toán • SDG 8',
              color: AppColors.successTint,
              textColor: AppColors.success,
            ),
          ),
          const SizedBox(height: 6),
          Text('Vị trí: ${job.title}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: job.matchScore / 100,
                              strokeWidth: 7,
                              backgroundColor: AppColors.blueTint,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${job.matchScore}%',
                                style: const TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Text(
                                'Rất cao',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const JobPill(
                            'Khớp lệnh AI tối ưu',
                            icon: Icons.auto_awesome,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tiềm năng nổi bật',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Hồ sơ của bạn phù hợp với yêu cầu kỹ thuật của doanh nghiệp.',
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const _EthicsNote(),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const JobSectionTitle(
            'Chi tiết 4 tiêu chí',
            trailing: Text(
              'Trọng số chuẩn hóa',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 8),
          _criterion(
            'Kỹ năng chuyên môn',
            '40% trọng số',
            0.95,
            'Khớp các kỹ năng được nhà tuyển dụng yêu cầu: ${job.skills.take(4).join(', ')}.',
          ),
          _criterion(
            'Học vấn & Ngành học',
            '20% trọng số',
            0.90,
            'Thông tin học vấn cần được sinh viên hoàn thiện để cá nhân hóa kết quả.',
          ),
          _criterion(
            'Định hướng nghề nghiệp',
            '20% trọng số',
            0.95,
            'Hình thức ${job.workMode} và mức trợ cấp nằm trong khoảng tham khảo.',
          ),
          _criterion(
            'Kinh nghiệm thực tế',
            '20% trọng số',
            0.85,
            'Dự án và kinh nghiệm thực tế có thể cải thiện mức độ phù hợp.',
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cần bổ sung gì để bứt phá?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Gợi ý demo: bổ sung Docker và kiểm thử tự động vào hồ sơ nếu bạn đã có kinh nghiệm.',
                  style: TextStyle(fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    JobPill('Docker cơ bản', color: Colors.white),
                    JobPill('Pytest & Unit Testing', color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _criterion(String title, String weight, double value, String detail) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  weight,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: value,
              minHeight: 5,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 7),
            Text(detail, style: const TextStyle(fontSize: 11, height: 1.4)),
          ],
        ),
      );
}

class _EthicsNote extends StatelessWidget {
  const _EthicsNote();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Text(
      'Cam kết công bằng: CareerMatch AI chỉ đóng vai trò gợi ý tham khảo. Quyết định phỏng vấn và tuyển dụng thuộc về nhà tuyển dụng.',
      style: TextStyle(fontSize: 11, height: 1.45),
    ),
  );
}
