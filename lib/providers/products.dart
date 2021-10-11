import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:http/http.dart' as http;

class products with ChangeNotifier {
  List<product> _items = [
        // product(
        //  id: 'p1',
        //  title: 'Red Shirt',
        //   description: 'A red shirt - it is pretty red!',
        // price: 29.99,
        //   imgurl:
        //    'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',)
        //  ),
        //  product(
        //   id: 'p2',
        //    title: 'Trousers',
        //    description: 'A nice pair of trousers.',
        //   price: 59.99,
        //  imgurl:
        //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
        //  ),
        //  product(
        //    id: 'p3',
        //   title: 'Yellow Scarf',
        //   description: 'Warm and cozy - exactly what you need for the winter.',
        // // //   price: 19.99,
        // // //   imgurl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
        // // // ),
        // // // product(
        // // //   id: 'p4',
        // // //   title: 'A Pan',
        // // //   description: 'Prepare any meal you want.',
        // // //   price: 49.99,
        // // //   imgurl:
        // // //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
        // // // ),
  ];

   String? authtoken;
   String? userid;
  getdata(String? authtok, String? uid, List<product> products) {
    authtoken = authtok;
    userid = uid;
    products = _items;
    notifyListeners();
  }

  List<product> get items {
    return _items;
  }

  List<product> get favoriteitems {
    return _items.where((item) => item.isfavorite).toList();
  }

  product findbyid(String uid) {
    return _items.firstWhere((item) => item.id == uid);
  }

  Future<void> fetchandsetproducts([bool filterbyusre = false]) async {
    final filterstring =
        filterbyusre ? 'orderBy="creatorid"&equalTo="$userid"' :'';
    var url =
        "https://shop-app-e8988-default-rtdb.firebaseio.com/product.json?auth=$authtoken&$filterstring";

    try {
      final res = await http.get(Uri.parse(url));
      final extracteddata = json.decode(res.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      url =
          "https://shop-app-e8988-default-rtdb.firebaseio.com/userfavorite/$userid.json?auth=$authtoken";
      final favres = await http.get(Uri.parse(url));
      final extractedfav = json.decode(favres.body);
      final List<product> loadeddata = [];
      extracteddata.forEach((prodid, prodata) {
        loadeddata.add(product(
          id: prodid,
          imgurl: prodata['imgurl'],
          title: prodata['title'],
          price: prodata['price'],
          description: prodata['description'],
          isfavorite:
              extractedfav == null ? false : extractedfav[prodid] ?? false,
        ));
      });
      _items = loadeddata;
      notifyListeners();
    } catch (e) {
      throw e ;
    }
  }

    Future<void> addproduct(product pro) async {
     final  url =
          "https://shop-app-e8988-default-rtdb.firebaseio.com/product.json?auth=$authtoken";
      try {
        final res = await http.post(Uri.parse(url),
            body: json.encode({
              'title': pro.title,
              'creatorid': userid,
              'price': pro.price,
              'description': pro.description,
              'imgurl': pro.imgurl,
            }));
            
            
        final  newProduct = product(
            title: pro.title,
            id: json.decode(res.body)["name"],
            price: pro.price,
            description: pro.description,
            imgurl: pro.imgurl);
        _items.add(newProduct);
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }

    Future<void> updateproduct(String id, product newproduct) async {
      final productindex = _items.indexWhere((pro) => pro.id == id);
      if (productindex >= 0) {
      final url=  "https://shop-app-e8988-default-rtdb.firebaseio.com/product/$id.json?auth=$authtoken";

        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newproduct.title,
              'price': newproduct.price,
              'description': newproduct.description,
              'imgurl': newproduct.imgurl,
            }));
              //print("*******************************************************");
           

            _items[productindex] = newproduct;
            notifyListeners();
      }
      else
      {
        print("....");
      }
    }


    Future<void> deleteproduct(String id) async {
      final url=  "https://shop-app-e8988-default-rtdb.firebaseio.com/product/$id.json?auth=$authtoken";

      final productindex = _items.indexWhere((pro) => pro.id == id);
      product? existingproduct = _items[productindex];
      _items.removeAt(productindex);
      notifyListeners();

      final res=await http.delete(Uri.parse(url));
      if(res.statusCode>=400)
      {
        _items.insert(productindex, existingproduct);
        notifyListeners();
        throw httpexception("could not delete product");
      }
      existingproduct = null;
    }
  }

