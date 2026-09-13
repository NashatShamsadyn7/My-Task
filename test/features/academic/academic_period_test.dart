import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/academic/domain/academic_period.dart';

void main() {
  test('an academic period includes its start and end days', () {
    final period = AcademicPeriod(
      id: 'fall-2026',
      academicYearLabel: '2026–2027',
      stageLabel: 'الثانية',
      term: SemesterTerm.first,
      startsOn: DateTime(2026, 9, 1),
      endsOn: DateTime(2027, 1, 31),
    );

    expect(period.contains(DateTime(2026, 9, 1)), isTrue);
    expect(period.contains(DateTime(2027, 1, 31, 23, 59)), isTrue);
    expect(period.contains(DateTime(2027, 2, 1)), isFalse);
  });
}
