import 'package:flutter/foundation.dart';

import '../domain/entity/category.dart';

class InventoryProvider extends ChangeNotifier {
  List<CategoryEntity> _toBeAddCategories = [];
  List<CategoryEntity> get toBeAddCategories => _toBeAddCategories;
  set toBeAddCategories(List<CategoryEntity> newCategories) {
    _toBeAddCategories = newCategories;
    notifyListeners();
  }
}
