import 'package:flutter/material.dart';
import '../../domain/entity/category.dart';
import 'widgets.dart';

class CategoriesDisplay extends StatelessWidget {
  final List<CategoryEntity> categories;
  const CategoriesDisplay({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          CategoryEntity category = categories[index];
          return CategoryTile(
              onDelete: () {},
              onEdit: () {},
              title: category.name,
              subtitle: '');
        });
  }
}
