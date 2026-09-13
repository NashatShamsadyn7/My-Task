import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/academic/domain/lecture.dart';

void main() {
  test('groups lecture files by their explicit classification', () {
    final lecture = Lecture(
      id: 'lecture-4',
      subjectId: 'networking',
      title: 'Networking basics',
      number: 4,
      attachments: [
        Attachment(
          id: 'main',
          originalName: 'Lecture 04.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 1200,
          kind: AttachmentKind.mainFile,
          createdAt: DateTime(2026, 9, 13),
        ),
        Attachment(
          id: 'summary',
          originalName: 'Summary.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 500,
          kind: AttachmentKind.summary,
          createdAt: DateTime(2026, 9, 13),
        ),
      ],
    );

    expect(lecture.displayTitle, 'المحاضرة 04');
    expect(lecture.attachmentsOf(AttachmentKind.mainFile), hasLength(1));
    expect(lecture.attachmentsOf(AttachmentKind.exercise), isEmpty);
  });

  test('sorts lectures by lecture number', () {
    final lectures = [
      Lecture(id: 'l2', subjectId: 'oop', title: 'Inheritance', number: 2),
      Lecture(id: 'l1', subjectId: 'oop', title: 'Introduction', number: 1),
    ];

    expect(LectureOrdering.byNumber(lectures).map((lecture) => lecture.id),
        ['l1', 'l2']);
  });
}
