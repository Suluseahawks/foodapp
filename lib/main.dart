import 'package:flutter/material.dart';
// Import sqflite package
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart'; // Your screen (adjust path as necessary)
import 'database/database_helper.dart'; // Import the database helper

void main() async {
  // Ensure Flutter binding is initialized before any other operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database (this loads sqlite3.dll for non-mobile platforms)
  DatabaseHelper.initDatabase();

  // Set the database factory for non-mobile platforms (e.g., Windows, macOS, Linux)
  databaseFactory = databaseFactoryFfi;

  // Run the app after initializing the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
