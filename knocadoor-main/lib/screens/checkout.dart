import 'package:flutter/material.dart';
import '../helpers/roundedborder.dart';
import '../services/khalti.dart';

class CheckoutOnePage extends StatelessWidget {
  static final String path = "lib/src/pages/ecommerce/cart1.dart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Choose your payment gateway",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 50.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: RoundedContainer(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Knoca Door Grocery",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "Thankyou for Choosing us",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            RoundedContainer(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  Icons.money_rounded,
                  color: Colors.indigo,
                ),
                title: Text("Cash on Delivery"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: null,
              ),
            ),
            RoundedContainer(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  Icons.credit_card_rounded,
                  color: Colors.indigo,
                ),
                title: Text("Khalti"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 100.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 32.0,
              ),
              child: RaisedButton(
                elevation: 0,
                padding: const EdgeInsets.all(24.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text("Continue"),
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Pay()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
