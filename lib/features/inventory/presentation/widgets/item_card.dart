// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemCard extends StatelessWidget {
  VoidCallback onClick;
  String title;
  String price;

  ItemCard({
    Key? key,
    required this.onClick,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onClick,
        child: Column(
          children: [
            Expanded(child: Container()),
            ListTile(
              dense: true,
              title: Text(title),
              subtitle: Text("price: $price"),
            ),
          ],
        ),
      ),
    );
  }
}
