import 'package:flutter/foundation.dart';
import '../domain/entity/category.dart';
import '../domain/entity/item.dart';

class BillProvider extends ChangeNotifier {
  List<ItemEntity> _tempBillItems = [];
  set tempBillItems(List<ItemEntity> newTempBillItems) {
    _tempBillItems = newTempBillItems;
    notifyListeners();
  }

  List<ItemEntity> get tempBillItems => _tempBillItems;

  void addTempBillItem(ItemEntity newItem) {
    _tempBillItems.add(newItem);
    _updateTotal();
    notifyListeners();
  }

  void removeTempBillItem(ItemEntity item) {
    _tempBillItems.remove(item);
    _updateTotal();
    notifyListeners();
  }

  String _total = '0.0';
  String get total => _total;
  set total(String newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void _updateTotal() {
    double newTotal = _tempBillItems.fold(0.0, (sum, item) => sum + item.price);
    _total = newTotal.toStringAsFixed(2);
  }

  //! categories
  List<CategoryEntity> _selectCategories = [];
  List<CategoryEntity> get selectCategories => _selectCategories;
  set selectCategories(List<CategoryEntity> newCategories) {
    _selectCategories = newCategories;
    notifyListeners();
  }
}
