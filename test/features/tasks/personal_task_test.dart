import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/tasks/domain/personal_task.dart';

void main() {
  test('specific weekday recurrence only produces selected occurrences', () {
    final rule = RecurrenceRule(
      frequency: RecurrenceFrequency.weekdays,
      startsOn: DateTime(2026, 9, 13), // Sunday
      weekdays: {DateTime.sunday, DateTime.tuesday},
    );

    expect(rule.occursOn(DateTime(2026, 9, 13)), isTrue);
    expect(rule.occursOn(DateTime(2026, 9, 15)), isTrue);
    expect(rule.occursOn(DateTime(2026, 9, 14)), isFalse);
  });

  test('custom interval begins on the configured start day', () {
    final rule = RecurrenceRule(
      frequency: RecurrenceFrequency.customInterval,
      startsOn: DateTime(2026, 9, 13),
      customIntervalDays: 3,
    );

    expect(rule.occursOn(DateTime(2026, 9, 13)), isTrue);
    expect(rule.occursOn(DateTime(2026, 9, 16)), isTrue);
    expect(rule.occursOn(DateTime(2026, 9, 15)), isFalse);
  });

  test('a non-recurring task is due on its deadline day', () {
    final task = PersonalTask(
      id: 'buy-water',
      title: 'شراء الماء',
      createdAt: DateTime(2026, 9, 13),
      deadline: DateTime(2026, 9, 15, 18),
    );

    expect(task.isDueOn(DateTime(2026, 9, 15, 9)), isTrue);
    expect(task.isDueOn(DateTime(2026, 9, 16)), isFalse);
  });
}
