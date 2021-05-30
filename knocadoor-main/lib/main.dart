import 'package:flutter/material.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/login.dart';

import 'package:knocadoor/screens/splash.dart';
import 'package:provider/provider.dart';

import 'provider/app.dart';
import 'provider/product.dart';
import 'screens/home.dart';
import './provider/category.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
      ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ChangeNotifierProvider.value(value: AppProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: true,
      //  theme: ThemeData(primaryColor: Colors.white ?? Colors.black),
      home: ScreensController(),
      themeMode: ThemeMode.system,

      // initialRoute: '/',
    ),
  ));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.init:

      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
    }
  }
}
