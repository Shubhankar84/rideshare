import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';



class CartProvider extends ChangeNotifier {
  var _token;

  String  token () {
    return _token;
  }
  void set_token(String newToken){
    _token = newToken;
    print("newset token is: $_token");
    notifyListeners();
  }

  Map<String, dynamic> source = {
    'latitude': 10.0,
    'longitude': 10.0,
    'add': null
  };

  Map<String, dynamic> dest = {
    'latitude': 10.0,
    'longitude': 10.0,
    'add': null
  };

  Map<String, dynamic> source2 = {
    'latitude': 10.0,
    'longitude': 10.0,
    'add': null
  };

  Map<String, dynamic> dest2 = {
    'latitude': 10.0,
    'longitude': 10.0,
    'add': null
  };

}
