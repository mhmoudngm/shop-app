import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class product with ChangeNotifier {
  final String title;
  final String id;
  final double price;
  final String description;
  final String imgurl;
  bool isfavorite;

  product(
      {required this.title,
      required this.id,
      required this.price,
      required this.description,
      required this.imgurl,
      this.isfavorite = false});

  void setfavoritestate(bool newvalue) {
    isfavorite = newvalue;
    notifyListeners();
  }

  Future<void> togglefavstatues(String token, String userid) async {
          final url="https://shop-app-e8988-default-rtdb.firebaseio.com/userfavorite/$userid/$id.json?auth=$token";

    final oldstate = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();
    try {
      final res =await http.put(
        Uri.parse(url),
         body: json.encode(isfavorite)
         );

         if(res.statusCode>=400)
         {
           setfavoritestate(oldstate);
         }
    } catch (e) {
      setfavoritestate(oldstate);
    }
  }
}
