import 'package:flutter/material.dart';
import 'package:knocadoor/helpers/common.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/login.dart';
import 'package:knocadoor/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  bool hidePass = true;
  bool issigned = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      body: user.status == Status.Authenticating
          ? Loading()
          : SingleChildScrollView(
              child: Container(
              child: Column(children: <Widget>[
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
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 130,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
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
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Sign Up",
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
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(1, 8.0, 1, 1.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: ListTile(
                              title: TextFormField(
                                controller: _name,
                                decoration: InputDecoration(
                                    hintText: "Full name",
                                    icon: Icon(Icons.person_outline),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "The name field cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ))
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8.0, 25.0, 21.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.2),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ListTile(
                        title: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                              hintText: "Email",
                              icon: Icon(Icons.alternate_email),
                              border: InputBorder.none),
                          validator: (value) {
                            assert(value != null);
                            if (value.isEmpty) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value))
                                return 'Please make sure your email address is valid';
                              else
                                return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19.0, 8.0, 25.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.3),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ListTile(
                        title: TextFormField(
                          controller: _password,
                          obscureText: hidePass,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.lock_outline),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "The password field cannot be empty";
                            } else if (value.length < 6) {
                              return "the password has to be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                hidePass = !hidePass;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green[300],
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (!await user.signUp(_name.text, _email.text,
                                _password.text)) if (issigned == true) {
                              await user.signOut();
                              return Login();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sign up failed")));

                            changeScreenReplacement(context, HomePage());
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "Sign up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      )),
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
              ]),
            )),
    );
  }
}
