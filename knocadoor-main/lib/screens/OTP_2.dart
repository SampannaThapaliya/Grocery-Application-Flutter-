import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/home.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  String phone;
  String email;
  FirebaseUser user;
  // String verificationID;
  //int resendToken;
  OTPScreen(this.phone, this.email);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  Firestore _firestore = Firestore.instance;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final userr = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify 011- 977-  ${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  // await FirebaseAuth.instance
                  //   .signInWithCredential(PhoneAuthProvider.credential(
                  //     verificationId: _verificationCode, smsCode: pin))
                  //.then((value)
                  //    await FirebaseAuth.instance.signInWithCredential
                  AuthCredential authCredential =
                      PhoneAuthProvider.getCredential(
                          verificationId: _verificationCode, smsCode: pin);
                  await FirebaseAuth.instance
                      .signInWithCredential(authCredential)
                      .then((value) async {
                    if (value.user != null) {
                      // String eml = widget.phone.toString();
                      //String gml = eml;
                      //String name = widget.phone.toString();

                      String phone = widget.phone.toString();

                      String email = widget.email.toString();
                      QuerySnapshot resultt = await _firestore
                          .collection("users")
                          .where("name", isEqualTo: phone)
                          .getDocuments();

                      List<DocumentSnapshot> rslt = resultt.documents;

                      if (rslt.length == 0) {
                        userr.signUp(phone, email, phone);
                      } else {
                        userr.signIn(email, phone);
                      }
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+977${widget.phone}',
        verificationCompleted: (authCredential) async {
          await FirebaseAuth.instance
              .signInWithCredential(authCredential)
              .then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          });
        },
        codeSent: (String verficationID, [int resendToken]) {
          // assert(verficationID != null && resendToken != null);
          setState(() {
            _verificationCode = verficationID;
          });
        },
        verificationFailed: (e) async {
          print(e.message);
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
