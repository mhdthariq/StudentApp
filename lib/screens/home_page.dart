import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../provider/student_provider.dart';
import 'add_update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSelecting = false;
  final Set<int> _selectedStudents = {};

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    context.go('/login');
  }

  void _toggleSelection(int studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }
      _isSelecting = _selectedStudents.isNotEmpty;
    });
  }

  void _deleteSelectedStudents(StudentProvider provider) {
    for (var id in _selectedStudents) {
      provider.deleteStudent(id);
    }
    setState(() {
      _selectedStudents.clear();
      _isSelecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelecting ? "${_selectedStudents.length} Selected" : "Student List"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () => _logout(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.students.isEmpty) {
            return Center(
              child: Text("No students added yet!", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, index) {
              final student = provider.students[index];

              return Dismissible(
                key: Key(student.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  provider.deleteStudent(student.id!);
                },
                child: GestureDetector(
                  onLongPress: () => _toggleSelection(student.id!),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: _selectedStudents.contains(student.id) ? Colors.blue.shade100 : Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(student.name[0], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(student.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text("ID: ${student.studentId} • Major: ${student.major}", style: TextStyle(fontSize: 14)),
                      trailing: _isSelecting
                          ? Checkbox(
                        value: _selectedStudents.contains(student.id),
                        onChanged: (value) => _toggleSelection(student.id!),
                      )
                          : IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUpdatePage(student: student),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _isSelecting
          ? FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: () {
          final provider = Provider.of<StudentProvider>(context, listen: false);
          _deleteSelectedStudents(provider);
        },
        icon: Icon(Icons.delete, color: Colors.white),
        label: Text("Delete Selected", style: TextStyle(color: Colors.white)),
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.blueAccent,
            elevation: 4,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Student", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUpdatePage()),
              );
            },
          ),
        ),
      ),
    );
  }
}