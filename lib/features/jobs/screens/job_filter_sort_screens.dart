import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../models/job.dart';
import '../state/job_discovery_state.dart';
import '../widgets/job_widgets.dart';

class JobFiltersScreen extends ConsumerWidget {
  const JobFiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobDiscoveryProvider);
    final controller = ref.read(jobDiscoveryProvider.notifier);
    final filters = state.filters;
    final count = controller.results(useDraftFilters: true).length;

    return JobScreenScaffold(
      title: 'Bộ lọc tìm kiếm',
      actions: [
        IconButton(
          tooltip: 'Thiết lập lại',
          onPressed: controller.resetFilters,
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 4),
      ],
      bottomAction: FilledButton.icon(
        onPressed: () {
          controller.applyFilters();
          context.pop();
        },
        icon: const Icon(Icons.check),
        label: Text('Áp dụng bộ lọc ($count kết quả)'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
        children: [
          _section(
            title: 'Độ phù hợp AI (Match Score)',
            icon: Icons.auto_awesome,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dự đoán mức độ tương thích kỹ năng với hồ sơ của bạn',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _scoreChoice(controller, filters, 'Tất cả', 0),
                    _scoreChoice(controller, filters, '> 90% AI', 90),
                    _scoreChoice(controller, filters, '> 75% AI', 75),
                    _scoreChoice(controller, filters, '> 60% AI', 60),
                  ],
                ),
              ],
            ),
          ),
          _section(
            title: 'Loại hình công việc',
            icon: Icons.work_outline,
            child: Column(
              children: [
                _checkRow(
                  'Thực tập tốt nghiệp (Internship)',
                  'Thực tập',
                  filters.types,
                  controller,
                  countLabel: '24 vị trí',
                ),
                _checkRow(
                  'Fresher / Mới tốt nghiệp',
                  'Fresher',
                  filters.types,
                  controller,
                  countLabel: '14 vị trí',
                ),
                _checkRow(
                  'Part-time linh hoạt',
                  'Part-time',
                  filters.types,
                  controller,
                  countLabel: '8 vị trí',
                ),
                _checkRow(
                  'Full-time Junior (<1 năm kn)',
                  'Full-time',
                  filters.types,
                  controller,
                  countLabel: '6 vị trí',
                ),
              ],
            ),
          ),
          _section(
            title: 'Hình thức làm việc',
            icon: Icons.apartment,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _modeChoice('Hybrid', filters.workModes, controller),
                _modeChoice('On-site', filters.workModes, controller),
                _modeChoice('Remote', filters.workModes, controller),
              ],
            ),
          ),
          _section(
            title: 'Mức trợ cấp / Lương',
            icon: Icons.payments_outlined,
            trailing: Text(
              '${(filters.minimumSalary / 1000000).round()} - ${(filters.maximumSalary / 1000000).round()} triệu/tháng',
              style: const TextStyle(fontSize: 10, color: AppColors.blue),
            ),
            child: Column(
              children: [
                RangeSlider(
                  min: 3,
                  max: 15,
                  divisions: 12,
                  values: RangeValues(
                    (filters.minimumSalary / 1000000).clamp(3, 15).toDouble(),
                    (filters.maximumSalary / 1000000).clamp(3, 15).toDouble(),
                  ),
                  labels: RangeLabels(
                    '${(filters.minimumSalary / 1000000).round()}tr',
                    '${(filters.maximumSalary / 1000000).round()}tr',
                  ),
                  onChanged: (value) => controller.updateFilters(
                    filters.copyWith(
                      minimumSalary: value.start.round() * 1000000,
                      maximumSalary: value.end.round() * 1000000,
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('3.000.000đ'),
                    Text('Phổ biến: 6-8 triệu'),
                    Text('15.000.000đ'),
                  ],
                ),
              ],
            ),
          ),
          _section(
            title: 'Tiêu chuẩn SDG 8',
            icon: Icons.verified_user_outlined,
            trailing: const JobPill(
              'Việc làm tử tế',
              color: AppColors.successTint,
              textColor: AppColors.success,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đảm bảo quyền lợi sinh viên theo mục tiêu phát triển bền vững Liên Hợp Quốc',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text(
                    'Chỉ việc làm đạt chuẩn SDG 8',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Có hướng dẫn và thông tin trợ cấp minh bạch',
                    style: TextStyle(fontSize: 10),
                  ),
                  value: filters.sdg8Only,
                  onChanged: (value) => controller.updateFilters(
                    filters.copyWith(sdg8Only: value),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Khu vực làm việc',
            icon: Icons.location_on_outlined,
            trailing: Text(
              'Đã chọn ${filters.districts.length}',
              style: const TextStyle(fontSize: 10, color: AppColors.blue),
            ),
            child: Column(
              children: [
                for (final area in [
                  'Quận 1',
                  'Quận 7',
                  'TP. Thủ Đức',
                  'Quận 10',
                ])
                  _districtRow(area, filters.districts, controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    ),
  );

  Widget _scoreChoice(
    JobDiscoveryController controller,
    JobFilters filters,
    String label,
    int score,
  ) => ChoiceChip(
    label: Text(label),
    selected: filters.minimumMatch == score,
    onSelected: (_) =>
        controller.updateFilters(filters.copyWith(minimumMatch: score)),
  );

  Widget _checkRow(
    String label,
    String value,
    Set<String> selected,
    JobDiscoveryController controller, {
    required String countLabel,
  }) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    dense: true,
    controlAffinity: ListTileControlAffinity.leading,
    value: selected.contains(value),
    onChanged: (checked) => controller.toggleType(value, checked ?? false),
    title: Text(label, style: const TextStyle(fontSize: 12)),
    secondary: Text(
      countLabel,
      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
    ),
  );

  Widget _modeChoice(
    String value,
    Set<String> selected,
    JobDiscoveryController controller,
  ) => FilterChip(
    label: Text(value),
    selected: selected.contains(value),
    onSelected: (checked) => controller.toggleWorkMode(value, checked),
  );

  Widget _districtRow(
    String value,
    Set<String> selected,
    JobDiscoveryController controller,
  ) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    dense: true,
    controlAffinity: ListTileControlAffinity.leading,
    value: selected.contains(value),
    onChanged: (checked) => controller.toggleDistrict(value, checked ?? false),
    title: Text(value, style: const TextStyle(fontSize: 12)),
  );
}

class JobSortScreen extends ConsumerStatefulWidget {
  const JobSortScreen({super.key});

  @override
  ConsumerState<JobSortScreen> createState() => _JobSortScreenState();
}

class _JobSortScreenState extends ConsumerState<JobSortScreen> {
  late JobSortOption _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(jobDiscoveryProvider).sort;
  }

  static const _labels = {
    JobSortOption.match: (
      'Mức độ phù hợp nhất',
      'AI Match Score từ cao đến thấp • Khuyên dùng cho sinh viên',
    ),
    JobSortOption.newest: (
      'Tin tuyển dụng mới nhất',
      'Ưu tiên cơ hội vừa đăng tải trong 24 giờ qua',
    ),
    JobSortOption.salary: (
      'Mức lương / Trợ cấp cao nhất',
      'Xếp theo mức thù lao cơ sở và trợ cấp minh bạch',
    ),
    JobSortOption.deadline: (
      'Hạn ứng tuyển gần nhất',
      'Tin sắp hết hạn nộp đơn, thời cơ phỏng vấn nhanh',
    ),
    JobSortOption.sdg8: (
      'Doanh nghiệp chuẩn SDG 8 uy tín nhất',
      'Môi trường làm việc bền vững, đào tạo đạt chuẩn và trả lương công bằng',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(jobDiscoveryProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: const Text('Sắp xếp việc làm')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              JobCard(job: demoJobs[0], compact: true),
              const SizedBox(height: 12),
              JobCard(job: demoJobs[1], compact: true),
            ],
          ),
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: .34)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 620),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.swap_vert, color: AppColors.blue),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Sắp xếp theo',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Flexible(
                        child: RadioGroup<JobSortOption>(
                          groupValue: _selected,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selected = value);
                            }
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (final option in JobSortOption.values)
                                _sortOption(option),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 8, bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Thứ tự danh sách sẽ thay đổi theo lựa chọn. Điểm phù hợp ở đây là dữ liệu demo.',
                          style: TextStyle(fontSize: 12, height: 1.4),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              child: const Text('Hủy'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              onPressed: () {
                                controller.setSort(_selected);
                                context.pop();
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Áp dụng sắp xếp'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortOption(JobSortOption option) {
    final (title, subtitle) = _labels[option]!;
    return RadioListTile<JobSortOption>(
      value: option,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, height: 1.35),
      ),
    );
  }
}
