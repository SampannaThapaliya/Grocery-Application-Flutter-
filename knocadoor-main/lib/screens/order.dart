import 'package:flutter/material.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/models/order.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: CustomText(
          text: "Orders",
          weight: FontWeight.bold,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.blueAccent[50],
      body: ListView.builder(
          itemCount: userProvider.orders.length,
          itemBuilder: (_, index) {
            OrderModel _order = userProvider.orders[index];
            return ListTile(
              leading: CustomText(
                text: "\$${_order.total / 100}",
                weight: FontWeight.bold,
              ),
              title: Text(_order.description),
              subtitle: Text(
                  DateTime.fromMillisecondsSinceEpoch(_order.createdAt)
                      .toString()),
              trailing: CustomText(
                text: _order.status,
                color: green,
              ),
            );
          }),
    );
  }
}
