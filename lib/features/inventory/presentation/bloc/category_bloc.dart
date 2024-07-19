import 'package:biller/features/inventory/domain/usecases/usecases.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entity/category.dart';
import 'category_state.dart';
import 'inventory_events.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CategoryBloc extends Bloc<InventoryEvent, CategoryBlocState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final DeleteCategory deleteCategory;
  final EditCategory editCategory;
  CategoryBloc(
      {required this.getCategories,
      required this.addCategory,
      required this.deleteCategory,
      required this.editCategory})
      : super(const CategoryBlocState()) {
    on<GetCategoriesEvent>(_mapGetCategoriesToState,
        transformer: throttleDroppable(throttleDuration));
    on<AddCategoryEvent>(_mapAddCategoryToState,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteCategoryEvent>(_mapDeleteCategoryToState,
        transformer: throttleDroppable(throttleDuration));
    on<EditCategoryEvent>(_mapEditCategoryToState,
        transformer: throttleDroppable(throttleDuration));
  }
  Future<void> _mapGetCategoriesToState(
      GetCategoriesEvent event, Emitter<CategoryBlocState> emit) async {
    emit(state.copyWith(
      status: CategoryStatus.initial,
    ));
    //fetch and emit categories
    final result = await getCategories(NoParams());
    result.fold(
        (failure) => emit(state.copyWith(
            status: CategoryStatus.error,
            message: failure.message)), (categories) async {
      if (categories.isEmpty) {
        emit(state.copyWith(status: CategoryStatus.loaded));
      } else {
        emit(state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        ));
      }
    });
  }

  Future<void> _mapAddCategoryToState(
      AddCategoryEvent event, Emitter<CategoryBlocState> emit) async {
    emit(state.copyWith(
      status: CategoryStatus.initial,
    ));
    //Add Category to database
    late CategoryEntity selectedCategory;
    final resultCategory =
        await addCategory(AddCategoryParams(category: event.categoryEntity));
    resultCategory.fold(
        (failure) => emit(state.copyWith(
            status: CategoryStatus.toast,
            message: "${failure.message}")), (category) {
      selectedCategory = category;
    });
    final result = await getCategories(NoParams());
    result.fold((failure) => emit(state.copyWith(status: CategoryStatus.error)),
        (categories) async {
      if (categories.isEmpty) {
        emit(state.copyWith(status: CategoryStatus.loaded));
      } else {
        emit(state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        ));
      }
    });
  }

  Future<void> _mapDeleteCategoryToState(
      DeleteCategoryEvent event, Emitter<CategoryBlocState> emit) async {
    emit(state.copyWith(
      status: CategoryStatus.initial,
    ));
    //Add Category to database
    final resultCategory = await deleteCategory(
        DeleteCategoryParams(category: event.categoryEntity));
    resultCategory.fold(
        (failure) => emit(state.copyWith(
            status: CategoryStatus.toast, message: "${failure.message}")),
        (category) => emit(state.copyWith(
            status: CategoryStatus.toast,
            message: "Category add succesfully")));
    final result = await getCategories(NoParams());
    result.fold((failure) => emit(state.copyWith(status: CategoryStatus.error)),
        (categories) async {
      if (categories.isEmpty) {
        emit(state.copyWith(status: CategoryStatus.loaded));
      } else {
        emit(state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        ));
      }
    });
  }

  Future<void> _mapEditCategoryToState(
      EditCategoryEvent event, Emitter<CategoryBlocState> emit) async {
    emit(state.copyWith(
      status: CategoryStatus.initial,
    ));
    //Add Category to database
    final resultCategory =
        await editCategory(EditCategoryParams(category: event.categoryEntity));
    resultCategory.fold(
        (failure) => emit(state.copyWith(
            status: CategoryStatus.toast, message: "${failure.message}")),
        (category) => emit(state.copyWith(
            status: CategoryStatus.toast,
            message: "Category edited succesfully")));
    final result = await getCategories(NoParams());
    result.fold((failure) => emit(state.copyWith(status: CategoryStatus.error)),
        (categories) async {
      if (categories.isEmpty) {
        emit(state.copyWith(status: CategoryStatus.loaded));
      } else {
        emit(state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        ));
      }
    });
  }
}
