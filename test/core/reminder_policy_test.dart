import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/core/services/reminder_policy.dart';

void main() {
  test('uses the specified escalating overdue intervals', () {
    final urgent = ReminderPolicyResolver.resolve(
      source: ReminderSource.personalTask,
      urgency: ReminderUrgency.urgent,
    );
    final important = ReminderPolicyResolver.resolve(
      source: ReminderSource.personalTask,
      urgency: ReminderUrgency.important,
    );
    final normal = ReminderPolicyResolver.resolve(
      source: ReminderSource.personalTask,
      urgency: ReminderUrgency.normal,
    );

    expect(urgent.repeatInterval, const Duration(hours: 1));
    expect(important.repeatInterval, const Duration(hours: 2));
    expect(normal.repeatInterval, const Duration(hours: 3));
  });

  test('does not schedule unlimited overdue reminders', () {
    const policy = ReminderPolicy(
      repeatInterval: Duration(hours: 1),
      maxOverdueRepeats: 2,
      channelKey: 'urgent_reminders',
    );
    final lastReminder = DateTime(2026, 9, 13, 9);

    expect(
      ReminderPolicyResolver.nextOverdueReminder(
        lastReminderAt: lastReminder,
        policy: policy,
        alreadySent: 1,
      ),
      DateTime(2026, 9, 13, 10),
    );
    expect(
      ReminderPolicyResolver.nextOverdueReminder(
        lastReminderAt: lastReminder,
        policy: policy,
        alreadySent: 2,
      ),
      isNull,
    );
  });
}
