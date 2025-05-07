import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:student_app_data/models/student.dart';
import '../provider/student_provider.dart';
import 'add_update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool get _isWeb => MediaQuery.of(context).size.width > 600;
  bool _isSelecting = false;
  final Set<String> _selectedStudents = {};

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    context.go('/login');
  }

  void _toggleSelection(String studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }
      _isSelecting = _selectedStudents.isNotEmpty;
    });
  }

  void _deleteSelectedStudents(StudentProvider provider) async {
    try {
      await provider.deleteMultipleStudents(_selectedStudents.toList());
      setState(() {
        _selectedStudents.clear();
        _isSelecting = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting students: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade500.withOpacity(0.2),
                    Colors.blue.shade200.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.school, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            const Text(
              "Student List",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade50.withOpacity(0.5),
                    Colors.red.shade100.withOpacity(0.3),
                  ],
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () => _logout(context),
                tooltip: 'Logout',
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40), // Increased spacing
            Expanded(
              child: Consumer<StudentProvider>(
                builder: (context, studentProvider, _) {
                  return StreamBuilder<List<Student>>(
                    stream: studentProvider.studentsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final students = snapshot.data ?? [];

                      if (students.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off,
                                  size: 64, color: Colors.blue.shade200),
                              const SizedBox(height: 16),
                              Text(
                                'No students found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20, // Added top padding
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom:
                                    12.0), // Increased spacing between items
                            child: GestureDetector(
                              onLongPress: () {
                                _toggleSelection(student.id!);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _selectedStudents
                                                .contains(student.id)
                                            ? Colors.blue
                                            : Colors.white.withOpacity(0.5),
                                        width: _selectedStudents
                                                .contains(student.id)
                                            ? 2
                                            : 1,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue.shade100,
                                        child: Text(
                                          student.name[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        student.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ID: ${student.studentId}'),
                                          Text('Major: ${student.major}'),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUpdatePage(
                                                          student: student),
                                                ),
                                              );
                                            },
                                          ),
                                          if (_isSelecting)
                                            Checkbox(
                                              value: _selectedStudents
                                                  .contains(student.id),
                                              onChanged: (_) =>
                                                  _toggleSelection(student.id!),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isSelecting
          ? FloatingActionButton.extended(
              backgroundColor: Colors.red.withOpacity(0.9),
              elevation: 0,
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Delete Selected",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                _deleteSelectedStudents(
                  Provider.of<StudentProvider>(context, listen: false),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Added bottom padding to FAB
              child: FloatingActionButton.extended(
                backgroundColor: Colors.blue.withOpacity(0.9),
                elevation: 0,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Student",
                    style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AddUpdatePage()),
                ),
              ),
            ),
    );
  }
}
