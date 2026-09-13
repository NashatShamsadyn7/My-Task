import 'package:flutter/foundation.dart';
import '../../features/tasks/data/personal_task_repository.dart';
import '../../features/tasks/domain/personal_task.dart';

class AppState extends ChangeNotifier {
  AppState(this._taskRepository);
  final PersonalTaskRepository _taskRepository;
  int _selectedTab = 0;
  List<PersonalTask> _tasks = [];

  int get selectedTab => _selectedTab;
  List<PersonalTask> get tasks => List.unmodifiable(_tasks);

  void selectTab(int index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    notifyListeners();
  }

  Future<void> restore() async {
    _tasks = await _taskRepository.load();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = PersonalTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now());
    _tasks = [..._tasks, task];
    notifyListeners();
    await _taskRepository.save(_tasks);
  }
}
