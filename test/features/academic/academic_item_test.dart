import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/academic/domain/academic_item.dart';

void main() {
  test('defaults an unspecified start date to the date it was created', () {
    final item = AcademicItem(
      id: 'hw-1',
      subjectId: 'database',
      title: 'حل التمرين الأول',
      type: AcademicItemType.homework,
      createdAt: DateTime(2026, 9, 13, 18, 30),
    );

    expect(item.startDate, DateTime(2026, 9, 13));
  });

  test('checklist progress is the source of truth when enabled', () {
    final item = AcademicItem(
      id: 'project-1',
      subjectId: 'oop',
      title: 'مشروع البرمجة',
      type: AcademicItemType.project,
      createdAt: DateTime(2026, 9, 13),
      manualProgressPercent: 90,
      useChecklistProgress: true,
      checklist: const [
        ChecklistItem(id: 'one', text: 'التصميم', isCompleted: true),
        ChecklistItem(id: 'two', text: 'التنفيذ', isCompleted: true),
        ChecklistItem(id: 'three', text: 'الاختبار'),
        ChecklistItem(id: 'four', text: 'التسليم'),
        ChecklistItem(id: 'five', text: 'التوثيق'),
      ],
    );

    expect(item.progressPercent, 40);
  });

  test('sorts undated academic items after real deadlines', () {
    final now = DateTime(2026, 9, 13);
    final items = [
      AcademicItem(
          id: 'later',
          subjectId: 's',
          title: 'B',
          type: AcademicItemType.homework,
          createdAt: now,
          deadline: DateTime(2026, 9, 20)),
      AcademicItem(
          id: 'none',
          subjectId: 's',
          title: 'C',
          type: AcademicItemType.reading,
          createdAt: now),
      AcademicItem(
          id: 'first',
          subjectId: 's',
          title: 'A',
          type: AcademicItemType.quiz,
          createdAt: now,
          deadline: DateTime(2026, 9, 14)),
    ];

    expect(AcademicItemSorting.byDeadline(items).map((item) => item.id),
        ['first', 'later', 'none']);
  });
}
