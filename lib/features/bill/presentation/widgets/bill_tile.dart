import 'package:flutter/material.dart';

class BillTile extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onCancel;

  const BillTile(
      {super.key,
      required this.title,
      required this.price,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(price),
      trailing: IconButton(
        icon: const Icon(Icons.cancel_outlined),
        onPressed: onCancel,
      ),
    );
  }
}
