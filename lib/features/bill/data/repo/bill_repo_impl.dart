import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../../domain/repos/bill_repo.dart';
import '../datasource/local_datasource.dart';

class BillRepoImpl extends BillRepo {
  final BillLocalDataSource billLocalDataSource;

  BillRepoImpl({required this.billLocalDataSource});
  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    try {
      final items = await billLocalDataSource.getAllItems();
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure('failed to get Items'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getSearchItems(
      String search) async {
    try {
      final items = await billLocalDataSource.getSearchItems(search);
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure('failed to get Items'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await billLocalDataSource.getCategories();
      return Right(categories);
    } on CacheException {
      return const Left(CacheFailure('failed to get category'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsOfCategory(
      CategoryEntity category) async {
    try {
      final items = await billLocalDataSource.getItemsOfCategory(category);
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure('failed to get Items'));
    }
  }
}
