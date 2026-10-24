enum SkillSource { profile, cvDemo }

class CareerSkill {
  const CareerSkill({
    required this.name,
    required this.level,
    required this.source,
  });

  final String name;
  final String level;
  final SkillSource source;
}

class CareerGoal {
  const CareerGoal({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.skills,
    required this.description,
    required this.matchPercent,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> skills;
  final String description;
  final int matchPercent;
}

class LearningResource {
  const LearningResource({
    required this.id,
    required this.title,
    required this.provider,
    required this.skill,
    required this.description,
    required this.duration,
    required this.format,
    this.free = true,
  });

  final String id;
  final String title;
  final String provider;
  final String skill;
  final String description;
  final String duration;
  final String format;
  final bool free;
}

class SkillGap {
  const SkillGap({required this.skill, required this.hasSkill});
  final String skill;
  final bool hasSkill;
}
