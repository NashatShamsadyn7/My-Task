import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/core/services/app_state.dart';
import 'package:talib_al_jamia/features/tasks/data/personal_task_repository.dart';
import 'package:talib_al_jamia/features/tasks/domain/personal_task.dart';
import 'package:talib_al_jamia/main.dart';

class _MemoryTaskRepository implements PersonalTaskRepository {
  List<PersonalTask> values = [];
  @override
  Future<List<PersonalTask>> load() async => values;
  @override
  Future<void> save(List<PersonalTask> tasks) async => values = tasks;
}

void main() {
  testWidgets('renders the Kurdish dashboard and primary navigation',
      (tester) async {
    await tester
        .pumpWidget(TalibAlJamiaApp(state: AppState(_MemoryTaskRepository())));

    expect(find.text('ڕۆژەکەت بە ئارامی ڕێکبخە'), findsOneWidget);
    expect(find.text('سەرەکی'), findsAtLeastNWidgets(1));
    expect(find.text('زانکۆ'), findsOneWidget);
    expect(find.text('زیادکردن'), findsOneWidget);
  });

  testWidgets('adds and displays a personal task', (tester) async {
    await tester
        .pumpWidget(TalibAlJamiaApp(state: AppState(_MemoryTaskRepository())));

    await tester.tap(find.text('زیادکردن'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ئەرکی کەسی'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'شراء الماء');
    await tester.tap(find.text('پاشەکەوت'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ئەرکەکان'));
    await tester.pumpAndSettle();

    expect(find.text('شراء الماء'), findsOneWidget);
  });
}
