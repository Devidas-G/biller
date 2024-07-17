import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../repos/inventory_repo.dart';

import '../../../../../core/usecases/usecase.dart';

class GetCategories implements UseCase<List<CategoryEntity>, NoParams> {
  final InventoryRepo inventoryRepo;

  GetCategories(this.inventoryRepo);
  @override
  ResultFuture<List<CategoryEntity>> call(NoParams params) async {
    return await inventoryRepo.getCategories();
  }
}
