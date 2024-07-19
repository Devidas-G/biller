import 'package:flutter/material.dart';
import '../../domain/entity/category.dart';
import 'widgets.dart';

class CategoriesDisplay extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onDelete;
  final ValueChanged<CategoryEntity> onEdit;
  const CategoriesDisplay({
    super.key,
    required this.categories,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Text("Add categories to get started"),
      );
    } else {
      return ListView.builder(
          itemCount: categories.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            CategoryEntity category = categories[index];
            return CategoryTile(
                onDelete: () => onDelete(category),
                onEdit: () => onEdit(category),
                title: category.name,
                subtitle: '');
          });
    }
  }
}
