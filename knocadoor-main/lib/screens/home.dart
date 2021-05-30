import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:knocadoor/helpers/common.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/icons/style.dart';
import 'package:knocadoor/main.dart';
import 'package:knocadoor/provider/app.dart';
import 'package:knocadoor/provider/product.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/favorite.dart';
import 'package:knocadoor/services/product.dart';
import 'package:knocadoor/widgets/custom_text.dart';
import 'package:knocadoor/widgets/featured_products.dart';
import 'package:knocadoor/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'chat.dart';
import 'login.dart';
import 'cart.dart';
import 'order.dart';
import 'product_search.dart';
import 'Banners.dart';
import '../provider/category.dart';
import 'category.dart';
import '../widgets/categories.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  bool issign;

  HomePage({this.issign});
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  ProductServices _productServices = ProductServices();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

    final app = Provider.of<AppProvider>(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) => MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: Scaffold(
            key: _key,
            backgroundColor: Colors.lime[50],
            endDrawer: Drawer(
              child: ListView(
                shrinkWrap: true, //addgareko

                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.green),
                    accountName: CustomText(
                      text:
                          userProvider.userModel?.name ?? "username lading...",
                      color: white,
                      weight: FontWeight.bold,
                      size: 18,
                    ),
                    accountEmail: CustomText(
                      text: userProvider.userModel?.email ?? "email loading...",
                      color: white,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await userProvider.getOrders();
                      changeScreen(context, OrdersScreen());
                    },
                    leading: Icon(
                      Icons.bookmark_border,
                    ),
                    title: CustomText(
                      text: "My orders",
                      color: black,
                      weight: FontWeight.w900,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await userProvider.getOrders();
                      changeScreen(context, FavoriteScreen());
                    },
                    leading: Icon(Icons.favorite_border),
                    title: CustomText(
                      text: "My favorites",
                      color: black,
                      weight: FontWeight.w900,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      if (widget.issign == true) {
                        await facebookSignIn.logOut();
                        userProvider.signOut();
                      }
                      userProvider.signOut();

                      return new Login();
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: CustomText(
                      text: "Log out",
                      weight: FontWeight.w900,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Chat(
                                    name: userProvider.userModel.name,
                                  )));
                    },
                    leading: Icon(Icons.chat_outlined),
                    title: CustomText(
                      text: "Chat",
                      weight: FontWeight.w900,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      _notifier.value = mode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                    leading: Icon(Icons.chat_outlined),
                    title: CustomText(
                      text: "Change Theme",
                      weight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
//           Custom App bar
                  AppBar(
                    centerTitle: true,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState.openEndDrawer();
                      },
                      iconSize: 23,
                      icon: Icon(Icons.menu),
                    ),
                    backgroundColor: Color(0xff44c662),
                    title: Text('Knoca-Door Grocery',
                        style: logoWhiteStyle, textAlign: TextAlign.left),
                    actions: <Widget>[
                      SizedBox(
                        width: 7,
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          changeScreen(context, CartScreen());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outlined),
                        onPressed: () {
                          //yeta kei halnaparcha
                        },
                      ),
                    ],
                  ),

//          Search Text field
//            Search(),

                  Container(
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 10),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFe7ffe2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Colors.green[700],
                            ),
                            title: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: (pattern) async {
                                await productProvider.search(
                                    productName: pattern);
                                changeScreen(context, ProductSearchScreen());
                              },
                              decoration: InputDecoration(
                                hintText: "Tomoato Ketch.....",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )),
                  ),

                  //banner add
                  //   SizedBox(height: 10,),
                  //  Banners(),
                  SafeArea(
                      child: Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Column(
                                children: [
                                  Banners(),
                                ],
                              )))),
                  SizedBox(
                    height: 25,
                  ),
//            featured products
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: new Text(
                              'Featured products',
                              style: foodNameText,
                            )),
                      ),
                    ],
                  ),
                  FeaturedProducts(),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    'Categories',
                    style: foodNameText,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryProvider.categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
//                              app.changeLoading();
                              await productProvider.loadProductsByCategory(
                                  categoryName:
                                      categoryProvider.categories[index].name);

                              changeScreen(
                                  context,
                                  CategoryScreen(
                                    categoryModel:
                                        categoryProvider.categories[index],
                                  ));

//                              app.changeLoading();
                            },
                            child: CategoryWidget(
                              category: categoryProvider.categories[index],
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
//          recent products
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: new Text(
                              'Recent products',
                              style: foodNameText,
                            )),
                      ),
                    ],
                  ),

                  Column(
                    children: productProvider.products
                        .map((item) => GestureDetector(
                              child: ProductCard(
                                product: item,
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
//Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//GestureDetector(
//onTap: (){
//key.currentState.openDrawer();
//},
//child: Icon(Icons.menu))
//],
//),
