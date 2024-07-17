import 'package:equatable/equatable.dart';
import '../../../../../core/errors/success.dart';
import '../../entity/item.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../repos/inventory_repo.dart';

class DeleteItem implements UseCase<Success, DeleteItemParams> {
  final InventoryRepo inventoryRepo;

  DeleteItem(this.inventoryRepo);
  @override
  ResultFuture<Success> call(DeleteItemParams params) async {
    return await inventoryRepo.deleteItem(params.item);
  }
}

class DeleteItemParams extends Equatable {
  final ItemEntity item;

  const DeleteItemParams({required this.item});

  @override
  List<Object> get props => [item];
}
