import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widgets/cart_items.dart';

class cartscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartt = Provider.of<cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Container(
        
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text("\$${cartt.totalamount.toStringAsFixed(2)}"),
                      backgroundColor: Colors.black38,
                    ),
                    orderbutton(cartt: cartt)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => cartitems(
                    cartt.items.values.toList()[index].id!,
                    cartt.items.keys.toList()[index],
                    cartt.items.values.toList()[index].price,
                    cartt.items.values.toList()[index].quntity,
                    cartt.items.values.toList()[index].title),
                itemCount: cartt.items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class orderbutton extends StatefulWidget {
  final cart cartt;
  const orderbutton({required this.cartt});

  @override
  _State createState() => _State();
}

class _State extends State<orderbutton> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartt.totalamount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<order>(context, listen: false).addorder(
                  widget.cartt.items.values.toList(), widget.cartt.totalamount);
              setState(() {
                _isloading = false;
              });
              widget.cartt.clear();
            },
      child: _isloading ? CircularProgressIndicator() : Text("ORDER NOW"),
      textColor: Colors.pink,
    );
  }
}
