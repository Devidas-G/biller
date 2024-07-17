import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../di.dart';
import '../../../../widgets/message.dart';
import '../../domain/entities/item.dart';
import '../bloc/pdf_bloc.dart';
import '../widgets/widgets.dart';

class PdfGenerationPage extends StatefulWidget {
  final List<ItemEntity> items;

  const PdfGenerationPage({super.key, required this.items});
  @override
  createState() => _PdfGenerationPage();
}

class _PdfGenerationPage extends State<PdfGenerationPage> {
  PdfBloc pdfBloc = sl<PdfBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => pdfBloc..add(GeneratePdfEvent(items: widget.items)),
      child: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          switch (state.status) {
            case PdfStatus.initial || PdfStatus.loading:
              return const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            case PdfStatus.error:
              return MessageDisplay(
                message: state.message,
              );
            case PdfStatus.loaded || PdfStatus.toast:
              return Column(
                children: [
                  DisplayPdf(
                    pdfBytes: state.pdfBytes!,
                  ),
                  OptionsBar(
                    onPrint: () async {
                      await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async =>
                            state.pdfBytes!,
                      );
                    },
                    onShare: () async {
                      // Get the temporary directory
                      final directory = await getTemporaryDirectory();
                      // Create a file path
                      final filePath = '${directory.path}/bill.pdf';
                      // Write the PDF bytes to the file
                      final file = File(filePath);
                      await file.writeAsBytes(state.pdfBytes!);
                      final XFile xFile = XFile(file.path);
                      // Share the file
                      await Share.shareXFiles([xFile], text: 'pdf of bill');
                    },
                  )
                ],
              );
            default:
              return const MessageDisplay(
                message: 'Something went wrong',
              );
          }
        },
      ),
    );
  }
}
