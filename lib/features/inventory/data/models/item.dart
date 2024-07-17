import '../../domain/entity/item.dart';
import 'category.dart';

class Item extends ItemEntity {
  Item({required super.name, required super.price, super.id, super.categories});

  factory Item.fromMap(Map<String, dynamic> map, List<Category> categories) {
    return Item(
        name: map['name'],
        price: map['price'],
        id: map['id'],
        categories: categories);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price.toString(),
    };
  }
}
