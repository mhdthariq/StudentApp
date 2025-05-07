import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../provider/student_provider.dart';
import '../utils/validators.dart';

class AddUpdatePage extends StatefulWidget {
  final Student? student;

  const AddUpdatePage({super.key, this.student});

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _studentIdController;
  late TextEditingController _majorController;
  late TextEditingController _ageController;
  late TextEditingController _gradeController;
  late TextEditingController _rollNoController;
  late Color primaryColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _studentIdController =
        TextEditingController(text: widget.student?.studentId ?? '');
    _majorController = TextEditingController(text: widget.student?.major ?? '');
    _ageController =
        TextEditingController(text: widget.student?.age.toString() ?? '');
    _gradeController = TextEditingController(text: widget.student?.grade ?? '');
    _rollNoController =
        TextEditingController(text: widget.student?.rollNo ?? '');
    primaryColor =
        widget.student == null ? Colors.blueAccent : Colors.deepPurpleAccent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _majorController.dispose();
    _ageController.dispose();
    _gradeController.dispose();
    _rollNoController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id,
        name: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        major: _majorController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        grade: _gradeController.text.trim(),
        rollNo: _rollNoController.text.trim(),
      );

      final provider = Provider.of<StudentProvider>(context, listen: false);
      if (widget.student == null) {
        provider.addStudent(student);
      } else {
        provider.updateStudent(student);
      }
      Navigator.of(context).pop(); // Use Navigator.of(context)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student == null ? "Add Student" : "Update Student",
          style: const TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(_nameController, "Name", Icons.person),
                      SizedBox(height: 12),
                      _buildTextField(
                          _studentIdController, "Student ID", Icons.badge),
                      SizedBox(height: 12),
                      _buildTextField(_majorController, "Major", Icons.school),
                      SizedBox(height: 12),
                      _buildTextField(
                          _ageController, "Age", Icons.calendar_today,
                          isNumber: true),
                      SizedBox(height: 12),
                      _buildTextField(_gradeController, "Grade", Icons.grade),
                      SizedBox(height: 12),
                      _buildTextField(_rollNoController, "Roll No",
                          Icons.format_list_numbered),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(widget.student == null
                            ? "Add Student"
                            : "Update Student"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
      ),
      validator: label == "Student ID"
          ? Validators.validateStudentId
          : Validators.validateName,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }
}
