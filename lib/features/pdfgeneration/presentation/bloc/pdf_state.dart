part of 'pdf_bloc.dart';

enum PdfStatus { initial, loading, loaded, error, toast }

class PdfState extends Equatable {
  final PdfStatus status;
  final Uint8List? pdfBytes;
  final String message;
  PdfState({
    this.status = PdfStatus.initial,
    this.pdfBytes,
    this.message = '',
  });

  @override
  List<Object> get props => [status, pdfBytes ?? Uint8List(0), message];

  PdfState copyWith({PdfStatus? status, Uint8List? pdfBytes, String? message}) {
    return PdfState(
        status: status ?? this.status,
        pdfBytes: pdfBytes ?? this.pdfBytes,
        message: message ?? this.message);
  }
}
