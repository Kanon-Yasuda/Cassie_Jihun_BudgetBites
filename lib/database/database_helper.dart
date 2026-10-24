import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/meal.dart';
import '../models/purchase.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    final path = join(
      await getDatabasesPath(),
      'budget_bites.db',
    );

    _database = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            notes TEXT NOT NULL DEFAULT ''
          )
        ''');

        await db.execute('''
          CREATE TABLE purchases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            meal_id INTEGER NOT NULL,
            item_name TEXT NOT NULL,
            cost REAL NOT NULL CHECK(cost >= 0),
            date TEXT NOT NULL,
            FOREIGN KEY (meal_id)
              REFERENCES meals(id)
              ON DELETE CASCADE
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insertMeal(Meal meal) async {
    if (meal.name.trim().isEmpty ||
        meal.category.trim().isEmpty) {
      throw ArgumentError('Meal name and category are required.');
    }

    final db = await database;
    final data = meal.toMap();
    data.remove('id');

    return await db.insert('meals', data);
  }

  Future<List<Meal>> getMeals() async {
    final db = await database;
    final data = await db.query(
      'meals',
      orderBy: 'date DESC',
    );

    return data.map((item) => Meal.fromMap(item)).toList();
  }

  Future<int> updateMeal(Meal meal) async {
    if (meal.id == null ||
        meal.name.trim().isEmpty ||
        meal.category.trim().isEmpty) {
      throw ArgumentError('Invalid meal information.');
    }

    final db = await database;

    return await db.update(
      'meals',
      meal.toMap(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;

    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertPurchase(Purchase purchase) async {
    if (purchase.mealId <= 0 ||
        purchase.itemName.trim().isEmpty ||
        !purchase.cost.isFinite ||
        purchase.cost < 0) {
      throw ArgumentError('Invalid purchase information.');
    }

    final db = await database;
    final data = purchase.toMap();
    data.remove('id');

    return await db.insert('purchases', data);
  }

  Future<List<Purchase>> getPurchases(int mealId) async {
    final db = await database;
    final data = await db.query(
      'purchases',
      where: 'meal_id = ?',
      whereArgs: [mealId],
    );

    return data.map((item) => Purchase.fromMap(item)).toList();
  }

  Future<List<Purchase>> getAllPurchases() async {
    final db = await database;
    final data = await db.query('purchases');

    return data.map((item) => Purchase.fromMap(item)).toList();
  }

  Future<int> updatePurchase(Purchase purchase) async {
    if (purchase.id == null ||
        purchase.mealId <= 0 ||
        purchase.itemName.trim().isEmpty ||
        !purchase.cost.isFinite ||
        purchase.cost < 0) {
      throw ArgumentError('Invalid purchase information.');
    }

    final db = await database;

    return await db.update(
      'purchases',
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<int> deletePurchase(int id) async {
    final db = await database;

    return await db.delete(
      'purchases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalSpent() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(cost) AS total FROM purchases',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getMealTotal(int mealId) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(cost) AS total FROM purchases WHERE meal_id = ?',
      [mealId],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<void> close() async {
    final db = _database;

    if (db != null && db.isOpen) {
      await db.close();
    }

    _database = null;
  }
}