import 'package:equatable/equatable.dart';

import '../../domain/entity/category.dart';

enum CategoryStatus { initial, loading, loaded, error, toast }

class CategoryBlocState extends Equatable {
  const CategoryBlocState(
      {this.status = CategoryStatus.initial,
      this.categories = const [],
      this.message = ''});
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final String message;
  @override
  List<Object?> get props => [status, categories, message];

  CategoryBlocState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    String? message,
  }) {
    return CategoryBlocState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        message: message ?? this.message);
  }
}
