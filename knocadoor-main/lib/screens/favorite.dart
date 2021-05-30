import 'package:flutter/material.dart';
import 'package:knocadoor/provider/app.dart';
import 'package:knocadoor/provider/user.dart';
import 'package:knocadoor/services/favorite.dart';
import 'package:knocadoor/services/order.dart';
import 'package:knocadoor/widgets/custom_text.dart';
import 'package:knocadoor/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _key = GlobalKey<ScaffoldState>();

  OrderServices _orderServices = OrderServices();
  FavoriteServices _favoriteServices = FavoriteServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.indigoAccent[100],
        elevation: 0.0,
        title: CustomText(
          text: " My Favorites",
          weight: FontWeight.bold,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.favorite.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue[100],
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.2),
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
                            userProvider.userModel.favorite[index].image,
                            height: 100,
                            width: 140,
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
                                              .userModel.favorite[index].name +
                                          "\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          "Npr. ${userProvider.userModel.favorite[index].price} \n\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300)),
                                ]),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool success =
                                        await userProvider.removeFromFavorite(
                                            favoriteItem: userProvider
                                                .userModel.favorite[index]);
                                    if (success) {
                                      userProvider.reloadUserModel();
                                      print("Item added to favorite");
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content:
                                              Text("Removed from Favorite!")));
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
    );
  }
}
