import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'OTP_2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _cnt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 1),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('011-977- '),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Recovery Email',
                alignLabelWithHint: true,
                hintStyle: TextStyle(fontWeight: FontWeight.w300),
                fillColor: Colors.redAccent,
                prefix: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text('email'),
                ),
              ),
              maxLength: 20,
              keyboardType: TextInputType.emailAddress,
              controller: _cnt,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              child: RaisedButton(
                highlightColor: Colors.brown,
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OTPScreen(_controller.text, _cnt.text)));
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
