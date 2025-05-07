import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app_data/models/student.dart';
import 'package:student_app_data/router/app_router.dart';
import 'firebase_options.dart';
import 'provider/student_provider.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => StudentProvider()), // Remove ..fetchStudents()
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Student CRUD',
            theme: themeProvider.themeData,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: Provider.of<StudentProvider>(context).studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data ?? [];

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return null;
          
            // Your list item widget
          },
        );
      },
    );
  }
}
