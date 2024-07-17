part of 'pdf_bloc.dart';

sealed class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class GeneratePdfEvent extends PdfEvent {
  final List<ItemEntity> items;

  GeneratePdfEvent({required this.items});
  @override
  List<Object> get props => [items];
}
