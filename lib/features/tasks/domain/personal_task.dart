enum PersonalTaskCategory { personal, shopping, health, family, other }

enum PersonalTaskPriority { normal, important, urgent }

enum PersonalTaskStatus { active, completed, cancelled }

enum RecurrenceFrequency { daily, weekdays, weekly, monthly, customInterval }

class PersonalTask {
  PersonalTask({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description,
    this.category = PersonalTaskCategory.personal,
    this.priority = PersonalTaskPriority.normal,
    this.startDate,
    this.deadline,
    this.reminderAt,
    this.recurrence,
    this.status = PersonalTaskStatus.active,
  }) : assert(title != '');

  final String id;
  final String title;
  final DateTime createdAt;
  final String? description;
  final PersonalTaskCategory category;
  final PersonalTaskPriority priority;
  final DateTime? startDate;
  final DateTime? deadline;
  final DateTime? reminderAt;
  final RecurrenceRule? recurrence;
  final PersonalTaskStatus status;

  bool get isRecurring => recurrence != null;

  bool isDueOn(DateTime date) {
    if (recurrence != null) return recurrence!.occursOn(date);
    final due = deadline ?? startDate;
    if (due == null) return false;
    return _sameDay(due, date);
  }
}

class RecurrenceRule {
  RecurrenceRule({
    required this.frequency,
    required this.startsOn,
    this.endsOn,
    Set<int> weekdays = const {},
    this.customIntervalDays,
  })  : weekdays = Set.unmodifiable(weekdays),
        assert(weekdays
            .every((day) => day >= DateTime.monday && day <= DateTime.sunday)),
        assert(customIntervalDays == null || customIntervalDays > 0),
        assert(endsOn == null || !endsOn.isBefore(startsOn));

  final RecurrenceFrequency frequency;
  final DateTime startsOn;
  final DateTime? endsOn;
  final Set<int> weekdays;
  final int? customIntervalDays;

  bool occursOn(DateTime date) {
    final day = _day(date);
    final start = _day(startsOn);
    if (day.isBefore(start) || (endsOn != null && day.isAfter(_day(endsOn!)))) {
      return false;
    }
    final daysSinceStart = day.difference(start).inDays;
    return switch (frequency) {
      RecurrenceFrequency.daily => true,
      RecurrenceFrequency.weekdays => weekdays.isEmpty
          ? day.weekday == start.weekday
          : weekdays.contains(day.weekday),
      RecurrenceFrequency.weekly => daysSinceStart % 7 == 0,
      RecurrenceFrequency.monthly => day.day == start.day,
      RecurrenceFrequency.customInterval =>
        daysSinceStart % (customIntervalDays ?? 1) == 0,
    };
  }
}

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

bool _sameDay(DateTime a, DateTime b) => _day(a) == _day(b);
