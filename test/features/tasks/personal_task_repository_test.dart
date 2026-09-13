import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/tasks/data/personal_task_repository.dart';
import 'package:talib_al_jamia/features/tasks/domain/personal_task.dart';

void main() {
  test('task JSON preserves the information needed after application restart',
      () {
    final original = PersonalTask(
      id: 'task-1',
      title: 'شراء الماء',
      createdAt: DateTime(2026, 9, 13),
      category: PersonalTaskCategory.shopping,
      priority: PersonalTaskPriority.important,
      deadline: DateTime(2026, 9, 14, 18),
    );

    final restored =
        PersonalTaskJson.fromJson(PersonalTaskJson.toJson(original));

    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.category, PersonalTaskCategory.shopping);
    expect(restored.priority, PersonalTaskPriority.important);
    expect(restored.deadline, original.deadline);
  });
}
