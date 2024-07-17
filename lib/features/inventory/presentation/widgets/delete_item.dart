import 'package:flutter/material.dart';

class DeleteItem extends StatelessWidget {
  final String name;
  final String price;
  final VoidCallback onDelete;
  const DeleteItem(
      {super.key,
      required this.name,
      required this.price,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to delete $name?'),
      content: Text("Price: $price"),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Future.delayed(Duration.zero, () {
              onDelete();
            }).then((value) {
              Navigator.of(context).pop();
            });
          },
        ),
      ],
    );
  }
}
