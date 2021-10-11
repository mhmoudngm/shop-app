
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/product.dart';

class productitem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<product>(context, listen: false);
    final cartdata = Provider.of<cart>(context, listen: false);
    final authdata = Provider.of<auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/eps',arguments:productdata.id),
          child: Hero(
              tag: productdata.id,
              child: FadeInImage(
                placeholder:
                    AssetImage("assets/images/loading.gif"),
                image: NetworkImage(productdata.imgurl),
                fit: BoxFit.cover,
              )),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<product>(
            builder: (ctx, pro, _) => IconButton(
              color: Colors.red,
              onPressed: () {
                pro.togglefavstatues(authdata.token as String, authdata.useid!);
              },
              icon:
                  Icon(pro.isfavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ),
          title: Text(productdata.title,textAlign: TextAlign.center,),
          trailing: IconButton(
            color: Colors.red,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartdata.additem(productdata.id, productdata.title,productdata.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Added to cart!"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: "UNDO!", onPressed: (){cartdata.removesingleitem(productdata.id);},)
                ));},
          ),
          
        ),
      ),
    );
  }
}
