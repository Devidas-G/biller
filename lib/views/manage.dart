import 'package:flutter/material.dart';

import '../features/inventory/presentation/view/categories.dart';
import '../features/inventory/presentation/view/items.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    Map<String, Function()> actions = {
      'Items': () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Inventory(),
          ),
        );
      },
      'Categories': () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoriesPage(),
          ),
        );
      }
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage"),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: actions.length,
            itemBuilder: (context, index) {
              String title = actions.keys.elementAt(index);
              dynamic Function()? navigator = actions.values.elementAt(index);
              return ListTile(
                leading: Icon(Icons.inventory),
                title: Text(title),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: navigator,
              );
            }),
      ),
    );
  }
}
