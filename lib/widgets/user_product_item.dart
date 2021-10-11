import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/products.dart';
class userproductitem extends StatelessWidget {
  final String imgurl;
  final String id;
  final String title;

  const userproductitem( this.imgurl, this.id, this.title);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
       ),
       trailing: Container(
         width: 100,
         child: Row(
           children: [
             IconButton(onPressed: ()=>Navigator.of(context).pushNamed('/pds',arguments: id), icon: Icon(Icons.edit)),
             IconButton(
               icon: Icon(Icons.delete),
               color: Colors.red,
               onPressed: ()async{
               try{
                 await Provider.of<products>(context,listen: false).deleteproduct(id);

               }
               catch(e)
               {
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content:Text("failed to delete product!",textAlign: TextAlign.center,),
                   ));
               }}
             ), 
           ],
         ),
       ),
      
    );
  }
}