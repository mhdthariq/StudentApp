import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../services/firebase_service.dart';

class StudentProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> _selectedStudents = [];

  // Stream for real-time updates
  Stream<List<Student>> get studentsStream => _firebaseService.getStudents();

  List<String> get selectedStudents => _selectedStudents;

  Future<void> addStudent(Student student) async {
    try {
      await _firebaseService.addStudent(student);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      if (student.id != null) {
        await _firebaseService.updateStudent(student.id!, student);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _firebaseService.deleteStudent(id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  Future<void> deleteSelectedStudents() async {
    try {
      await _firebaseService.deleteMultipleStudents(_selectedStudents);
      _selectedStudents.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete selected students: $e');
    }
  }

  Future<void> deleteMultipleStudents(List<String> ids) async {
    try {
      await _firebaseService.deleteMultipleStudents(ids);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete students: $e');
    }
  }

  void toggleStudentSelection(String id) {
    if (_selectedStudents.contains(id)) {
      _selectedStudents.remove(id);
    } else {
      _selectedStudents.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedStudents.clear();
    notifyListeners();
  }
}
