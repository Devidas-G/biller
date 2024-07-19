import 'package:flutter/material.dart';

import '../../domain/entity/category.dart';

class EditCategory extends StatefulWidget {
  final CategoryEntity category;
  final ValueChanged<CategoryEntity> onSave;
  const EditCategory({super.key, required this.category, required this.onSave});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController.value = TextEditingValue(text: widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              CategoryEntity newCategory =
                  widget.category.copyWith(name: nameController.text);
              Future.delayed(Duration.zero, () {
                widget.onSave(newCategory);
              }).then((value) {
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ],
    );
  }
}
