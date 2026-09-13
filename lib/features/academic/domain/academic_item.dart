enum AcademicItemType {
  homework,
  quiz,
  exam,
  project,
  presentation,
  report,
  reading,
  lab,
  nextClassRequirement,
  other,
}

enum AcademicItemStatus { notStarted, inProgress, completed, submitted, graded }

enum AcademicPriority { normal, important, urgent }

class AcademicItem {
  AcademicItem({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.type,
    required this.createdAt,
    DateTime? startDate,
    this.deadline,
    this.priority = AcademicPriority.normal,
    this.status = AcademicItemStatus.notStarted,
    this.description,
    this.manualProgressPercent,
    this.useChecklistProgress = false,
    this.checklist = const [],
    this.grade,
    this.maximumGrade,
  })  : startDate = startDate ??
            DateTime(createdAt.year, createdAt.month, createdAt.day),
        assert(title != ''),
        assert(manualProgressPercent == null ||
            (manualProgressPercent >= 0 && manualProgressPercent <= 100)),
        assert(grade == null || grade >= 0),
        assert(maximumGrade == null || maximumGrade > 0),
        assert(grade == null || maximumGrade == null || grade <= maximumGrade);

  final String id;
  final String subjectId;
  final String title;
  final AcademicItemType type;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime? deadline;
  final AcademicPriority priority;
  final AcademicItemStatus status;
  final String? description;
  final int? manualProgressPercent;
  final bool useChecklistProgress;
  final List<ChecklistItem> checklist;
  final num? grade;
  final num? maximumGrade;

  int get progressPercent {
    if (useChecklistProgress) {
      if (checklist.isEmpty) return 0;
      final completed = checklist.where((item) => item.isCompleted).length;
      return (completed * 100 ~/ checklist.length);
    }
    return manualProgressPercent ?? 0;
  }

  bool get canBeSubmitted {
    return switch (type) {
      AcademicItemType.exam ||
      AcademicItemType.quiz ||
      AcademicItemType.reading =>
        false,
      _ => true,
    };
  }
}

class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  }) : assert(text != '');

  final String id;
  final String text;
  final bool isCompleted;
}

abstract final class AcademicItemSorting {
  static List<AcademicItem> byDeadline(Iterable<AcademicItem> items) {
    return items.toList()
      ..sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
  }
}
