import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class FirebaseService {
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // Create
  Future<void> addStudent(Student student) async {
    try {
      await _studentsCollection.add({
        'name': student.name,
        'studentId': student.studentId,
        'major': student.major,
        'age': student.age,
        'grade': student.grade,
        'rollNo': student.rollNo,
      });
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  // Read
  Stream<List<Student>> getStudents() {
    return _studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Student(
          id: doc.id,
          name: data['name'] ?? '',
          studentId: data['studentId'] ?? '',
          major: data['major'] ?? '',
          age: data['age'] ?? 0,
          grade: data['grade'] ?? '',
          rollNo: data['rollNo'] ?? '',
        );
      }).toList();
    });
  }

  // Update
  Future<void> updateStudent(String id, Student student) async {
    try {
      await _studentsCollection.doc(id).update({
        'name': student.name,
        'studentId': student.studentId,
        'major': student.major,
        'age': student.age,
        'grade': student.grade,
        'rollNo': student.rollNo,
      });
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  // Delete
  Future<void> deleteStudent(String id) async {
    try {
      await _studentsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  // Delete multiple students
  Future<void> deleteMultipleStudents(List<String> ids) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (String id in ids) {
        batch.delete(_studentsCollection.doc(id));
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete students: $e');
    }
  }
}
