import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._init();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'data.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE item_categories (
        item_id INTEGER,
        category_id INTEGER,
        FOREIGN KEY (item_id) REFERENCES items (id),
        FOREIGN KEY (category_id) REFERENCES categories (id),
        PRIMARY KEY (item_id, category_id)
      )
    ''');
  }

  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnId = 'id';
  static const columnItemId = 'item_id';
  static const columnCategoryId = 'category_id';

  // Categories

  Future<void> updateCategory(int id, Map<String, dynamic> row) async {
    final db = await database;
    await db.update('categories', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCategory(int id) async {
    final db = await database;
    return await db.query('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Items

  Future<void> updateItem(int id, Map<String, dynamic> row) async {
    final db = await database;
    await db.update('items', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  ///Fetch all Items in the database
  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    final db = await database;
    return await db.query('items');
  }

  ///Unlinks a Items from a Category
  Future<void> deleteItemCategory(int itemId, int categoryId) async {
    final db = await database;
    await db.delete('item_categories',
        where: 'item_id = ? AND category_id = ?',
        whereArgs: [itemId, categoryId]);
  }
}
