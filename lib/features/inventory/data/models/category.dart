import '../../domain/entity/category.dart';

class Category extends CategoryEntity {
  Category({required super.name, required super.id});

  // Factory method to create a Category from a map (e.g., from a database row)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }

  // Method to convert a Category to a map (e.g., for inserting into the database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
