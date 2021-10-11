import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/widgets/app_drawer.dart';
import 'package:shop_flutter_app/widgets/badge.dart';
import 'package:shop_flutter_app/widgets/products_grid.dart';

class productoverviewscreen extends StatefulWidget {
  @override
  _productoverviewscreenState createState() => _productoverviewscreenState();
}

enum filteroption { favorites, all }

class _productoverviewscreenState extends State<productoverviewscreen> {
  var _isloading = false;
  var _showonlyfavorites = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _isloading = true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<products>(context)
        .fetchandsetproducts()
        .then(
          (_) => setState(() => _isloading = false),
        )
        .catchError((onError) => setState(() => _isloading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my shop"),
        actions: [
          PopupMenuButton(
              onSelected: (filteroption seletedval) {
                setState(() {
                  if (seletedval == filteroption.favorites) {
                    _showonlyfavorites = true;
                  } else {
                    _showonlyfavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: filteroption.favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: filteroption.all,
                    )
                  ]),
          Consumer<cart>(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.of(context).pushNamed('/cs'),
              ),
              builder: (_, cart, ch) => badge(
                  value: cart.itemcount.toString(),
                  color: Colors.red,
                  child: ch!))
        ],
      ),
      body: Container(
        
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : productgrid(
                showfav: _showonlyfavorites,
              ),
      ),
      drawer: appdrawer(),
    );
    ;
  }
}
