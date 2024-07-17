import 'package:equatable/equatable.dart';

import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';

enum ItemStatus { initial, loading, loaded, error, toast }

final class ItemState extends Equatable {
  const ItemState({
    this.status = ItemStatus.initial,
    this.items = const [],
    this.categories = const [],
    this.selectedCategories = const [],
    this.message = "",
  });
  final ItemStatus status;
  final List<ItemEntity> items;
  final List<CategoryEntity> categories;
  final List<CategoryEntity> selectedCategories;
  final String message;
  @override
  List<Object?> get props =>
      [status, items, categories, selectedCategories, message];

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? selectedCategories,
    String? message,
  }) {
    return ItemState(
        status: status ?? this.status,
        items: items ?? this.items,
        categories: categories ?? this.categories,
        selectedCategories: selectedCategories ?? this.selectedCategories,
        message: message ?? this.message);
  }
}
