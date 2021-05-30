import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AppProvider with ChangeNotifier{
  bool isLoading = false;
  LocationData _locationData;

  LocationData get location => _locationData;

  AppProvider() {
    loadCurrentLocation();
  }

  void changeIsLoading(){
    isLoading = !isLoading;
    notifyListeners();
  }

  void loadCurrentLocation() async {

    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print('Longitude: ${_locationData.longitude}');
  }

}