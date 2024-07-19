// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../domain/entity/item.dart';
import 'widgets.dart';

class BillList extends StatelessWidget {
  final List<ItemEntity> items;
  final ValueChanged<ItemEntity> onPressed;
  const BillList({super.key, required this.items, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (() {
        if (items.isEmpty) {
          return const Center(child: Text("Select Items to get Started"));
        } else {
          return ListView.builder(
              itemCount: items.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                ItemEntity item = items[index];
                return BillTile(
                    title: item.name,
                    price: item.price.toString(),
                    onCancel: () => onPressed(item));
              });
        }
      }()),
    );
  }
}
