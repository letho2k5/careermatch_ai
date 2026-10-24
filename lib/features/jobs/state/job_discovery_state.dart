import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/job.dart';

enum JobSortOption { match, newest, salary, deadline, sdg8 }

class JobFilters {
  const JobFilters({
    this.minimumMatch = 0,
    this.types = const {},
    this.workModes = const {},
    this.minimumSalary = 3000000,
    this.maximumSalary = 15000000,
    this.sdg8Only = false,
    this.districts = const {},
  });

  final int minimumMatch;
  final Set<String> types;
  final Set<String> workModes;
  final int minimumSalary;
  final int maximumSalary;
  final bool sdg8Only;
  final Set<String> districts;

  JobFilters copyWith({
    int? minimumMatch,
    Set<String>? types,
    Set<String>? workModes,
    int? minimumSalary,
    int? maximumSalary,
    bool? sdg8Only,
    Set<String>? districts,
  }) => JobFilters(
    minimumMatch: minimumMatch ?? this.minimumMatch,
    types: types ?? this.types,
    workModes: workModes ?? this.workModes,
    minimumSalary: minimumSalary ?? this.minimumSalary,
    maximumSalary: maximumSalary ?? this.maximumSalary,
    sdg8Only: sdg8Only ?? this.sdg8Only,
    districts: districts ?? this.districts,
  );

  static const defaults = JobFilters();
}

class JobDiscoveryState {
  const JobDiscoveryState({
    this.query = '',
    this.filters = JobFilters.defaults,
    this.appliedFilters = JobFilters.defaults,
    this.sort = JobSortOption.match,
    this.savedIds = const {},
  });

  final String query;

  /// Current filter form selections, retained when the filter route is closed.
  final JobFilters filters;

  /// Filters that have been confirmed and are currently applied to results.
  final JobFilters appliedFilters;
  final JobSortOption sort;
  final Set<String> savedIds;

  JobDiscoveryState copyWith({
    String? query,
    JobFilters? filters,
    JobFilters? appliedFilters,
    JobSortOption? sort,
    Set<String>? savedIds,
  }) => JobDiscoveryState(
    query: query ?? this.query,
    filters: filters ?? this.filters,
    appliedFilters: appliedFilters ?? this.appliedFilters,
    sort: sort ?? this.sort,
    savedIds: savedIds ?? this.savedIds,
  );
}

class JobDiscoveryController extends Notifier<JobDiscoveryState> {
  @override
  JobDiscoveryState build() => const JobDiscoveryState();

  void setQuery(String value) => state = state.copyWith(query: value);

  void updateFilters(JobFilters filters) =>
      state = state.copyWith(filters: filters);

  void resetFilters() => state = state.copyWith(filters: JobFilters.defaults);

  void applyFilters() => state = state.copyWith(appliedFilters: state.filters);

  void setSort(JobSortOption option) => state = state.copyWith(sort: option);

  void toggleType(String type, bool selected) => state = state.copyWith(
    filters: state.filters.copyWith(
      types: _toggleValue(state.filters.types, type, selected),
    ),
  );

  void toggleWorkMode(String mode, bool selected) => state = state.copyWith(
    filters: state.filters.copyWith(
      workModes: _toggleValue(state.filters.workModes, mode, selected),
    ),
  );

  void toggleDistrict(String district, bool selected) => state = state.copyWith(
    filters: state.filters.copyWith(
      districts: _toggleValue(state.filters.districts, district, selected),
    ),
  );

  void toggleSaved(String jobId) {
    final saved = {...state.savedIds};
    if (!saved.add(jobId)) saved.remove(jobId);
    state = state.copyWith(savedIds: saved);
  }

  List<Job> results({bool includeQuery = true, bool useDraftFilters = false}) {
    final filters = useDraftFilters ? state.filters : state.appliedFilters;
    final query = includeQuery ? state.query.trim().toLowerCase() : '';
    final result = demoJobs.where((job) {
      final textMatches =
          query.isEmpty ||
          '${job.title} ${job.company} ${job.location} ${job.skills.join(' ')} ${job.searchKeywords.join(' ')}'
              .toLowerCase()
              .contains(query);
      final typeMatches =
          filters.types.isEmpty || filters.types.contains(job.type);
      final modeMatches =
          filters.workModes.isEmpty || filters.workModes.contains(job.workMode);
      final salaryMatches =
          job.salaryMax >= filters.minimumSalary &&
          job.salaryMin <= filters.maximumSalary;
      final districtMatches =
          filters.districts.isEmpty ||
          filters.districts.any(job.location.contains);
      return textMatches &&
          typeMatches &&
          modeMatches &&
          salaryMatches &&
          districtMatches &&
          job.matchScore >= filters.minimumMatch &&
          (!filters.sdg8Only || job.sdg8);
    }).toList();

    switch (state.sort) {
      case JobSortOption.match:
        result.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      case JobSortOption.newest:
        result.sort((a, b) => a.postedHoursAgo.compareTo(b.postedHoursAgo));
      case JobSortOption.salary:
        result.sort((a, b) => b.salaryMax.compareTo(a.salaryMax));
      case JobSortOption.deadline:
        result.sort(
          (a, b) => a.daysUntilDeadline.compareTo(b.daysUntilDeadline),
        );
      case JobSortOption.sdg8:
        result.sort((a, b) => b.sdg8.toString().compareTo(a.sdg8.toString()));
    }
    return result;
  }
}

Set<String> _toggleValue(Set<String> current, String value, bool selected) => {
  if (selected) ...current,
  if (selected) value,
  if (!selected) ...current.where((item) => item != value),
};

final jobDiscoveryProvider =
    NotifierProvider<JobDiscoveryController, JobDiscoveryState>(
      JobDiscoveryController.new,
    );
