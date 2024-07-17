import 'package:flutter/material.dart';

import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import 'widgets.dart';

class ItemsDisplay extends StatefulWidget {
  final List<ItemEntity> items;
  final List<CategoryEntity> categories;
  final List<CategoryEntity>? selectedCategories;
  final ValueChanged<ItemEntity> onDelete;
  final ValueChanged<ItemEntity> onEdit;
  final ValueChanged<List<CategoryEntity>> onCategorySelected;
  final ValueChanged<List<CategoryEntity>> onCategoryRemoved;
  const ItemsDisplay(
      {super.key,
      required this.items,
      required this.onDelete,
      required this.onEdit,
      required this.categories,
      required this.selectedCategories,
      required this.onCategorySelected,
      required this.onCategoryRemoved});

  @override
  State<ItemsDisplay> createState() => _ItemsDisplayState();
}

class _ItemsDisplayState extends State<ItemsDisplay> {
  bool _isGrid = false;
  final TextEditingController _categoryFieldController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          title: LayoutBuilder(builder: (context, constraints) {
            List<CategoryEntity> mapCategories = widget.categories
                .where((category) =>
                    !widget.selectedCategories!.contains(category))
                .toList();
            CategoryEntity? selectedCategory;
            return DropdownMenu<CategoryEntity>(
              width: constraints.maxWidth,
              controller: _categoryFieldController,
              requestFocusOnTap: true,
              label: const Text('Categories'),
              leadingIcon: const Icon(Icons.search),
              enableFilter: true,
              onSelected: (CategoryEntity? category) {
                setState(() {
                  selectedCategory = category;
                });
                FocusScope.of(context).unfocus();
                _categoryFieldController.clear();
                if (selectedCategory != null) {
                  List<CategoryEntity> newSelectedCategories = [
                    selectedCategory!,
                    ...?widget.selectedCategories
                  ];
                  widget.onCategorySelected(newSelectedCategories);
                  setState(() {
                    selectedCategory = null;
                  });
                }
              },
              dropdownMenuEntries: mapCategories
                  .map<DropdownMenuEntry<CategoryEntity>>(
                      (CategoryEntity category) {
                return DropdownMenuEntry<CategoryEntity>(
                    value: category, label: category.name);
              }).toList(),
            );
          }),
        ),
        ListTile(
          minTileHeight: 30,
          title: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.selectedCategories == null
                    ? 0
                    : widget.selectedCategories!.length,
                (index) {
                  CategoryEntity category = widget.selectedCategories![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality for removing the category
                        List<CategoryEntity>? previousCategories =
                            widget.selectedCategories;
                        previousCategories!.remove(category);
                        widget.onCategoryRemoved(previousCategories);
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
          trailing: IconButton(
            icon: Icon(_isGrid
                ? Icons.grid_view_rounded
                : Icons.format_list_bulleted_rounded),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ),
        Expanded(
          child: (() {
            if (_isGrid) {
              return GridView.builder(
                  itemCount: widget.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 1, // Aspect ratio for each card
                  ),
                  itemBuilder: (context, index) {
                    ItemEntity item = widget.items[index];
                    return ItemCard(
                        onClick: () {},
                        title: item.name,
                        price: item.price.toString());
                  });
            } else {
              return ListView.builder(
                  itemCount: widget.items.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    ItemEntity item = widget.items[index];
                    return ItemTile(
                      onDelete: () => widget.onDelete(item),
                      title: item.name,
                      subtitle: item.price.toString(),
                      onEdit: () => widget.onEdit(item),
                    );
                  });
            }
          }()),
        ),
      ],
    );
  }
}
