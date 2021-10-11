import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order.dart' as ord;

class orderitemm extends StatelessWidget {
  final ord.orderitem order;
  const orderitemm(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
          title: Text("\$${order.amount}"),
          subtitle: Text(DateFormat('dd/MM/yy hh:mm').format(order.datetime)),
          children: order.products.map((pro) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pro.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${pro.quntity} x \$${pro.price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              )).toList()),
    );
  }
}
