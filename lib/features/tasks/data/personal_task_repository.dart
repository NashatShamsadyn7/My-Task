import 'dart:convert';

import '../../../core/services/local_key_value_store.dart';
import '../domain/personal_task.dart';

abstract interface class PersonalTaskRepository {
  Future<List<PersonalTask>> load();
  Future<void> save(List<PersonalTask> tasks);
}

class LocalPersonalTaskRepository implements PersonalTaskRepository {
  LocalPersonalTaskRepository(this._store);
  static const _key = 'personal_tasks_v1';
  final LocalKeyValueStore _store;

  @override
  Future<List<PersonalTask>> load() async {
    final raw = await _store.read(_key);
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(PersonalTaskJson.fromJson)
        .toList();
  }

  @override
  Future<void> save(List<PersonalTask> tasks) => _store.write(
      _key, jsonEncode(tasks.map(PersonalTaskJson.toJson).toList()));
}

abstract final class PersonalTaskJson {
  static Map<String, dynamic> toJson(PersonalTask task) => {
        'id': task.id,
        'title': task.title,
        'createdAt': task.createdAt.toIso8601String(),
        'description': task.description,
        'category': task.category.name,
        'priority': task.priority.name,
        'startDate': task.startDate?.toIso8601String(),
        'deadline': task.deadline?.toIso8601String(),
        'reminderAt': task.reminderAt?.toIso8601String(),
        'status': task.status.name,
      };

  static PersonalTask fromJson(Map<String, dynamic> json) => PersonalTask(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        description: json['description'] as String?,
        category:
            PersonalTaskCategory.values.byName(json['category'] as String),
        priority:
            PersonalTaskPriority.values.byName(json['priority'] as String),
        startDate: _date(json['startDate']),
        deadline: _date(json['deadline']),
        reminderAt: _date(json['reminderAt']),
        status: PersonalTaskStatus.values.byName(json['status'] as String),
      );

  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.parse(value as String);
}
