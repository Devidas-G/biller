import 'package:equatable/equatable.dart';

import 'category.dart';

class ItemEntity extends Equatable {
  final int? id;
  final String name;
  final double price;
  final List<CategoryEntity> categories;
  const ItemEntity(
      {required this.name,
      required this.price,
      this.id,
      this.categories = const []});

  @override
  List<Object?> get props => [name, price, id, categories];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  ItemEntity copyWith({
    int? id,
    String? name,
    double? price,
    List<CategoryEntity>? categories,
  }) {
    return ItemEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        categories: categories ?? this.categories);
  }
}
