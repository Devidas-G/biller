import '../../../../core/utils/typedef.dart';

import '../../../../core/usecases/usecase.dart';
import '../entity/item.dart';
import '../repos/bill_repo.dart';

class GetAllItems implements UseCase<List<ItemEntity>, NoParams> {
  final BillRepo billRepo;

  GetAllItems(this.billRepo);
  @override
  ResultFuture<List<ItemEntity>> call(NoParams) async {
    return await billRepo.getAllItems();
  }
}
