import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/item.dart';
import '../repositories/generate_pdf_repo.dart';

class GeneratePdf implements UseCase<Uint8List, GeneratePdfParams> {
  final GeneratePdfRepo repo;

  GeneratePdf(this.repo);
  @override
  ResultFuture<Uint8List> call(GeneratePdfParams params) async {
    return await repo.generatePdf(params.items);
  }
}

class GeneratePdfParams extends Equatable {
  final List<ItemEntity> items;

  GeneratePdfParams({required this.items});
  @override
  List<Object?> get props => [items];
}
