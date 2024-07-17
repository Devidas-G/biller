import 'package:equatable/equatable.dart';
import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../entity/item.dart';
import '../../repos/inventory_repo.dart';

import '../../../../../core/usecases/usecase.dart';

class GetItems implements UseCase<List<ItemEntity>, GetItemsParams> {
  final InventoryRepo inventoryRepo;

  GetItems(this.inventoryRepo);
  @override
  ResultFuture<List<ItemEntity>> call(GetItemsParams params) async {
    return await inventoryRepo.getItems(params.categories);
  }
}

class GetItemsParams extends Equatable {
  final List<CategoryEntity> categories;

  const GetItemsParams({required this.categories});

  @override
  List<Object> get props => [categories];
}
