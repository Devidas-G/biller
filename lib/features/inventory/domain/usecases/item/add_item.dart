import 'package:equatable/equatable.dart';
import '../../entity/category.dart';
import '../../entity/item.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../repos/inventory_repo.dart';

class AddItem implements UseCase<ItemEntity, AddItemParams> {
  final InventoryRepo inventoryRepo;

  AddItem(this.inventoryRepo);
  @override
  ResultFuture<ItemEntity> call(AddItemParams params) async {
    return await inventoryRepo.addItem(params.item, params.categories);
  }
}

class AddItemParams extends Equatable {
  final ItemEntity item;
  final List<CategoryEntity>? categories;

  AddItemParams({required this.item, this.categories});

  @override
  List<Object> get props => [item, categories!];
}
