import '../repos/bill_repo.dart';
import '../../../../core/utils/typedef.dart';
import '../entity/category.dart';
import '../../../../core/usecases/usecase.dart';

class GetCategories implements UseCase<List<CategoryEntity>, NoParams> {
  final BillRepo billRepo;

  GetCategories(this.billRepo);
  @override
  ResultFuture<List<CategoryEntity>> call(NoParams params) async {
    return await billRepo.getCategories();
  }
}
