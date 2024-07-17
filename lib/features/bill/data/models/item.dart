import '../../domain/entity/item.dart';

class Item extends ItemEntity {
  Item({required super.name, required super.price, super.id});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(name: map['name'], price: map['price'], id: map['id']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }
}
