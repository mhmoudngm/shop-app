import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/order.dart';
import 'package:shop_flutter_app/widgets/app_drawer.dart';
import 'package:shop_flutter_app/widgets/order_item.dart';
import '../providers/order.dart' show order;
class ordersscreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer:appdrawer(),
      body: Container(
        
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: FutureBuilder(
          future: Provider.of<order>(context,listen: false).fetchandsetorders(),
          builder: (ctx,AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());

            }
            else{
                if(snapshot.error != null)
                {
                return Center(
                  child: Text("an error accurred")
                  );
                }
                else
                {
                 return Consumer<order>(builder: (ctx,orderdata,child)=>ListView.builder(
                    itemCount: orderdata.orders.length,
                    itemBuilder: (BuildContext context,int index)=>orderitemm(orderdata.orders[index])));
                }
              }
              
          },
          ),
      ),
      
    );
  }
}