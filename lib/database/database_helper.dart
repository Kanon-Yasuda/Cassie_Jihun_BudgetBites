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
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id INTEGER NOT NULL,
        item_name TEXT NOT NULL,
        cost REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id) ON DELETE CASCADE
      )
    ''');
  }
  // CRUD FOR MEALS 
  // CREATE - Insert new item
  Future<int> createMeals(Meal meal) async {

    if (meal.name.isEmpty || meal.category.isEmpty) {
      throw Exception('Meal must have a name and category.');
    }

    final db = await database;
    final data = meal.toMap();
    return await db.insert('meals', data);
  }
  
  // READ - Get all items
  Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final results = await db.query('meals', orderBy: 'date DESC');
    return results.map((map) => Meal.fromMap(map)).toList();
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
  Future<int> updateMeal(int id, Meal meal) async {
    final db = await database;
    return await db.update(
      'meals',
      meal.toMap(),
      where: 'id = ?',
      whereArgs: [meal, id],
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


  // CRUD FOR PURCHASES
  // CREATE - Insert new item
  Future<int> createPurchase(Purchase purchase) async {

    final db = await database;
    final data = purchase.toMap();
    return await db.insert('purchases', data);
  }
  
  // READ - Get all items
  Future<List<Purchase>> getAllPurchases() async {
    final db = await database;
    final results = await db.query('purchases', orderBy: 'date DESC');
    return results.map((map) => Purchase.fromMap(map)).toList();
  }
  
  // READ - Get single item by ID
  Future<Map<String, dynamic>?> getPurchase(int id) async {
    final db = await database;
    final results = await db.query(
      'purchases',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  // UPDATE - Update existing item
  Future<int> updatePurchase(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'purchases',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // DELETE - Remove item
  Future<int> deletePurchase(int id) async {
    final db = await database;
    return await db.delete(
      'purchases',
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