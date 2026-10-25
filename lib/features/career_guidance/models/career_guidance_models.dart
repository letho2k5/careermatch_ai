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

class CareerMilestoneTask {
  const CareerMilestoneTask({
    required this.id,
    required this.title,
    required this.description,
    this.duration = '30–45 phút',
  });

  final String id;
  final String title;
  final String description;
  final String duration;
}

class CareerMilestone {
  const CareerMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.tasks,
  });

  final String id;
  final String title;
  final String description;
  final List<String> skills;
  final List<CareerMilestoneTask> tasks;
}

class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String topic;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
