import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';

class cartitems extends StatelessWidget {
  final String id;
  final String productid;
  final double price;
  final int quntity;
  final String title;

  const cartitems(
      this.id, this.productid, this.price, this.quntity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction)
      {
        return showDialog(context: context, builder: (ctx)=>AlertDialog(
          content:Text("Do you want to remove item from the cart?") ,
          title: Text("Are you sure?"),
          actions: [
            FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("No")),
            FlatButton(onPressed: ()=>Navigator.of(context).pop(true), child: Text("Yes"))
          ],

        ));
      },
      onDismissed: (direction){
        Provider.of<cart>(context,listen:false).removeitem(productid);
      },
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text("\$${price}"))),
            ),
            title: Text(title),
            subtitle: Text("total \$${(price * quntity)}"),
            trailing: Text("$quntity x"),
          ),
        ),
      ),
    );
  }
}
