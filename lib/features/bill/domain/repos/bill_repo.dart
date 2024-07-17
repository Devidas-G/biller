import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entity/category.dart';
import '../entity/item.dart';

abstract class BillRepo {
  Future<Either<Failure, List<ItemEntity>>> getAllItems();
  Future<Either<Failure, List<ItemEntity>>> getItemsOfCategory(
      CategoryEntity category);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ItemEntity>>> getSearchItems(String search);
}
