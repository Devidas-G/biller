// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entity/item.dart';

class ItemGrid extends StatelessWidget {
  final List<ItemEntity> items;
  final ValueChanged<ItemEntity> onPressed;

  ItemGrid({
    super.key,
    required this.items,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns in the grid
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            ItemEntity item = items[index];
            return ElevatedButton(
              onPressed: () => onPressed(item),
              child: Text(item.name),
            );
          }),
    );
  }
}
