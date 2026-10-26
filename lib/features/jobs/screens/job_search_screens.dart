import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../student_home/student_app_shell.dart';
import '../models/job.dart';
import '../state/job_discovery_state.dart';
import '../widgets/job_widgets.dart';

class JobSearchScreen extends ConsumerStatefulWidget {
  const JobSearchScreen({this.initialQuery, super.key});
  final String? initialQuery;

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery ?? ref.read(jobDiscoveryProvider).query;
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ref.read(jobDiscoveryProvider.notifier).setQuery(_controller.text);
    context.push('/jobs/results');
  }

  @override
  Widget build(BuildContext context) {
    return JobScreenScaffold(
      title: 'Job Filters',
      actions: [
        IconButton(
          tooltip: 'Đóng',
          onPressed: () => context.go('/jobs/home'),
          icon: const Icon(Icons.close),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Column(
              children: [
                _searchControls(),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip('Toàn thời gian', true),
                      _filterChip('Thực tập ngắn hạn (3 tháng)', false),
                      _filterChip('Làm việc từ xa', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _smartMatchCard(context),
                  const SizedBox(height: 18),
                  _livePreview(context),
                  const SizedBox(height: 22),
                  JobSectionTitle(
                    'Lịch sử tìm kiếm',
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text('Xóa tất cả'),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _historyChip(context, 'Thực tập Python TP.HCM'),
                      _historyChip(context, 'Backend NodeJS'),
                      _historyChip(context, 'Data Engineer fresher'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const JobSectionTitle('Xu hướng tìm kiếm sinh viên'),
                  const SizedBox(height: 6),
                  const Text(
                    'Cập nhật 1 giờ trước',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  for (final term in [
                    'Thực tập sinh AI',
                    'Frontend ReactJS',
                    'DevOps Cloud Intern',
                    'SDG-8 Verified Companies',
                  ])
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: const Icon(
                          Icons.trending_up,
                          color: AppColors.blue,
                        ),
                        title: Text(
                          term,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Việc làm được sinh viên quan tâm',
                        ),
                        trailing: const Icon(Icons.north_east, size: 18),
                        onTap: () => _setAndOpen(term),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppColors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Bạn chưa có CV chuẩn chỉnh? Hoàn thiện hồ sơ để nhận gợi ý việc làm phù hợp hơn.',
                            style: TextStyle(fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
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

  Widget _filterChip(String text, bool selected) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: FilterChip(
      label: Text(text),
      selected: selected,
      onSelected: (_) => context.push('/jobs/filters'),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    ),
  );

  Widget _searchControls() => LayoutBuilder(
    builder: (context, constraints) {
      final field = TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: ref.read(jobDiscoveryProvider.notifier).setQuery,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.blue),
          hintText: 'Vị trí, kỹ năng, công ty...',
          suffixIcon: IconButton(
            tooltip: 'Xóa nội dung tìm kiếm',
            onPressed: () {
              _controller.clear();
              ref.read(jobDiscoveryProvider.notifier).setQuery('');
            },
            icon: const Icon(Icons.cancel_outlined, size: 18),
          ),
        ),
      );
      final button = FilledButton(
        onPressed: _submit,
        child: const Text('Tìm kiếm'),
      );
      if (constraints.maxWidth < 320) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [field, const SizedBox(height: 8), button],
        );
      }
      return Row(
        children: [
          Expanded(child: field),
          const SizedBox(width: 8),
          button,
        ],
      );
    },
  );

  Widget _smartMatchCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [AppColors.navyLight, AppColors.blue],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            JobPill(
              'AI SMART SCAN 4.0',
              color: Color(0x33203459),
              textColor: Colors.white,
              icon: Icons.auto_awesome,
            ),
            JobPill(
              'SDG-8 Verified',
              color: AppColors.successTint,
              textColor: AppColors.success,
              icon: Icons.verified,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Khớp lệnh tuyển dụng bằng AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Nhập kỹ năng của bạn (VD: FastAPI, Docker) để xem các gợi ý minh họa.',
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Dữ liệu gợi ý minh họa',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/jobs/recommended'),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.analytics_outlined, size: 16),
              label: const Text('Xem gợi ý'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _livePreview(BuildContext context) {
    final query = ref.watch(jobDiscoveryProvider.select((s) => s.query));
    final matches = demoJobs
        .where((job) {
          final q = query.toLowerCase().trim();
          return q.isEmpty ||
              '${job.title} ${job.skills.join(' ')}'.toLowerCase().contains(q);
        })
        .take(2)
        .toList();
    return InkWell(
      onTap: () => context.push('/jobs/suggestions'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EDF1)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.manage_search,
                  color: AppColors.blue,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Gợi ý tức thì cho "${query.isEmpty ? 'Backend Python' : query}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  '${matches.length} kết quả',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final job in matches)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    JobLogo(company: job.company, size: 34),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    JobPill('${job.matchScore}% hợp'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _historyChip(BuildContext context, String text) => ActionChip(
    onPressed: () => _setAndOpen(text),
    avatar: const Icon(Icons.history, size: 14),
    label: Text(text, style: const TextStyle(fontSize: 11)),
  );

  void _setAndOpen(String term) {
    _controller.text = term;
    ref.read(jobDiscoveryProvider.notifier).setQuery(term);
    context.push('/jobs/results');
  }
}

class SearchSuggestionsScreen extends ConsumerStatefulWidget {
  const SearchSuggestionsScreen({this.initialQuery, super.key});
  final String? initialQuery;

  @override
  ConsumerState<SearchSuggestionsScreen> createState() =>
      _SearchSuggestionsScreenState();
}

class _SearchSuggestionsScreenState
    extends ConsumerState<SearchSuggestionsScreen> {
  late final TextEditingController _controller;
  static const suggestions = [
    'Backend Developer Intern',
    'Backend Node.js / Express',
    'Backend Golang Fresher',
    'Backend Engineer - FPT Telecom',
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery ?? ref.read(jobDiscoveryProvider).query;
    _controller = TextEditingController(
      text: initial.isEmpty ? 'Back' : initial,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => JobScreenScaffold(
    title: 'Job Filters',
    actions: [
      IconButton(
        onPressed: () => context.go('/jobs/home'),
        icon: const Icon(Icons.close),
      ),
    ],
    bottomAction: FilledButton.icon(
      onPressed: _openResults,
      icon: const Icon(Icons.manage_search),
      label: Text('Tìm kiếm tất cả cho "${_controller.text}"'),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          onChanged: ref.read(jobDiscoveryProvider.notifier).setQuery,
          onSubmitted: (_) => _openResults(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: AppColors.blue),
            suffixIcon: IconButton(
              onPressed: () {
                _controller.clear();
                ref.read(jobDiscoveryProvider.notifier).setQuery('');
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '✨ Hệ thống AI đang lọc các việc làm phù hợp với bạn',
          style: TextStyle(fontSize: 12, color: AppColors.blue),
        ),
        const SizedBox(height: 20),
        const JobSectionTitle(
          'Vị trí gợi ý hàng đầu',
          trailing: Text(
            'Thời gian thực',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < suggestions.length; i++)
          _suggestionTile(context, suggestions[i], i),
        const SizedBox(height: 22),
        const JobSectionTitle('Kỹ năng liên quan theo AI'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              ['Python Backend', 'PostgreSQL', 'RESTful API', 'Microservices']
                  .map(
                    (skill) => ActionChip(
                      avatar: const Icon(
                        Icons.code,
                        size: 14,
                        color: AppColors.blue,
                      ),
                      label: Text(skill),
                      onPressed: () {
                        _controller.text = skill;
                        ref.read(jobDiscoveryProvider.notifier).setQuery(skill);
                        _openResults();
                      },
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 22),
        const JobSectionTitle('Doanh nghiệp tuyển nhiều Backend'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _companyTile(context, 'MoMo Tech', '5 vị trí mở')),
            const SizedBox(width: 8),
            Expanded(child: _companyTile(context, 'KMS Tech', '8 vị trí mở')),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Dữ liệu gợi ý mẫu, không phải số liệu tuyển dụng trực tiếp.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    ),
  );

  Widget _suggestionTile(BuildContext context, String title, int index) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              _controller.text = title;
              ref.read(jobDiscoveryProvider.notifier).setQuery(title);
              _openResults();
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: index == 1
                        ? AppColors.blueTint
                        : AppColors.surfaceMuted,
                    child: Icon(
                      index == 1 ? Icons.auto_awesome : Icons.search,
                      size: 18,
                      color: index == 1 ? AppColors.blue : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          index == 1
                              ? 'Match theo kỹ năng và hồ sơ'
                              : 'Gợi ý việc làm phù hợp',
                          style: TextStyle(
                            fontSize: 11,
                            color: index == 1
                                ? AppColors.blue
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.north_west,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _companyTile(BuildContext context, String name, String positions) =>
      InkWell(
        onTap: () => context.push('/companies/fpt-software'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.business_outlined, color: AppColors.blue),
              const SizedBox(height: 6),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                positions,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );

  void _openResults() {
    FocusScope.of(context).unfocus();
    ref.read(jobDiscoveryProvider.notifier).setQuery(_controller.text);
    context.push('/jobs/results');
  }
}

class JobSearchResultsScreen extends ConsumerWidget {
  const JobSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobDiscoveryProvider);
    final controller = ref.read(jobDiscoveryProvider.notifier);
    final jobs = controller.results();
    return StudentAppShell(
      selectedTab: 1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.push('/jobs/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.blue,
                            size: 19,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.query.isEmpty
                                  ? 'Từ khóa tìm kiếm'
                                  : state.query,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (state.query.isNotEmpty)
                            GestureDetector(
                              onTap: () => controller.setQuery(''),
                              child: const Icon(
                                Icons.cancel_outlined,
                                size: 17,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  tooltip: 'Bộ lọc',
                  onPressed: () => context.push('/jobs/filters'),
                  icon: const Icon(Icons.tune),
                ),
                IconButton(
                  tooltip: 'Sắp xếp',
                  onPressed: () => context.push('/jobs/sort'),
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
          ),
          if (state.appliedFilters.minimumMatch > 0 ||
              state.appliedFilters.districts.isNotEmpty)
            SizedBox(
              height: 42,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                children: [
                  if (state.appliedFilters.minimumMatch > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(
                        label: Text(
                          'Match ≥ ${state.appliedFilters.minimumMatch}%',
                        ),
                      ),
                    ),
                  for (final district in state.appliedFilters.districts)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(label: Text(district)),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: JobSectionTitle(
              '${jobs.length} việc làm',
              trailing: Text(
                'Dữ liệu minh họa',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          Expanded(
            child: jobs.isEmpty
                ? JobEmptyState(
                    title: 'Chưa tìm thấy việc làm phù hợp',
                    onReset: () {
                      controller.resetFilters();
                      controller.applyFilters();
                      controller.setQuery('');
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                    itemCount: jobs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => JobCard(job: jobs[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
