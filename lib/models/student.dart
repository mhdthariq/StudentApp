class Student {
  final String? id;
  final String name;
  final String studentId;
  final String major;
  final int age;
  final String grade;
  final String rollNo;

  Student({
    this.id,
    required this.name,
    required this.studentId,
    required this.major,
    required this.age,
    required this.grade,
    required this.rollNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'major': major,
      'age': age,
      'grade': grade,
      'rollNo': rollNo,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'] ?? '',
      studentId: map['studentId'] ?? '',
      major: map['major'] ?? '',
      age: map['age'] ?? 0,
      grade: map['grade'] ?? '',
      rollNo: map['rollNo'] ?? '',
    );
  }
}
