import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/screens/product_overview_screen.dart';

class appdrawer extends StatelessWidget {
  const appdrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:[
          AppBar(title:Text("hello in my shop"),
          automaticallyImplyLeading:false,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.shop),
            title:Text("Shop"),
            onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_){ return productoverviewscreen();})),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.payment),
            title:Text("Orders"),
            onTap: ()=> Navigator.of(context).pushReplacementNamed('/os'),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit),
            title:Text("Manage products"),
            onTap: ()=> Navigator.of(context).pushReplacementNamed('/ups'),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.exit_to_app),
            title:Text("Logout"),
            onTap: (){
               Navigator.of(context).pop();
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_){ return productoverviewscreen();}));
               Provider.of<auth>(context,listen:false).logout();

            }
          )
        
        ]
      )
      
    );
  }
}