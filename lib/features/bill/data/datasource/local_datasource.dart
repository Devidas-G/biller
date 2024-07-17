import 'package:sqflite/sqflite.dart';

import '../../../../core/errors/exception.dart';
import '../../../../db_helper.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../models/category.dart';
import '../models/item.dart';

abstract class BillLocalDataSource {
  Future<List<ItemEntity>> getAllItems();
  Future<List<CategoryEntity>> getCategories();
  Future<List<ItemEntity>> getSearchItems(String search);
  Future<List<ItemEntity>> getItemsOfCategory(CategoryEntity category);
}

class BillLocalDataSourceImpl implements BillLocalDataSource {
  DBHelper dbHelper = DBHelper();
  @override
  Future<List<ItemEntity>> getAllItems() async {
    final db = await dbHelper.database;
    try {
      final result = await db.query('items');
      return result.map((map) {
        return Item.fromMap(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ItemEntity>> getSearchItems(String search) async {
    final db = await dbHelper.database;
    try {
      final result = await db.query(
        'items',
        where: 'name LIKE ?',
        whereArgs: ['%$search%'],
      );
      return result.map((map) {
        return Item.fromMap(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final db = await dbHelper.database;
    try {
      final result = await db.query('categories');
      return result.map((map) {
        return Category.fromMap(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ItemEntity>> getItemsOfCategory(CategoryEntity category) async {
    final db = await dbHelper.database;
    String categoryIds = category.id.toString();
    String query = '''
    SELECT DISTINCT items.id, items.name, items.price
    FROM items
    INNER JOIN item_categories ON items.id = item_categories.item_id
    WHERE item_categories.category_id IN ($categoryIds)
  ''';
    try {
      final result = await db.rawQuery(query);
      return result.map((map) {
        return Item.fromMap(map);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
