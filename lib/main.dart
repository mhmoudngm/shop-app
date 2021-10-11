import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/screens/auth_screen.dart';
import 'package:shop_flutter_app/screens/cart_screen.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';
import 'package:shop_flutter_app/screens/orders_screen.dart';
import 'package:shop_flutter_app/screens/product_details_screen.dart';
import 'package:shop_flutter_app/screens/splash_screen.dart';
import 'package:shop_flutter_app/screens/user_poduct_screen.dart';

import 'providers/auth.dart';
import 'screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<auth>(create: (_) => auth()),
        ChangeNotifierProxyProvider<auth, products>(
          create: (_) => products(),
          update: (ctx, authvalue, prevousproducts) => prevousproducts!
            ..getdata(authvalue.token , authvalue.useid ,
                prevousproducts.items),
        ),
        ChangeNotifierProvider<cart>(create: (_) => cart()),
        ChangeNotifierProxyProvider<auth, order>(
          create: (_) => order(),
          update: (ctx, authvalue, prevousorders) => prevousorders!
            ..getdata(authvalue.token as String, authvalue.useid as String,
                prevousorders.orders),
        ),
      ],
      child: Consumer<auth>(
        builder: (ctx, value,_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: value.isauth
              ? productoverviewscreen()
              : FutureBuilder(
                  future: value.tryautologin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? splashscreen()
                          : authscreen(),
                ),
          routes: {
            //'/': (context) => productoverviewscreen(),
            '/pds': (context) => productdetailsscreen(),
            //'/as':  (context) => authscreen(),
            '/cs': (context) => cartscreen(),
            '/eps': (context) => editproductscreen(),
            '/os': (context) => ordersscreen(),
            // '/ss': (context) => splashscreen(),
            '/ups': (context) => userproductscreen(),
          },
        ),
      ),
    );
  }
}
