enum AttachmentKind {
  mainFile,
  summary,
  exercise,
  additionalNote,
  image,
  other
}

class Lecture {
  Lecture({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.number,
    this.date,
    this.description,
    this.notes,
    this.attachments = const [],
    this.links = const [],
  })  : assert(number > 0),
        assert(title != '');

  final String id;
  final String subjectId;
  final String title;
  final int number;
  final DateTime? date;
  final String? description;
  final String? notes;
  final List<Attachment> attachments;
  final List<LectureLink> links;

  String get displayTitle => 'المحاضرة ${number.toString().padLeft(2, '0')}';

  List<Attachment> attachmentsOf(AttachmentKind kind) {
    return attachments.where((attachment) => attachment.kind == kind).toList();
  }
}

class Attachment {
  const Attachment({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.sizeBytes,
    required this.kind,
    required this.createdAt,
    this.storagePath,
  })  : assert(originalName != ''),
        assert(mimeType != ''),
        assert(sizeBytes >= 0);

  final String id;
  final String originalName;
  final String mimeType;
  final int sizeBytes;
  final AttachmentKind kind;
  final DateTime createdAt;
  final String? storagePath;

  bool get isUploaded => storagePath != null && storagePath!.isNotEmpty;
}

class LectureLink {
  const LectureLink({required this.label, required this.url});

  final String label;
  final Uri url;
}

abstract final class LectureOrdering {
  static List<Lecture> byNumber(Iterable<Lecture> lectures) {
    return lectures.toList()..sort((a, b) => a.number.compareTo(b.number));
  }
}
