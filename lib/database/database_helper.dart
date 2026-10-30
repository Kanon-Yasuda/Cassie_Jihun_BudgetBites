import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/meal.dart';
import '../models/purchase.dart';

// DatabaseHelper class - Singleton pattern
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  
  // Private constructor
  DatabaseHelper._init();
  
  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('budget_bites.db');
    return _database!;
  }
  
  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  // Create database tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }
  
  // CREATE - Insert new item
  Future<int> createMeals(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('meals', item);
  }
  
  // READ - Get all items
  Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await database;
    return await db.query('meals', orderBy: 'created_at DESC');
  }
  
  // READ - Get single item by ID
  Future<Map<String, dynamic>?> getMeal(int id) async {
    final db = await database;
    final results = await db.query(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  // UPDATE - Update existing item
  Future<int> updateMeal(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'meals',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // DELETE - Remove item
  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}