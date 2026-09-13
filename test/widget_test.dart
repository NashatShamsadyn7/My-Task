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
  testWidgets('renders the Arabic dashboard and primary navigation',
      (tester) async {
    await tester
        .pumpWidget(TalibAlJamiaApp(state: AppState(_MemoryTaskRepository())));

    expect(find.text('رتّب يومك بهدوء'), findsOneWidget);
    expect(find.text('الرئيسية'), findsAtLeastNWidgets(1));
    expect(find.text('الجامعة'), findsOneWidget);
    expect(find.text('إضافة'), findsOneWidget);
  });

  testWidgets('adds and displays a personal task', (tester) async {
    await tester
        .pumpWidget(TalibAlJamiaApp(state: AppState(_MemoryTaskRepository())));

    await tester.tap(find.text('إضافة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مهمة شخصية'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'شراء الماء');
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('المهام'));
    await tester.pumpAndSettle();

    expect(find.text('شراء الماء'), findsOneWidget);
  });
}
