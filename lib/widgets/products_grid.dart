

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/widgets/product_item.dart';

class productgrid extends StatelessWidget {
  final bool showfav;

  const productgrid({required this.showfav});

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<products>(context);
    final productss = showfav?productdata.favoriteitems:productdata.items;

    return productss.isEmpty?Center(child: Text("There Is No products!"),):
    
     GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: productss.length,
      itemBuilder: (ctx,index)=>ChangeNotifierProvider.value(value: productss[index],child: productitem(),),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2),
    );
  }
}
