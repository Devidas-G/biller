part of 'bill_bloc.dart';

enum BillStatus { initial, loading, loaded, error, toast }

class BillState extends Equatable {
  final BillStatus status;
  final String message;
  final List<ItemEntity> items;
  final List<CategoryEntity> categories;
  const BillState(
      {this.status = BillStatus.initial,
      this.message = '',
      this.items = const [],
      this.categories = const []});

  @override
  List<Object> get props => [status, message, items, categories];

  BillState copyWith({
    BillStatus? status,
    String? message,
    List<ItemEntity>? items,
    List<CategoryEntity>? categories,
  }) {
    return BillState(
        status: status ?? this.status,
        message: message ?? this.message,
        items: items ?? this.items,
        categories: categories ?? this.categories);
  }
}
