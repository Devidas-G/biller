import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/success.dart';
import '../entity/category.dart';
import '../entity/item.dart';

abstract class InventoryRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category);
  Future<Either<Failure, List<ItemEntity>>> getItems(
      List<CategoryEntity> categories);
  Future<Either<Failure, List<ItemEntity>>> getAllItems();
  Future<Either<Failure, ItemEntity>> addItem(
      ItemEntity item, List<CategoryEntity>? categories);
  Future<Either<Failure, ItemEntity>> updateItem(
      ItemEntity item, List<CategoryEntity> categories);
  Future<Either<Failure, Success>> deleteItem(ItemEntity item);
}
