import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/models/payment.dart';

class PaymentServices {
  String collection = "payment";
  Firestore _firestore = Firestore.instance;

  void createPayment({
    String userid,
    String name,
    dynamic amount,
    bool status,
  }) {
    _firestore.collection(collection).document(userid).setData({
      "userid": userid,
      "payname": name,
      "totalamount": amount,
      "paymentstatus": status
    });
  }
}
