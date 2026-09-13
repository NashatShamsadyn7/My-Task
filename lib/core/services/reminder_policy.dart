enum ReminderSource { personalTask, academicItem, exam, quiz, responsibility }

enum ReminderUrgency { normal, important, urgent }

class ReminderPolicy {
  const ReminderPolicy({
    required this.repeatInterval,
    required this.maxOverdueRepeats,
    required this.channelKey,
  });

  final Duration repeatInterval;
  final int maxOverdueRepeats;
  final String channelKey;
}

/// A deterministic policy used by the future notification coordinator.
/// It never schedules notifications itself, so Android implementation remains
/// centralized rather than leaking into task or academic UI.
abstract final class ReminderPolicyResolver {
  static ReminderPolicy resolve({
    required ReminderSource source,
    required ReminderUrgency urgency,
  }) {
    if (source == ReminderSource.exam) {
      return const ReminderPolicy(
        repeatInterval: Duration(hours: 1),
        maxOverdueRepeats: 6,
        channelKey: 'exams',
      );
    }
    if (source == ReminderSource.quiz) {
      return const ReminderPolicy(
        repeatInterval: Duration(hours: 2),
        maxOverdueRepeats: 6,
        channelKey: 'academic_deadlines',
      );
    }
    return switch (urgency) {
      ReminderUrgency.urgent => const ReminderPolicy(
          repeatInterval: Duration(hours: 1),
          maxOverdueRepeats: 6,
          channelKey: 'urgent_reminders',
        ),
      ReminderUrgency.important => const ReminderPolicy(
          repeatInterval: Duration(hours: 2),
          maxOverdueRepeats: 5,
          channelKey: 'important_reminders',
        ),
      ReminderUrgency.normal => const ReminderPolicy(
          repeatInterval: Duration(hours: 3),
          maxOverdueRepeats: 4,
          channelKey: 'normal_reminders',
        ),
    };
  }

  static DateTime? nextOverdueReminder({
    required DateTime lastReminderAt,
    required ReminderPolicy policy,
    required int alreadySent,
  }) {
    if (alreadySent >= policy.maxOverdueRepeats) return null;
    return lastReminderAt.add(policy.repeatInterval);
  }
}
