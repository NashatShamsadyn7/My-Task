import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/academic/domain/subject.dart';

void main() {
  test('returns a daily schedule in chronological order', () {
    const meetings = [
      ClassMeeting(
        id: 'networking-lab',
        subjectId: 'networking',
        weekday: Weekday.tuesday,
        startMinutes: 660,
        endMinutes: 750,
        type: ClassMeetingType.lab,
      ),
      ClassMeeting(
        id: 'oop-lecture',
        subjectId: 'oop',
        weekday: Weekday.tuesday,
        startMinutes: 540,
        endMinutes: 630,
        type: ClassMeetingType.lecture,
      ),
    ];

    final schedule = ClassSchedule.forDay(meetings, Weekday.tuesday);

    expect(schedule.map((meeting) => meeting.id),
        ['oop-lecture', 'networking-lab']);
    expect(schedule.first.timeRange, '09:00–10:30');
  });
}
