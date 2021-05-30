import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knocadoor/models/cart_item.dart';
import 'package:knocadoor/models/favorite.dart';
import 'package:knocadoor/models/favorite_item.dart';
import 'package:knocadoor/models/order.dart';
import 'package:knocadoor/models/product.dart';
import 'package:knocadoor/models/user.dart';
import 'package:knocadoor/services/favorite.dart';
import 'package:knocadoor/services/order.dart';
import 'package:knocadoor/services/users.dart';
import 'package:uuid/uuid.dart';

enum Status {
  init,
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  FavoriteServices _favoriteServices = FavoriteServices();

  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;

  Status get status => _status;

  FirebaseUser get user => _user;

  // public variables
  List<OrderModel> orders;
  List<FavoriteModel> favorites = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        _userModel = await _userServices.getUserById(value.user.uid);
        notifyListeners();
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      PlatformException(
          code: e.toString(),
          details: 'wrong email/pw',
          message: 'Sorry paswsword or username is incorrect');
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        print("CREATE USER");
        _userServices.createUser({
          'name': name,
          'email': email,
          'uid': user.user.uid,
          'stripeId': ''
        });
        _userModel = await _userServices.getUserById(user.user.uid);
        notifyListeners();
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // Future<void> verifypassword(String email) {
  //  return user.sendEmailVerification();
  // }

  Future signOut() async {
    _auth.signOut();

    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      print("CART ITEMS: ${userModel.cart.length}");
      print("CART ITEMS: ${userModel.cart.length}");
      print("CART ITEMS: ${userModel.cart.length}");
      print("CART ITEMS: ${userModel.cart.length}");
      print("CART ITEMS: ${userModel.cart.length}");
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart(
      {ProductModel product, String size, String color}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": product.price
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> addToFavorite({ProductModel product}) async {
    try {
      var uuid = Uuid();
      String favoriteItemId = uuid.v4();
      List<FavoriteItemModel> favorite = _userModel.favorite;

      Map favoriteItem = {
        "id": favoriteItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": product.price
      };

      FavoriteItemModel item = FavoriteItemModel.fromMap(favoriteItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${favorite.toString()}");
      _userServices.addToFavorite(userId: _user.uid, favoriteItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromFavorite({FavoriteItemModel favoriteItem}) async {
    print("THE PRODUC IS: ${favoriteItem.toString()}");

    try {
      _userServices.removeFromFavorite(
          userId: _user.uid, favoriteItem: favoriteItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  getFavorite() async {
    favorites = await _favoriteServices.getUserFavorites(userId: _user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }
}
