import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entity/category.dart';
import '../../domain/usecases/usecases.dart';
import 'inventory_events.dart';
import 'item_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ItemBloc extends Bloc<InventoryEvent, ItemState> {
  final GetCategories getCategories;
  final GetItems getItems;
  final GetAllItems getAllItems;
  final AddItem addItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;
  ItemBloc(
      {required this.getCategories,
      required this.getItems,
      required this.addItem,
      required this.getAllItems,
      required this.deleteItem,
      required this.updateItem})
      : super(const ItemState()) {
    on<GetInventoryEvent>(_mapGetInventoryToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetAllInventoryItemsEvent>(_mapGetAllInventoryItemsToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetInventoryItemsEvent>(_mapGetInventoryItemsToState,
        transformer: throttleDroppable(throttleDuration));
    on<AddItemEvent>(_mapAddItemToState,
        transformer: throttleDroppable(throttleDuration));
    on<UpdateItemEvent>(_mapUpdateItemToState,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteItemEvent>(_mapDeleteItemToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetInventoryToState(
      GetInventoryEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(
      status: ItemStatus.initial,
    ));
    //fetch and emit categories
    final result = await getCategories(NoParams());
    result.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (categories) async {
      emit(state.copyWith(
        status: ItemStatus.loading,
        categories: categories,
      ));
    });
    //fetch items
    final items = await getAllItems(NoParams());
    items.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (items) async {
      emit(state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ));
    });
  }

  Future<void> _mapGetInventoryItemsToState(
      GetInventoryItemsEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(
      status: ItemStatus.loading,
    ));
    //fetch Items based on category
    List<CategoryEntity>? selectedCategory =
        event.getInventoryItemsParams.categories;
    final categoryItems = selectedCategory!.isEmpty
        ? await getAllItems(NoParams())
        : await getItems(GetItemsParams(categories: selectedCategory));
    categoryItems
        .fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
            (items) async {
      emit(state.copyWith(
          status: ItemStatus.loaded,
          items: items,
          selectedCategories:
              selectedCategory.isEmpty ? null : selectedCategory));
    });
  }

  Future<void> _mapGetAllInventoryItemsToState(
      GetAllInventoryItemsEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(status: ItemStatus.loading, selectedCategories: null));
    final result = await getAllItems(NoParams());
    result.fold(
        (failure) => emit(
            state.copyWith(status: ItemStatus.error, message: failure.message)),
        (items) {
      emit(state.copyWith(
          status: ItemStatus.loaded, items: items, selectedCategories: null));
    });
  }

  Future<void> _mapAddItemToState(
      AddItemEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(
      status: ItemStatus.initial,
    ));
    final addResult = await addItem(
        AddItemParams(item: event.item, categories: event.categories));
    addResult.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (success) {
      emit(state.copyWith(
          status: ItemStatus.toast, message: "Item added successfully"));
    });
    //refresh
    emit(state.copyWith(
      status: ItemStatus.loading,
    ));
    final result = state.selectedCategories.isEmpty
        ? await getAllItems(NoParams())
        : await getItems(GetItemsParams(categories: state.selectedCategories));
    result.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (items) {
      emit(state.copyWith(items: items, status: ItemStatus.loaded));
    });
  }

  Future<void> _mapUpdateItemToState(
      UpdateItemEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(
      status: ItemStatus.initial,
    ));
    final updateResult = await updateItem(
        UpdateItemParams(item: event.item, categories: event.categories));
    updateResult.fold(
        (failure) => emit(
            state.copyWith(status: ItemStatus.toast, message: failure.message)),
        (success) {
      emit(state.copyWith(
          status: ItemStatus.toast, message: "Item added successfully"));
    });
    //refresh
    emit(state.copyWith(
      status: ItemStatus.loading,
    ));
    final result = state.selectedCategories.isEmpty
        ? await getAllItems(NoParams())
        : await getItems(GetItemsParams(categories: state.selectedCategories));
    result.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (items) {
      emit(state.copyWith(items: items, status: ItemStatus.loaded));
    });
  }

  Future<void> _mapDeleteItemToState(
      DeleteItemEvent event, Emitter<ItemState> emit) async {
    emit(state.copyWith(
      status: ItemStatus.initial,
    ));
    final deleteResult = await deleteItem(DeleteItemParams(item: event.item));
    deleteResult.fold(
        (failure) => emit(
            state.copyWith(status: ItemStatus.toast, message: failure.message)),
        (success) {
      emit(state.copyWith(status: ItemStatus.toast, message: success.message));
    });
    //refresh
    final result = state.selectedCategories.isEmpty
        ? await getAllItems(NoParams())
        : await getItems(GetItemsParams(categories: state.selectedCategories));
    result.fold((failure) => emit(state.copyWith(status: ItemStatus.error)),
        (items) {
      emit(state.copyWith(items: items, status: ItemStatus.loaded));
    });
  }
}
