class Note {
  int ? id;
  String title;
  String note;

  Note({
    required this.id,
    required this.title,
    required this.note,
  });

  Note.sansId({required this.title, required this.note}) : id = null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title' : title,
      'note': note,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      note: map['note'],
    );
  }
}