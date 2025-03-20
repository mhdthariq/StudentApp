class Student {
  int? id;
  String name;
  String studentId;
  String major;

  Student({this.id, required this.name, required this.studentId, required this.major});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'major': major,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentId: map['studentId'],
      major: map['major'],
    );
  }
}