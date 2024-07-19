import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../repos/inventory_repo.dart';

class EditCategory implements UseCase<CategoryEntity, EditCategoryParams> {
  final InventoryRepo inventoryRepo;

  EditCategory(this.inventoryRepo);
  @override
  ResultFuture<CategoryEntity> call(EditCategoryParams params) async {
    return await inventoryRepo.editCategory(params.category);
  }
}

class EditCategoryParams extends Equatable {
  final CategoryEntity category;

  EditCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
