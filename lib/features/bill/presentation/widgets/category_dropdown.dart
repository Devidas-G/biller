import 'package:flutter/material.dart';

import '../../domain/entity/category.dart';

class CategoryDropdown extends StatefulWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity?> onChanged;
  const CategoryDropdown(
      {super.key, required this.categories, required this.onChanged});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  CategoryEntity? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryEntity>(
      hint: Text('All'), // Initial hint text
      value: _selectedCategory,
      items: [
        DropdownMenuItem<CategoryEntity>(
          value: null, // Represents the "All" option
          child: Text('All'),
        ),
        ...widget.categories.map((category) {
          return DropdownMenuItem<CategoryEntity>(
            value: category,
            child: Text(category.name),
          );
        }).toList(),
      ],
      onChanged: (CategoryEntity? value) {
        setState(() {
          _selectedCategory = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
