import 'package:flutter/material.dart';

class cartitem {
  final String title;
  String? id;
  final double price;
  final int quntity;

  cartitem({
    required this.title,
    required this.id,
    required this.price,
    required this.quntity,
  });
}

class cart with ChangeNotifier {
  Map<String, cartitem> _items = {};
  Map<String, cartitem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalamount {
    double totalprice = 0.0;
    _items.forEach((key, cartitem) {
      totalprice += cartitem.quntity * cartitem.price;
    });
    return totalprice;
  }

  void additem(String productid, String title, double price) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (existingitem) => cartitem(
              title: existingitem.title,
              id: existingitem.id,
              price: existingitem.price,
              quntity: existingitem.quntity + 1));
    } else {
      _items.putIfAbsent(
          productid,
          () => cartitem(
              title: title,
              id: DateTime.now().toString(),
              price: price,
              quntity: 1));
    }
    notifyListeners();
  }

  void removeitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void removesingleitem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid]!.quntity > 1) {
      _items.update(
          productid,
          (existingitem) => cartitem(
              title: existingitem.title,
              id: existingitem.id,
              price: existingitem.price,
              quntity: existingitem.quntity - 1));
    } else {
      _items.remove(productid);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
