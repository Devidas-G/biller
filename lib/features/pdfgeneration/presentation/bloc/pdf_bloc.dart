import 'dart:typed_data';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/generate_pdf.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const throttleDuration = Duration(milliseconds: 100);

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final GeneratePdf generatePdf;
  PdfBloc({required this.generatePdf}) : super(PdfState()) {
    on<GeneratePdfEvent>(_mapGeneratePdfToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGeneratePdfToState(
      GeneratePdfEvent event, Emitter<PdfState> emit) async {
    emit(state.copyWith(
      status: PdfStatus.loading,
    ));
    final result = await generatePdf(GeneratePdfParams(items: event.items));
    result.fold(
        (failure) => emit(state.copyWith(
              status: PdfStatus.error,
            )), (pdfBytes) {
      emit(state.copyWith(status: PdfStatus.loaded, pdfBytes: pdfBytes));
    });
  }
}
