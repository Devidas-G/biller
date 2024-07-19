import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String name;
  final int? id;
  const CategoryEntity({required this.name, this.id});
  @override
  List<Object?> get props => [name, id];

  CategoryEntity copyWith({
    String? name,
    int? id,
  }) {
    return CategoryEntity(name: name ?? this.name, id: id ?? this.id);
  }
}
