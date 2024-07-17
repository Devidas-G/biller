import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/item.dart';

abstract class GeneratePdfRepo {
  Future<Either<Failure, Uint8List>> generatePdf(List<ItemEntity> items);
}
