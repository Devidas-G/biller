import 'package:flutter/material.dart';

import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';

class AddItems extends StatefulWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<ItemEntity> onSave;
  AddItems({
    super.key,
    required this.categories,
    required this.onSave,
  });

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  List<CategoryEntity> selectedCategories = [];

  final TextEditingController _categoryFieldController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Add Item"),
          actions: [
            TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    ItemEntity item = ItemEntity(
                        name: nameController.text,
                        price: double.parse(
                          priceController.text,
                        ),
                        categories: selectedCategories);
                    Future.delayed(Duration.zero, () => widget.onSave(item))
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Text("Save")),
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return DropdownMenu<CategoryEntity>(
                      width: constraints.maxWidth,
                      controller: _categoryFieldController,
                      requestFocusOnTap: true,
                      label: const Text('Categories'),
                      leadingIcon: const Icon(Icons.search),
                      enableFilter: true,
                      onSelected: (CategoryEntity? category) {
                        setState(() {
                          selectedCategories.add(category!);
                        });
                        FocusScope.of(context).unfocus();
                        _categoryFieldController.clear();
                      },
                      dropdownMenuEntries: widget.categories
                          .where((category) =>
                              !selectedCategories.contains(category))
                          .toList()
                          .map<DropdownMenuEntry<CategoryEntity>>(
                              (CategoryEntity category) {
                        return DropdownMenuEntry<CategoryEntity>(
                            value: category, label: category.name);
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      selectedCategories.length,
                      (index) {
                        CategoryEntity category = selectedCategories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add functionality for removing the category
                              setState(() {
                                selectedCategories.remove(category);
                              });
                              // onCategoryRemoved(previousCategories);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                            label: Text(category.name),
                            iconAlignment: IconAlignment.end,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
