import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/generate_pdf_repo.dart';
import '../datasources/local_datasource.dart';

class GeneratePdfRepoImpl extends GeneratePdfRepo {
  final PdfLocalDataSource pdfLocalDataSource;

  GeneratePdfRepoImpl({required this.pdfLocalDataSource});

  @override
  Future<Either<Failure, Uint8List>> generatePdf(List<ItemEntity> items) async {
    try {
      final pdfbytes = await pdfLocalDataSource.generatePdf(items);
      return Right(pdfbytes);
    } on CacheException {
      return const Left(CacheFailure('failed to generate Pdf'));
    }
  }
}
