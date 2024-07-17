import 'package:equatable/equatable.dart';
import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../entity/item.dart';
import '../../repos/inventory_repo.dart';

import '../../../../../core/usecases/usecase.dart';

class GetAllItems implements UseCase<List<ItemEntity>, NoParams> {
  final InventoryRepo inventoryRepo;

  GetAllItems(this.inventoryRepo);
  @override
  ResultFuture<List<ItemEntity>> call(NoParams) async {
    return await inventoryRepo.getAllItems();
  }
}
