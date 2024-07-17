import 'package:equatable/equatable.dart';
import '../repos/bill_repo.dart';
import '../../../../core/utils/typedef.dart';

import '../../../../core/usecases/usecase.dart';
import '../entity/item.dart';

class GetSearchItems
    implements UseCase<List<ItemEntity>, GetSearchItemsParams> {
  final BillRepo billRepo;

  GetSearchItems(this.billRepo);
  @override
  ResultFuture<List<ItemEntity>> call(GetSearchItemsParams params) async {
    return await billRepo.getSearchItems(params.search);
  }
}

class GetSearchItemsParams extends Equatable {
  final String search;

  const GetSearchItemsParams({required this.search});

  @override
  List<Object> get props => [search];
}
