import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../repos/inventory_repo.dart';

class DeleteCategory implements UseCase<CategoryEntity, DeleteCategoryParams> {
  final InventoryRepo inventoryRepo;

  DeleteCategory(this.inventoryRepo);
  @override
  ResultFuture<CategoryEntity> call(DeleteCategoryParams params) async {
    return await inventoryRepo.deleteCategory(params.category);
  }
}

class DeleteCategoryParams extends Equatable {
  final CategoryEntity category;

  DeleteCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
