import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:http/http.dart' as http;
import 'package:knocadoor/helpers/common.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/OTP.dart';
import 'package:knocadoor/screens/login.dart';
import 'package:knocadoor/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:knocadoor/screens/home.dart';

var email;
var name;
var token;
FacebookLogin facebookLogin = FacebookLogin();
Firestore _firestore = Firestore.instance;
//final user = Provider.of<UserProvider>(context);

class fblog extends StatefulWidget {
  fblog({Key key}) : super(key: key);

  @override
  _fblogState createState() => _fblogState();
}

class _fblogState extends State<fblog> {
  bool isSignedin;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      body: user.status == Status.Authenticating
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 450,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/background.png'),
                              fit: BoxFit.fill)),

                      //yesma form key thyo
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            ),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 130,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Try Another Way",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    //googlesignin
                    FlatButton(
                      minWidth: 220,
                      height: 34,
                      autofocus: true,
                      color: Colors.greenAccent,
                      highlightColor: Colors.brown,
                      clipBehavior: Clip.hardEdge,
                      splashColor: Colors.brown,
                      child: Text(
                        'Sign in using Phone',
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    //facebook sign in
                    SignInButton(Buttons.FacebookNew, onPressed: () async {
                      final FacebookLoginResult result =
                          await facebookLogin.logIn(['email']);

                      switch (result.status) {
                        case FacebookLoginStatus.cancelledByUser:
                          break;

                        case FacebookLoginStatus.error:
                          print("There is error loggin you in");
                          break;

                        case FacebookLoginStatus.loggedIn:
                          try {
                            isSignedin = true;
                            HomePage(
                              issign: isSignedin,
                            );
                            final FacebookAccessToken accessToken =
                                result.accessToken;

                            // AuthCredential credential = FacebookAuthProvider.getCredential(
                            //accessToken: result.accessToken.toString());
                            final graphResponse = await http.get(Uri.parse(
                                'https://graph.facebook.com/v2.12/me?fields=email,name&access_token=${accessToken.token}'));

                            dynamic profile = jsonDecode(graphResponse.body);

                            // first_name = profile['first_name'];
                            // lastname = profile['last_name'];

                            email = profile['email'];
                            name = profile['name'];
                            // token = profile['access_token'];

                            QuerySnapshot resultt = await _firestore
                                .collection("users")
                                .where("email", isEqualTo: email)
                                .getDocuments();

                            List<DocumentSnapshot> rslt = resultt.documents;

                            if (rslt.length == 0) {
                              await user.signUp(name, email, name);
                              //
                              //   register();
                              //} else {
                              //UserProvider.initialize().signIn(email, name);
                              //signin();
                              // }
                              // FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

                              print('''
              Logged in!
          
          Token: ${accessToken.token}
          User id: ${accessToken.userId}
          Expires: ${accessToken.expires}
          Permissions: ${accessToken.permissions}
          Declined permissions: ${accessToken.declinedPermissions}
          ''');

                              return rslt;
                            } else {
                              await user.signIn(email, name);
                            }
                          } catch (e) {
                            print('Sorry facebook login is failed ');
                          }
                          //  default:
                          changeScreenReplacement(context, HomePage());
                      }

                      //  changeScreenReplacement(context, HomePage());
                    }),
                    Text(
                      "Sign up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "I already have an account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
