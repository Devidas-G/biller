import 'dart:typed_data';

import '../../domain/entities/item.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PdfLocalDataSource {
  Future<Uint8List> generatePdf(List<ItemEntity> items);
}

class PdfLocalDataSourceImpl implements PdfLocalDataSource {
  @override
  Future<Uint8List> generatePdf(List<ItemEntity> items) async {
    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill/Receipt',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Name', 'Price'],
                data: items
                    .map((item) => [item.name, item.price.toString()])
                    .toList(),
              ),
              pw.Divider(),
              pw.Text(
                'Total: \$${items.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
