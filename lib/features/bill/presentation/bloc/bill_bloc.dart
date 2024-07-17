import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/item.dart';
import '../../domain/usecases/usecases.dart';

part 'bill_event.dart';
part 'bill_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const throttleDuration = Duration(milliseconds: 100);

class BillBloc extends Bloc<BillEvent, BillState> {
  final GetAllItems getAllItems;
  final GetSearchItems getSearchItems;
  final GetCategories getCategories;
  final GetItemsOfCategory getItemsOfCategory;
  BillBloc(
      {required this.getAllItems,
      required this.getSearchItems,
      required this.getCategories,
      required this.getItemsOfCategory})
      : super(const BillState()) {
    on<GetItemsOfCategoryEvent>(_mapGetItemsToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetAllItemsEvent>(_mapGetAllItemsToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetSearchItemsEvent>(_mapGetSearchItemsToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetItemsToState(
      GetItemsOfCategoryEvent event, Emitter<BillState> emit) async {
    emit(state.copyWith(
      status: BillStatus.loading,
    ));
    //fetch Items based on category
    final categoryItems = await getItemsOfCategory(
        GetItemsOfCategoryParams(category: event.category));
    categoryItems
        .fold((failure) => emit(state.copyWith(status: BillStatus.error)),
            (items) async {
      emit(state.copyWith(
        status: BillStatus.loaded,
        items: items,
      ));
    });
  }

  Future<void> _mapGetAllItemsToState(
      GetAllItemsEvent event, Emitter<BillState> emit) async {
    emit(state.copyWith(
      status: BillStatus.loading,
    ));
    //fetch and emit categories
    final result = await getCategories(NoParams());
    result.fold((failure) => emit(state.copyWith(status: BillStatus.error)),
        (categories) async {
      emit(state.copyWith(
        status: BillStatus.loading,
        categories: categories,
      ));
    });
    //fetch items
    final items = await getAllItems(NoParams());
    items.fold((failure) => emit(state.copyWith(status: BillStatus.error)),
        (items) async {
      emit(state.copyWith(
        status: BillStatus.loaded,
        items: items,
      ));
    });
  }

  Future<void> _mapGetSearchItemsToState(
      GetSearchItemsEvent event, Emitter<BillState> emit) async {
    emit(state.copyWith(status: BillStatus.loading));
    final result =
        await getSearchItems(GetSearchItemsParams(search: event.search));
    result.fold(
        (failure) => emit(
            state.copyWith(status: BillStatus.error, message: failure.message)),
        (items) async {
      emit(state.copyWith(status: BillStatus.loaded, items: items));
    });
  }
}
