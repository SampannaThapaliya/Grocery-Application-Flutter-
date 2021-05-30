import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/models/order.dart';

class OrderServices {
  String collection = "orders";
  Firestore _firestore = Firestore.instance;

  void createOrder(
      {String userId,
        LatLng address,
      String id,
      String description,
      String status,
      List<CartItemModel> cart,
      dynamic totalPrice}) {
    List<Map> convertedCart = [];

    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());
    }

    _firestore.collection(collection).document(id).setData({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "address": GeoPoint(address.latitude, address.longitude),
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async => _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
