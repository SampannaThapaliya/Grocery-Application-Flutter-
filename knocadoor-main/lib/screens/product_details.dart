import 'package:flutter/material.dart';
import 'package:knocadoor/helpers/common.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/models/product.dart';
import 'package:knocadoor/provider/app.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/widgets/custom_text.dart';
import 'package:knocadoor/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'cart.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _color = "";
  String _size = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _color = widget.product.colors[0];
    _size = widget.product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    double minheight;

    return Scaffold(
      key: _key,
      body: SafeArea(
          child: Container(
        color: black,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: Loading(),
                )),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.product.picture,
                    height: 400,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.07),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container())),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.07),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container())),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.product.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '\Rs.${widget.product.price}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        changeScreen(context, CartScreen());
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_basket_outlined),
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        print("CLICKED");
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(35))),
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: black, offset: Offset(2, 5), blurRadius: 10)
                    ]),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "Rating:",
                              color: white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                                value: _color,
                                style: TextStyle(color: white),
                                items: widget.product.colors
                                    .map<DropdownMenuItem<String>>(
                                        (value) => DropdownMenuItem(
                                            value: value,
                                            child: CustomText(
                                              text: value,
                                              color: red,
                                            )))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _color = value;
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.product.description,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.greenAccent,
                          elevation: 9.0,
                          child: MaterialButton(
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool success = await userProvider.addToCart(
                                  product: widget.product,
                                  color: _color,
                                  size: _size);
                              if (success) {
                                // ignore: deprecated_member_use
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Added to Cart!")));
                                userProvider.reloadUserModel();
                                appProvider.changeIsLoading();
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Not added to Cart!")));
                                appProvider.changeIsLoading();
                                return;
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.01,
                            child: appProvider.isLoading
                                ? Loading()
                                : Text(
                                    "Add to cart",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.red,
                          elevation: 9.0,
                          type: MaterialType.card,
                          child: MaterialButton(
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool success = await userProvider.addToFavorite(
                                  product: widget.product);
                              if (success) {
                                // ignore: deprecated_member_use
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Added to Favorite!")));
                                userProvider.reloadUserModel();
                                appProvider.changeIsLoading();
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Not added to Favorite!")));
                                appProvider.changeIsLoading();
                                return;
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            child: appProvider.isLoading
                                ? Loading()
                                : Text(
                                    "Add to Favorite",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
