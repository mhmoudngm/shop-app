import 'package:flutter/material.dart';

class badge extends StatelessWidget {
  final  Widget child;
  final Color color;
  final String value;

  const badge({ required this.value,required this.color, required this.child}) ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(top: 8,right: 8,child:Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          constraints: BoxConstraints(
            minHeight: 16,
            maxHeight: 16
          ),
          child: Text(value,style: TextStyle(fontSize:10),textAlign: TextAlign.center,)
          ,
        ) ,)

      ],
      
    );
  }
}