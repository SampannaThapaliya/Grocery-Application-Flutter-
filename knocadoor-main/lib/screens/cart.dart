import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/provider/app.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/screens/delivery_address.dart';
import 'package:knocadoor/services/khalti.dart';
import 'package:knocadoor/services/order.dart';
import 'package:knocadoor/widgets/custom_text.dart';
import 'package:knocadoor/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  var control = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(
          text: "Shopping Cart",
          weight: FontWeight.w600,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.cart.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: red.withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            userProvider.userModel.cart[index].image,
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: userProvider
                                              .userModel.cart[index].name +
                                          "\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          "\$${userProvider.userModel.cart[index].price / 100} \n\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300)),
                                ]),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: red,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool success =
                                        await userProvider.removeFromCart(
                                            cartItem: userProvider
                                                .userModel.cart[index]);
                                    if (success) {
                                      userProvider.reloadUserModel();
                                      print("Item added to cart");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Removed from Cart!")));
                                      appProvider.changeIsLoading();
                                      return;
                                    } else {
                                      appProvider.changeIsLoading();
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: red,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${userProvider.userModel.totalCartPrice / 100}",
                      style: TextStyle(
                          color: green,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: black),
                child: FlatButton(
                    onPressed: () {
                      if (userProvider.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Your cart is emty',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Dialog(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20.0)),
                      //         //this right here
                      //         child: Container(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12.0),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 GoogleMap(
                      //                   initialCameraPosition: appProvider.currentPosition,
                      //                   mapType: MapType.hybrid,
                      //                   onMapCreated: (controller) {
                      //                     appProvider.mapController.complete(controller);
                      //                   },
                      //                 ),
                      //                 Text(
                      //                   'You will be charged \$${userProvider.userModel.totalCartPrice / 100} upon delivery!',
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //                 SizedBox(
                      //                   width: 320.0,
                      //                   child: RaisedButton(
                      //                     onPressed: () async {
                      //                       var uuid = Uuid();
                      //                       String id = uuid.v4();
                      //                       _orderServices.createOrder(
                      //                           userId: userProvider.user.uid,
                      //                           id: id,
                      //                           description:
                      //                               "Thankyou for choosing Knoca-Door",
                      //                           status: "complete",
                      //                           totalPrice: userProvider
                      //                               .userModel.totalCartPrice,
                      //                           cart: userProvider
                      //                               .userModel.cart);
                      //                       // Chat(
                      //                       // email: userProvider
                      //                       //  .userModel.email);
                      //
                      // Navigator.push(
                      //    context,
                      //   MaterialPageRoute(
                      //      builder: (BuildContext context) => Pay(
                      //        id: userProvider.userModel.id,
                      //       name: userProvider.userModel.name,
                      //       totalPrice:
                      //           userProvider.userModel.totalCartPrice *
                      //          100)));
                      //
                      //                       for (CartItemModel cartItem
                      //                           in userProvider
                      //                               .userModel.cart) {
                      //                         bool value = await userProvider
                      //                             .removeFromCart(
                      //                                 cartItem: cartItem);
                      //                         if (value) {
                      //                           userProvider.reloadUserModel();
                      //                           print("Item added to cart");
                      //                           ScaffoldMessenger.of(context).showSnackBar(
                      //                               SnackBar(
                      //                                   content: Text(
                      //                                       "Removed from Cart!")));
                      //                         } else {
                      //                           print("ITEM WAS NOT REMOVED");
                      //                         }
                      //                       }
                      //                       ScaffoldMessenger.of(context).showSnackBar(
                      //                           SnackBar(
                      //                               content: Text(
                      //                                   "Order created!")));
                      //
                      //                       userProvider.reloadUserModel();
                      //                     },
                      //                     child: Text(
                      //                       "Accept",
                      //                       style:
                      //                           TextStyle(color: Colors.white),
                      //                     ),
                      //                     color: const Color(0xFF1BC0C5),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 320.0,
                      //                   child: RaisedButton(
                      //                       onPressed: () {
                      //                         Navigator.pop(context);
                      //                       },
                      //                       child: Text(
                      //                         "Reject",
                      //                         style: TextStyle(
                      //                             color: Colors.white),
                      //                       ),
                      //                       color: red),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DeliveryAddress()));
                    },
                    child: CustomText(
                      text: "Check out",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
