part of 'bill_bloc.dart';

sealed class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object> get props => [];
}

class GetItemsOfCategoryEvent extends BillEvent {
  final CategoryEntity category;
  const GetItemsOfCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

class GetAllItemsEvent extends BillEvent {
  const GetAllItemsEvent();
  @override
  List<Object> get props => [];
}

class GetSearchItemsEvent extends BillEvent {
  final String search;
  const GetSearchItemsEvent(this.search);
  @override
  List<Object> get props => [search];
}
