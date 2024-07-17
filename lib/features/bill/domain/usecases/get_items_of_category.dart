import 'package:equatable/equatable.dart';
import '../repos/bill_repo.dart';
import '../../../../core/utils/typedef.dart';

import '../../../../core/usecases/usecase.dart';
import '../entity/category.dart';
import '../entity/item.dart';

class GetItemsOfCategory
    implements UseCase<List<ItemEntity>, GetItemsOfCategoryParams> {
  final BillRepo billRepo;

  GetItemsOfCategory(this.billRepo);
  @override
  ResultFuture<List<ItemEntity>> call(GetItemsOfCategoryParams params) async {
    return await billRepo.getItemsOfCategory(params.category);
  }
}

class GetItemsOfCategoryParams extends Equatable {
  final CategoryEntity category;

  const GetItemsOfCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
