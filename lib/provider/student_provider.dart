import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Student> _students = [];

  List<Student> get students => _students;

  Future<void> fetchStudents() async {
    _students = await _databaseHelper.getAllStudents();
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    await _databaseHelper.insertStudent(student);
    fetchStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _databaseHelper.updateStudent(student);
    fetchStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _databaseHelper.deleteStudent(id);
    fetchStudents();
  }
}