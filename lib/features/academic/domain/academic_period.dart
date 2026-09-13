enum SemesterTerm { first, second }

/// A user-created university period. Archived periods remain readable but are
/// excluded from current-day academic queries.
class AcademicPeriod {
  AcademicPeriod({
    required this.id,
    required this.academicYearLabel,
    required this.stageLabel,
    required this.term,
    required this.startsOn,
    required this.endsOn,
    this.isArchived = false,
  }) : assert(!endsOn.isBefore(startsOn));

  final String id;
  final String academicYearLabel;
  final String stageLabel;
  final SemesterTerm term;
  final DateTime startsOn;
  final DateTime endsOn;
  final bool isArchived;

  bool contains(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(startsOn.year, startsOn.month, startsOn.day);
    final end = DateTime(endsOn.year, endsOn.month, endsOn.day);
    return !day.isBefore(start) && !day.isAfter(end);
  }
}
