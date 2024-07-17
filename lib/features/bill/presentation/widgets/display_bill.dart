import 'package:flutter/material.dart';

import '../../../pdfgeneration/presentation/pages/pdfgeneration_page.dart';
import '../../domain/entity/item.dart';
import 'widgets.dart';

class DisplayBill extends StatelessWidget {
  final List<ItemEntity> selectionItems;
  final List<ItemEntity> tempBillItems;
  final ValueChanged<ItemEntity> onItemSelected;
  final ValueChanged<ItemEntity> onItemRemoved;
  final String total;
  const DisplayBill(
      {super.key,
      required this.selectionItems,
      required this.tempBillItems,
      required this.onItemSelected,
      required this.onItemRemoved,
      required this.total});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          child: ItemGrid(
            items: selectionItems,
            onPressed: onItemSelected,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
            child: Column(
          children: [
            const ListTile(
              dense: true,
              minTileHeight: 20,
              title: Text("Bill"),
            ),
            BillList(
              items: tempBillItems,
              onPressed: onItemRemoved,
            ),
          ],
        )),
        ListTile(
          title: Text("Total"),
          subtitle: Text(total),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(),
            onPressed: tempBillItems.isEmpty
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      showDragHandle: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (BuildContext context) {
                        return PdfGenerationPage(
                          items: tempBillItems,
                        );
                      },
                    );
                  },
            child: Text("Bill"),
          ),
        ),
      ],
    );
  }
}
