import 'package:equatable/equatable.dart';

import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

//! Get Item
class GetInventoryItemsEvent extends InventoryEvent {
  final GetInventoryItemsParams getInventoryItemsParams;
  const GetInventoryItemsEvent(this.getInventoryItemsParams);
  @override
  List<Object> get props => [getInventoryItemsParams];
}

class GetAllInventoryItemsEvent extends InventoryEvent {
  const GetAllInventoryItemsEvent();
  @override
  List<Object> get props => [];
}

class GetInventoryEvent extends InventoryEvent {
  const GetInventoryEvent();
  @override
  List<Object> get props => [];
}

//! Add Item
class AddItemEvent extends InventoryEvent {
  final ItemEntity item;
  final List<CategoryEntity>? categories;

  AddItemEvent({required this.item, this.categories});
  @override
  List<Object> get props => [item, categories!];
}

//! Update Item
class UpdateItemEvent extends InventoryEvent {
  final ItemEntity item;
  final List<CategoryEntity> categories;

  UpdateItemEvent({required this.item, required this.categories});
  @override
  List<Object> get props => [item, categories];
}

//! Delete Item
class DeleteItemEvent extends InventoryEvent {
  final ItemEntity item;

  DeleteItemEvent({required this.item});
  @override
  List<Object> get props => [item];
}

//! Get Categories
class GetCategoriesEvent extends InventoryEvent {
  @override
  List<Object> get props => [];
}

//! Add Category
class AddCategoryEvent extends InventoryEvent {
  final CategoryEntity categoryEntity;
  const AddCategoryEvent({required this.categoryEntity});
  @override
  List<Object> get props => [categoryEntity];
}

//!Params

class GetInventoryItemsParams {
  List<CategoryEntity>? categories;
  GetInventoryItemsParams({
    required this.categories,
  });
}
