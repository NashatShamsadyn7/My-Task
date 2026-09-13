import 'dart:convert';
import '../../../core/services/local_key_value_store.dart';
import '../domain/subject.dart';

abstract interface class SubjectRepository {
  Future<List<Subject>> load();
  Future<void> save(List<Subject> subjects);
}

class LocalSubjectRepository implements SubjectRepository {
  LocalSubjectRepository(this._store);
  static const _key = 'subjects_v1';
  final LocalKeyValueStore _store;
  @override
  Future<List<Subject>> load() async {
    final raw = await _store.read(_key);
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SubjectJson.fromJson)
        .toList();
  }

  @override
  Future<void> save(List<Subject> subjects) =>
      _store.write(_key, jsonEncode(subjects.map(SubjectJson.toJson).toList()));
}

class MemorySubjectRepository implements SubjectRepository {
  List<Subject> _subjects = [];
  @override
  Future<List<Subject>> load() async => List.of(_subjects);
  @override
  Future<void> save(List<Subject> subjects) async =>
      _subjects = List.of(subjects);
}

abstract final class SubjectJson {
  static Map<String, dynamic> toJson(Subject subject) => {
        'id': subject.id,
        'academicPeriodId': subject.academicPeriodId,
        'name': subject.name,
        'colorValue': subject.colorValue,
        'code': subject.code,
        'teacherName': subject.teacherName,
        'defaultRoom': subject.defaultRoom,
        'creditHours': subject.creditHours,
        'notes': subject.notes
      };
  static Subject fromJson(Map<String, dynamic> json) => Subject(
      id: json['id'] as String,
      academicPeriodId: json['academicPeriodId'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int,
      code: json['code'] as String?,
      teacherName: json['teacherName'] as String?,
      defaultRoom: json['defaultRoom'] as String?,
      creditHours: json['creditHours'] as int?,
      notes: json['notes'] as String?);
}
