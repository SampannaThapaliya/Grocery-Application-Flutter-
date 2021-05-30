import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/models/favorite_item.dart';
import 'package:knocadoor/models/user.dart';

class UserServices {
  Firestore _firestore = Firestore.instance;
  String collection = "users";

  createUser(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(collection)
          .document(data["uid"])
          .setData(data);
      print("USER WAS CREATED");
    } catch (e) {
      print('ERROR: ${e.toString()}');
    }
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).document(id).get().then((doc) {
        print("==========id is $id=============");
        debugPrint("==========NAME is ${doc.data['name']}=============");
        debugPrint("==========NAME is ${doc.data['name']}=============");
        debugPrint("==========NAME is ${doc.data['name']}=============");
        debugPrint("==========NAME is ${doc.data['name']}=============");

        print("==========NAME is ${doc.data['name']}=============");
        print("==========NAME is ${doc.data['name']}=============");
        print("==========NAME is ${doc.data['name']}=============");

        return UserModel.fromSnapshot(doc);
      });

  void addToCart({String userId, CartItemModel cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void removeFromCart({String userId, CartItemModel cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }

  void addToFavorite({String userId, FavoriteItemModel favoriteItem}) {
    print("THE USER ID IS: $userId");
    print("favorite items are: ${favoriteItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "favorite": FieldValue.arrayUnion([favoriteItem.toMap()])
    });
  }

  void updateUser({String userId, String name, UserModel phoneNumber}) {
    print("THE USER ID IS: $userId");
    _firestore
        .collection(collection)
        .document(userId)
        .updateData({'name': name, 'phoneNumber': phoneNumber});
  }

  void removeFromFavorite({String userId, FavoriteItemModel favoriteItem}) {
    print("THE USER ID IS: $userId");
    print("favorite items are: ${favoriteItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "favorite": FieldValue.arrayRemove([favoriteItem.toMap()])
    });
  }

//   void addToCart({String userId, CartItemModel cartItem}) {
//     _firestore.collection(collection).document(userId).updateData({
//       "cart": FieldValue.arrayUnion([cartItem.toMap()])
//     });
//   }

//   void removeFromCart({String userId, CartItemModel cartItem}) {
//     _firestore.collection(collection).document(userId).updateData({
//       "cart": FieldValue.arrayRemove([cartItem.toMap()])
//     });
//   }
// }
}
