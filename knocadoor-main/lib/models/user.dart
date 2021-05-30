import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_item.dart';
import 'package:knocadoor/models/cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const FAVORITE = "favorite";

  String _name;
  String _email;
  String _id;
  String _stripeId;
  dynamic _priceSum = 0.5;

//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get stripeId => _stripeId;

  // public variables
  List<CartItemModel> cart = [];
  List<FavoriteItemModel> favorite;
  dynamic totalCartPrice;
  dynamic get totcart => totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data[NAME];
    _email = snapshot.data[EMAIL];
    _id = snapshot.data[ID];
    favorite = _convertFavoriteItems(snapshot.data[FAVORITE] ?? []);
    _stripeId = snapshot.data[STRIPE_ID] ?? "";
    cart = _convertCartItems(snapshot.data[CART] ?? []);
    totalCartPrice = snapshot.data[CART] == null
        ? 0
        : getTotalPrice(cart: snapshot.data[CART]);
  }

  get uid => null;

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  dynamic getTotalPrice({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceSum += cartItem["price"];
    }

    dynamic total = _priceSum;
    return total;
  }

  List<FavoriteItemModel> _convertFavoriteItems(List favorite) {
    List<FavoriteItemModel> convertedFavorite = [];
    for (Map favoriteItem in favorite) {
      convertedFavorite.add(FavoriteItemModel.fromMap(favoriteItem));
    }
    return convertedFavorite;
  }
}
