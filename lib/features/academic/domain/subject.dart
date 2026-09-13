enum ClassMeetingType { lecture, lab, tutorial, other }

enum Weekday { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

class Subject {
  const Subject({
    required this.id,
    required this.academicPeriodId,
    required this.name,
    required this.colorValue,
    this.code,
    this.teacherName,
    this.defaultRoom,
    this.creditHours,
    this.notes,
    this.links = const [],
  })  : assert(name != ''),
        assert(creditHours == null || creditHours >= 0);

  final String id;
  final String academicPeriodId;
  final String name;
  final int colorValue;
  final String? code;
  final String? teacherName;
  final String? defaultRoom;
  final int? creditHours;
  final String? notes;
  final List<SubjectLink> links;
}

class SubjectLink {
  const SubjectLink({required this.label, required this.url});

  final String label;
  final Uri url;
}

class ClassMeeting {
  const ClassMeeting({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    required this.type,
    this.room,
    this.notes,
  })  : assert(startMinutes >= 0 && startMinutes < 24 * 60),
        assert(endMinutes > 0 && endMinutes <= 24 * 60),
        assert(endMinutes > startMinutes);

  final String id;
  final String subjectId;
  final Weekday weekday;
  final int startMinutes;
  final int endMinutes;
  final ClassMeetingType type;
  final String? room;
  final String? notes;

  String get timeRange {
    String format(int value) => value.toString().padLeft(2, '0');
    return '${format(startMinutes ~/ 60)}:${format(startMinutes % 60)}–'
        '${format(endMinutes ~/ 60)}:${format(endMinutes % 60)}';
  }
}

abstract final class ClassSchedule {
  static List<ClassMeeting> forDay(
    Iterable<ClassMeeting> meetings,
    Weekday weekday,
  ) {
    return meetings.where((meeting) => meeting.weekday == weekday).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  }
}
