

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/widgets/app_drawer.dart';
import 'package:shop_flutter_app/widgets/user_product_item.dart';


class userproductscreen extends StatelessWidget {
  
Future<void> _refreshproducts(BuildContext context)async{
  await Provider.of<products>(context,listen: false).fetchandsetproducts(true);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User products"),
        actions: [
          IconButton(onPressed: ()=>Navigator.of(context).pushNamed('/pds'), icon: Icon(Icons.add))
        ],
      ),
      body:Container(
        
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: FutureBuilder(
          future: _refreshproducts(context),
          builder: (ctx,snapshot)=>
            snapshot.connectionState==ConnectionState.waiting?
            Center(child: CircularProgressIndicator()):
            RefreshIndicator( 
             onRefresh: ()=>_refreshproducts(context),
             child:Consumer<products>( 
             builder:(ctx,productdata,_)=> Padding(
               padding: EdgeInsets.all(8),
             child: ListView.builder(itemCount: productdata.items.length,itemBuilder: (_,index)=>Column(children: [
               userproductitem(productdata.items[index].imgurl,productdata.items[index].id,productdata.items[index].title),
               Divider(),
             ],
             ),
             ),
             )
             ,
             )
             )
          ,
        ),
      ),
      drawer:appdrawer(),
    );;
  }
}