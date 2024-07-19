import 'package:dartz/dartz.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/success.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../datasource/inventory_local_datasource.dart';
import '../../domain/repos/inventory_repo.dart';

class InventoryRepoImpl extends InventoryRepo {
  final InventoryLocalDatasource inventoryLocalDatasource;

  InventoryRepoImpl({required this.inventoryLocalDatasource});
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await inventoryLocalDatasource.getCategories();
      return Right(categories);
    } on CacheException {
      return const Left(CacheFailure('failed to get category'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems(
      List<CategoryEntity> categories) async {
    try {
      final items = await inventoryLocalDatasource.getItems(categories);
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure('failed to get Items'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    try {
      final items = await inventoryLocalDatasource.getAllItems();
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure('failed to get Items'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(
      CategoryEntity category) async {
    try {
      final CategoryEntity resultcategory =
          await inventoryLocalDatasource.addCategory(category);
      return Right(resultcategory);
    } on CacheException {
      return const Left(CacheFailure('failed to add category'));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> addItem(
      ItemEntity item, List<CategoryEntity>? categories) async {
    try {
      final result = await inventoryLocalDatasource.addItem(item, categories);
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure('failed to add Item'));
    } on UnknownException {
      return const Left(CacheFailure('failed to add Item'));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteItem(ItemEntity item) async {
    try {
      final result = await inventoryLocalDatasource.deleteItem(item);
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure('failed to delete Item'));
    } on UnknownException {
      return const Left(CacheFailure('failed to delete Item'));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> updateItem(
      ItemEntity item, List<CategoryEntity> categories) async {
    try {
      final result =
          await inventoryLocalDatasource.updateItem(item, categories);
      return Right(result);
    } on CacheException {
      return const Left(CacheFailure('failed to update Item'));
    } on UnknownException {
      return const Left(CacheFailure('failed to update Item'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> deleteCategory(
      CategoryEntity category) async {
    try {
      final CategoryEntity resultcategory =
          await inventoryLocalDatasource.deleteCategory(category);
      return Right(resultcategory);
    } on CacheException {
      return const Left(CacheFailure('failed to delete category'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> editCategory(
      CategoryEntity category) async {
    try {
      final CategoryEntity resultcategory =
          await inventoryLocalDatasource.editCategory(category);
      return Right(resultcategory);
    } on CacheException {
      return const Left(CacheFailure('failed to edit category'));
    }
  }
}
