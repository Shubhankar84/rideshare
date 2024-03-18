import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


class CartProvider extends ChangeNotifier {
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

}
