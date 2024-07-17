import 'package:sqflite/sqflite.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/success.dart';
import '../../../../db_helper.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../models/category.dart';
import '../models/item.dart';

abstract class InventoryLocalDatasource {
  ///Fetch all categories from the database
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity> addCategory(CategoryEntity category);

  ///Fetch Items from a specific category
  Future<List<ItemEntity>> getItems(List<CategoryEntity> categories);
  Future<List<ItemEntity>> getAllItems();
  Future<ItemEntity> addItem(ItemEntity item, List<CategoryEntity>? categories);
  Future<ItemEntity> updateItem(
      ItemEntity item, List<CategoryEntity> categories);
  Future<Success> deleteItem(ItemEntity item);
}

class InventoryLocalDatasourceImpl implements InventoryLocalDatasource {
  DBHelper dbHelper = DBHelper();

  ///Fetch all categories from the database
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

  ///Fetch Items from a specific category
  @override
  Future<List<ItemEntity>> getItems(List<CategoryEntity> categories) async {
    final db = await dbHelper.database;
    String categoryIds =
        categories.map((category) => category.id.toString()).join(',');
    String query = '''
    SELECT DISTINCT items.id, items.name, items.price
    FROM items
    INNER JOIN item_categories ON items.id = item_categories.item_id
    WHERE item_categories.category_id IN ($categoryIds)
  ''';
    try {
      final result = await db.rawQuery(query);
      return result.map((map) {
        return Item.fromMap(map, const []);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<List<ItemEntity>> getAllItems() async {
    final db = await dbHelper.database;
    String query = '''
    SELECT items.id, items.name, items.price, 
             GROUP_CONCAT(categories.id) AS category_ids, 
             GROUP_CONCAT(categories.name) AS category_names
      FROM items
      LEFT JOIN item_categories ON items.id = item_categories.item_id
      LEFT JOIN categories ON item_categories.category_id = categories.id
      GROUP BY items.id
''';
    try {
      final result = await db.rawQuery(query);
      return result.map((map) {
        List<Category> categories = [];
        if (map['category_ids'] != null && map['category_names'] != null) {
          List<String> categoryIds = (map['category_ids'] as String).split(',');
          List<String> categoryNames =
              (map['category_names'] as String).split(',');

          for (int i = 0; i < categoryIds.length; i++) {
            categories.add(Category(
              id: int.parse(categoryIds[i]),
              name: categoryNames[i],
            ));
          }
        }
        return Item.fromMap(map, categories);
      }).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<CategoryEntity> addCategory(CategoryEntity category) async {
    final db = await dbHelper.database;
    Map<String, dynamic> row = {DBHelper.columnName: category.name};
    try {
      int id = await db.insert('categories', row);
      return CategoryEntity(name: category.name, id: id);
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<ItemEntity> addItem(
      ItemEntity item, List<CategoryEntity>? categories) async {
    final db = await dbHelper.database;
    Map<String, dynamic> row = {
      DBHelper.columnName: item.name,
      DBHelper.columnPrice: item.price
    };
    try {
      await db.transaction((txn) async {
        int itemId = await txn.insert('items', row);
        if (categories!.isNotEmpty) {
          categories.forEach((category) async {
            await db.insert('item_categories', {
              DBHelper.columnItemId: itemId,
              DBHelper.columnCategoryId: category.id
            });
          });
        }
        return itemId;
      });
      return Item(name: "test", price: 10);
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Success> deleteItem(ItemEntity item) async {
    final db = await dbHelper.database;
    try {
      final result = await db.delete('items',
          where: '${DBHelper.columnId} = ?', whereArgs: [item.id]);
      await db.delete('item_categories',
          where: '${DBHelper.columnItemId} = ?', whereArgs: [item.id]);
      return DatabaseSuccess('Item deleted with id:$result');
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<ItemEntity> updateItem(
      ItemEntity item, List<CategoryEntity> categories) async {
    final db = await dbHelper.database;
    try {
      await db.update('items', item.toMap(),
          where: '${DBHelper.columnId} = ?', whereArgs: [item.id]);
      // If categories are provided, update the 'item_categories' table
      if (categories.isNotEmpty) {
        // First, delete existing categories for the item
        await db.delete(
          'item_categories',
          where: '${DBHelper.columnItemId} = ?',
          whereArgs: [item.id],
        );

        // Insert the new categories for the item
        for (CategoryEntity category in categories) {
          await db.insert('item_categories', {
            DBHelper.columnItemId: item.id,
            DBHelper.columnCategoryId: category.id
          });
        }
      }
      return item;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
