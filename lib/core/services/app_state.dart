import 'package:flutter/foundation.dart';
import '../../features/tasks/data/personal_task_repository.dart';
import '../../features/tasks/domain/personal_task.dart';
import '../../features/academic/data/subject_repository.dart';
import '../../features/academic/domain/subject.dart';

class AppState extends ChangeNotifier {
  AppState(this._taskRepository, {SubjectRepository? subjectRepository})
      : _subjectRepository = subjectRepository ?? MemorySubjectRepository();
  final PersonalTaskRepository _taskRepository;
  final SubjectRepository _subjectRepository;
  int _selectedTab = 0;
  List<PersonalTask> _tasks = [];
  List<Subject> _subjects = [];

  int get selectedTab => _selectedTab;
  List<PersonalTask> get tasks => List.unmodifiable(_tasks);
  List<Subject> get subjects => List.unmodifiable(_subjects);

  void selectTab(int index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    notifyListeners();
  }

  Future<void> restore() async {
    _tasks = await _taskRepository.load();
    _subjects = await _subjectRepository.load();
    notifyListeners();
  }

  Future<void> addTask(String title,
      {PersonalTaskCategory category = PersonalTaskCategory.personal}) async {
    final task = PersonalTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now(),
        category: category);
    _tasks = [..._tasks, task];
    notifyListeners();
    await _taskRepository.save(_tasks);
  }

  Future<void> addSubject(String name, {String? code}) async {
    final subject = Subject(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        academicPeriodId: 'default',
        name: name.trim(),
        code: code?.trim().isEmpty ?? true ? null : code!.trim(),
        colorValue: 0xFF2D6A62);
    _subjects = [..._subjects, subject];
    notifyListeners();
    await _subjectRepository.save(_subjects);
  }
}
