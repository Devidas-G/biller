import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/typedef.dart';
import '../../entity/category.dart';
import '../../repos/inventory_repo.dart';

class AddCategory implements UseCase<CategoryEntity, AddCategoryParams> {
  final InventoryRepo inventoryRepo;

  AddCategory(this.inventoryRepo);
  @override
  ResultFuture<CategoryEntity> call(AddCategoryParams params) async {
    return await inventoryRepo.addCategory(params.category);
  }
}

class AddCategoryParams extends Equatable {
  final CategoryEntity category;

  AddCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
