import 'package:equatable/equatable.dart';
import '../../entity/category.dart';
import '../../entity/item.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../repos/inventory_repo.dart';

class UpdateItem implements UseCase<ItemEntity, UpdateItemParams> {
  final InventoryRepo inventoryRepo;

  UpdateItem(this.inventoryRepo);
  @override
  ResultFuture<ItemEntity> call(UpdateItemParams params) async {
    return await inventoryRepo.updateItem(params.item, params.categories);
  }
}

class UpdateItemParams extends Equatable {
  final ItemEntity item;
  final List<CategoryEntity> categories;

  UpdateItemParams({required this.item, required this.categories});

  @override
  List<Object> get props => [item, categories];
}
