import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products.dart';

class editproductscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prodid = ModalRoute.of(context)!.settings.arguments as String;
    final loadeddata = Provider.of<products>(context).findbyid(prodid);
    return Scaffold(
      body: Container(
        
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadeddata.title),
                background: Hero(
                    tag: loadeddata.id,
                    child: Image.network(
                      loadeddata.imgurl,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                "\$${loadeddata.price}",
                style: TextStyle(fontSize: 20, color: Colors.grey),textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  "${loadeddata.description}",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
