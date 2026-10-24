import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../data/career_guidance_demo_data.dart';
import '../models/career_guidance_models.dart';
import '../state/career_guidance_state.dart';
import '../widgets/career_widgets.dart';

class LearningResourcesScreen extends ConsumerStatefulWidget {
  const LearningResourcesScreen({this.skill, super.key});
  final String? skill;

  @override
  ConsumerState<LearningResourcesScreen> createState() =>
      _LearningResourcesScreenState();
}

class _LearningResourcesScreenState
    extends ConsumerState<LearningResourcesScreen> {
  String selectedFilter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final goal = selectedCareerGoal(ref.watch(careerGuidanceProvider));
    final resources = learningResources.where((resource) {
      final matchesSkill =
          widget.skill == null ||
          resource.skill.toLowerCase() == widget.skill!.toLowerCase();
      final matchesFilter =
          selectedFilter == 'Tất cả' ||
          resource.skill.toLowerCase().contains(selectedFilter.toLowerCase());
      return matchesSkill && matchesFilter;
    }).toList();
    return CareerPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CareerBackHeader(
            title: 'Tài nguyên học tập',
            trailing: const CareerDemoNote(text: 'DEMO'),
          ),
          CareerCard(
            color: AppColors.blueTint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Học theo mục tiêu ${goal?.title ?? 'nghề nghiệp'}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.skill == null
                      ? 'Tài liệu minh họa được ghép với các kỹ năng trong mục tiêu.'
                      : 'Đang lọc theo: ${widget.skill}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nội dung và nhà cung cấp hiển thị ở đây là dữ liệu demo, không phải liên kết khóa học đã xác minh.',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const CareerSectionTitle('Chủ đề'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in [
                  'Tất cả',
                  'Docker',
                  'Testing',
                  'CI/CD',
                  'SQL',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      onSelected: (_) =>
                          setState(() => selectedFilter = filter),
                    ),
                  ),
              ],
            ),
          ),
          const CareerSectionTitle(
            'Gợi ý cho bạn',
            trailing: Text(
              'Demo',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (resources.isEmpty)
            const CareerCard(
              child: Text('Chưa có tài nguyên demo phù hợp với bộ lọc này.'),
            )
          else
            for (final resource in resources) ...[
              _LearningResourceCard(resource: resource),
              const SizedBox(height: 10),
            ],
          CareerCard(
            color: AppColors.success,
            child: const Row(
              children: [
                Icon(Icons.eco_outlined, color: AppColors.successTint),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nội dung mẫu để minh họa lộ trình học. Không cam kết chứng chỉ, học phí hoặc tính khả dụng của nhà cung cấp.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningResourceCard extends StatelessWidget {
  const _LearningResourceCard({required this.resource});
  final LearningResource resource;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push('/career/resource/${resource.id}'),
    borderRadius: BorderRadius.circular(14),
    child: CareerCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 86,
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Icon(
                _iconFor(resource.skill),
                size: 36,
                color: AppColors.successTint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    careerGapTag(resource.skill),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          resource.duration,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  resource.title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resource.provider,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  resource.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        resource.format,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.blue,
                      size: 17,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class LearningResourceDetailScreen extends ConsumerWidget {
  const LearningResourceDetailScreen({required this.resourceId, super.key});
  final String resourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LearningResource? resource;
    for (final item in learningResources) {
      if (item.id == resourceId) resource = item;
    }
    if (resource == null) {
      return CareerPage(
        child: Column(
          children: [
            const CareerBackHeader(title: 'Không tìm thấy tài liệu'),
            const CareerCard(
              child: Text('Không tìm thấy tài nguyên học tập này.'),
            ),
            const SizedBox(height: 16),
            CareerPrimaryButton(
              label: 'Về danh sách tài nguyên',
              onPressed: () => context.go('/career/resources'),
            ),
          ],
        ),
      );
    }
    final selected = resource;
    final isCompleted = ref
        .watch(careerGuidanceProvider)
        .completedResourceIds
        .contains(selected.id);
    return CareerPage(
      bottomAction: CareerPrimaryButton(
        label: isCompleted
            ? 'Đã đánh dấu hoàn thành demo'
            : 'Bắt đầu bài học demo',
        icon: isCompleted ? Icons.check : Icons.play_arrow,
        onPressed: () {
          ref
              .read(careerGuidanceProvider.notifier)
              .toggleResourceCompleted(selected.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tiến độ demo được lưu trong phiên hiện tại.'),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CareerBackHeader(title: 'Chi tiết tài nguyên'),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                _iconFor(selected.skill),
                size: 48,
                color: AppColors.successTint,
              ),
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 7,
            runSpacing: 6,
            children: [
              careerGapTag(selected.skill),
              const CareerDemoNote(text: 'Tài liệu demo'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            selected.title,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${selected.provider} · ${selected.duration} · ${selected.format}',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const CareerSectionTitle('Về nội dung'),
          CareerCard(
            child: Text(
              selected.description,
              style: const TextStyle(height: 1.4),
            ),
          ),
          const CareerSectionTitle(
            'Lộ trình bài học',
            trailing: Text(
              'Nội dung mẫu',
              style: TextStyle(fontSize: 10, color: AppColors.blue),
            ),
          ),
          for (var index = 0; index < 4; index++) ...[
            CareerCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? AppColors.blue
                        : AppColors.surfaceMuted,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index == 0
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      index == 0
                          ? 'Giới thiệu ${selected.skill}'
                          : [
                              'Khái niệm cốt lõi',
                              'Thực hành có hướng dẫn',
                              'Ôn tập và áp dụng',
                            ][index - 1],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    index == 0 ? Icons.play_circle_outline : Icons.lock_outline,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const CareerCard(
            color: AppColors.surfaceMuted,
            child: Text(
              'Không có URL khóa học đã xác minh. Màn hình này chỉ trình bày dữ liệu mô phỏng và không mở liên kết ngoài.',
              style: TextStyle(fontSize: 11, height: 1.35),
            ),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}

IconData _iconFor(String skill) {
  final value = skill.toLowerCase();
  if (value.contains('docker')) return Icons.dns_outlined;
  if (value.contains('test')) return Icons.fact_check_outlined;
  if (value.contains('sql') || value.contains('postgres')) {
    return Icons.storage_outlined;
  }
  if (value.contains('ci/cd')) return Icons.sync_alt;
  return Icons.code;
}
