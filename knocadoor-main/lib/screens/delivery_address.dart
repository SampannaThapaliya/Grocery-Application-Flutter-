import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knocadoor/helpers/style.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/provider/app.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/services/khalti.dart';
import 'package:knocadoor/services/order.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DeliveryAddress extends StatefulWidget {
  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  bool isLoading = false;
  Completer<GoogleMapController> _mapController = Completer();
  CameraPosition _currentPosition;
  BitmapDescriptor _pinLocationIcon;
  Set<Marker> _markers = {};
  LatLng _markerPosition;

  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    setLocation(appProvider.location);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Delivery Address'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: _currentPosition,
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController.complete(controller);
                    setState(() {
                      _markers.add(Marker(
                          markerId: MarkerId('123'),
                          icon: _pinLocationIcon,
                          position: _markerPosition,
                          draggable: true,
                          onDragEnd: (value) {
                            setState(() {
                              _markerPosition = value;
                            });
                          }));
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'You will be charged \$${userProvider.userModel.totalCartPrice / 100} upon delivery!',
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ),
              SizedBox(
                width: 320.0,
                child: RaisedButton(
                  onPressed: () async {
                    var uuid = Uuid();
                    String id = uuid.v4();
                    _orderServices.createOrder(
                        userId: userProvider.user.uid,
                        address: _markerPosition,
                        id: id,
                        description: "Thankyou for choosing Knoca-Door",
                        status: "complete",
                        totalPrice: userProvider.userModel.totalCartPrice,
                        cart: userProvider.userModel.cart);
                    // Chat(
                    // email: userProvider
                    //  .userModel.email);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Pay(
                                id: userProvider.userModel.id,
                                name: userProvider.userModel.name,
                                totalPrice:
                                    userProvider.userModel.totalCartPrice *
                                        100)));

                    for (CartItemModel cartItem
                        in userProvider.userModel.cart) {
                      bool value =
                          await userProvider.removeFromCart(cartItem: cartItem);
                      if (value) {
                        userProvider.reloadUserModel();
                        print("Item added to cart");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Removed from Cart!")));
                      } else {
                        print("ITEM WAS NOT REMOVED");
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order created!")));
                    Pay(
                        id: userProvider.userModel.id,
                        name: userProvider.userModel.name,
                        totalPrice:
                            userProvider.userModel.totalCartPrice * 100);

                    userProvider.reloadUserModel();
                  },
                  child: Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: const Color(0xFF1BC0C5),
                ),
              ),
              SizedBox(
                width: 320.0,
                child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setCustomMapPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setLocation(LocationData locationData) {
    _currentPosition = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: 14.4746,
    );
    _markerPosition = LatLng(locationData.latitude, locationData.longitude);
  }
}
