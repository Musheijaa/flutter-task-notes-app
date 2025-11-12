import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_notes_manager/theme.dart';
import 'package:task_notes_manager/providers/task_provider.dart';
import 'package:task_notes_manager/screens/home_screen.dart';
import 'package:task_notes_manager/constants.dart';

/// Entry point of the Task Notes Manager application
///
/// Initializes the app with Provider state management
/// and theme configuration for light/dark mode support.
void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TaskNotesApp());
}

/// Root widget of the Task Notes Manager application
class TaskNotesApp extends StatelessWidget {
  const TaskNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..initialize(),
      child: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return MaterialApp(
            title: UIText.appTitle,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: taskProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
