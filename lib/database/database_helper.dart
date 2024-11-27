import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Initialize the database by loading sqlite3.dll (for desktop platforms)
  static void initDatabase() {
    // Correct way to initialize FFI without passing dylib
    sqfliteFfiInit(); // This should initialize FFI correctly
  }

  // Getter for the database (ensure that databaseFactory is set to FFI for desktop)
  Future<Database> get database async {
    // Ensure that the databaseFactory is set to FFI for non-mobile platforms (e.g., Windows, macOS, Linux)
    databaseFactory = databaseFactoryFfi;

    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path where the database will be stored
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'food_ordering.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE food_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            cost REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE order_plans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            target_cost REAL NOT NULL,
            items TEXT NOT NULL
          )
        ''');

        await _insertInitialFoodItems(db);
      },
      version: 1,
    );
  }

  // Insert some initial food items into the database
  Future<void> _insertInitialFoodItems(Database db) async {
    final foodItems = [
      {'name': 'Pizza', 'cost': 12.5},
      {'name': 'Burger', 'cost': 8.0},
      {'name': 'Pasta', 'cost': 10.0},
      {'name': 'Salad', 'cost': 6.0},
      {'name': 'Sandwich', 'cost': 5.5},
      {'name': 'Fries', 'cost': 3.5},
      {'name': 'Ice Cream', 'cost': 4.0},
      {'name': 'Soup', 'cost': 7.0},
      {'name': 'Steak', 'cost': 15.0},
    ];

    for (var item in foodItems) {
      await db.insert('food_items', item);
    }
  }

  // Get all food items from the database
  Future<List<Map<String, dynamic>>> getAllFoodItems() async {
    final db = await database;
    return db.query('food_items');
  }

  // Insert a new food item into the database
  Future<int> insertFoodItem(String name, double cost) async {
    final db = await database;
    return db.insert('food_items', {'name': name, 'cost': cost});
  }

  // Update an existing food item in the database
  Future<int> updateFoodItem(int id, String name, double cost) async {
    final db = await database;
    return db.update(
      'food_items',
      {'name': name, 'cost': cost},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a food item from the database
  Future<int> deleteFoodItem(int id) async {
    final db = await database;
    return db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }

  // Save an order plan into the database
  Future<int> saveOrderPlan(
      String date, double targetCost, String items) async {
    final db = await database;
    return db.insert('order_plans', {
      'date': date,
      'target_cost': targetCost,
      'items': items,
    });
  }

  // Get an order plan by date from the database
  Future<Map<String, dynamic>?> getOrderPlanByDate(String date) async {
    final db = await database;
    final result =
        await db.query('order_plans', where: 'date = ?', whereArgs: [date]);
    return result.isNotEmpty ? result.first : null;
  }
}
