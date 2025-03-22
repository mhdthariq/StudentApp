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
  late Color primaryColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _studentIdController = TextEditingController(text: widget.student?.studentId ?? '');
    _majorController = TextEditingController(text: widget.student?.major ?? '');
    primaryColor = widget.student == null ? Colors.blueAccent : Colors.deepPurpleAccent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm ${widget.student == null ? 'Add' : 'Update'}"),
          content: Text("Are you sure you want to ${widget.student == null ? 'add' : 'update'} this student?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final student = Student(
                  id: widget.student?.id,
                  name: _nameController.text.trim(),
                  studentId: _studentIdController.text.trim(),
                  major: _majorController.text.trim(),
                );

                final provider = Provider.of<StudentProvider>(context, listen: false);
                if (widget.student == null) {
                  provider.addStudent(student);
                } else {
                  provider.updateStudent(student);
                }
                Navigator.pop(context);
              },
              child: Text("Confirm"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? "Add Student" : "Update Student"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
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
                child: Column(
                  children: [
                    _buildTextField(_nameController, "Name", Icons.person),
                    SizedBox(height: 12),
                    _buildTextField(_studentIdController, "Student ID", Icons.badge, isNumber: true),
                    SizedBox(height: 12),
                    _buildTextField(_majorController, "Major", Icons.school),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(widget.student == null ? "Add Student" : "Update Student"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
      ),
      validator: label == "Student ID" ? Validators.validateStudentId : Validators.validateName,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }
}
