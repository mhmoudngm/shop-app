import 'package:flutter/material.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class orderitem {
  final double amount;
   String? id;
  final DateTime datetime;
  final List<cartitem> products;

  orderitem({
    required this.datetime,
    required this.id,
    required this.amount,
    required this.products,
  });
}

class order with ChangeNotifier {
  List<orderitem> _orders = [];
   String? authtoken;
   String? userid;
  getdata(String authtok, String uid, List<orderitem> orders) {
    authtoken = authtok;
    userid = uid;
    orders = _orders;
    notifyListeners();
  }

  List<orderitem> get orders {
    return [..._orders];
  }

  Future<void> fetchandsetorders() async {
    var url =
        "https://shop-app-e8988-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authtoken";
    try {
      final res = await http.get(Uri.parse(url));
      final extracteddata = json.decode(res.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }

      final List<orderitem> loadeddata = [];
      extracteddata.forEach((orderid, orderdata) {
        loadeddata.add(orderitem(
          id: orderid,
          amount: orderdata['amount'],
          products: (orderdata['products'] as List<dynamic>)
              .map((item) => cartitem(
                  title: item['title'],
                  id: item['id'],
                  price: item['price'],
                  quntity: item['quntity']))
              .toList(),
          datetime: DateTime.parse(orderdata['datetime']),
        ));
      });
      _orders = loadeddata.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addorder(
      List<cartitem> cartproduct, double total) async {
    final url =
        "https://shop-app-e8988-default-rtdb.firebaseio.com/orders/$userid.json?auth=$authtoken";
    try {
      final timesteamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'products': cartproduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quntity': cp.quntity
                    })
                .toList(),
            'amount': total,
            'datetime': timesteamp.toString(),
          }));

      _orders.insert(
          0,
          orderitem(
              datetime: timesteamp,
              id: json.decode(res.body)["name"],
              amount: total,
              products: cartproduct));
      notifyListeners();
    } catch (e) {
      throw e ;
    }
  }
}
