import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/HomeScreen.dart';
import 'package:rideshare/Pages/calanderScreen.dart';
import 'package:rideshare/Pages/personalDetailsPage.dart';
import 'package:rideshare/cartProvider.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/homescreen.dart';
import 'package:rideshare/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var Globaltoken;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  Globaltoken = token;
  bool validated = false;
  print("token in main.dart: $token");

  // ----------------------------------------------------------
  if (token != null) {
    CartProvider cartProvider = CartProvider();
    cartProvider.set_token(token);

    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token.toString());
    var userId = jwtDecodeToken['_id'];
    var regBody = {
      "userId": userId,
    };

    print("Waiting...........");
    var response = await http.post(Uri.parse(checkPersonalDetails),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);
    print(jsonResponse);
    validated = jsonResponse['status'];
    // ----------------------------------------------------------
  }

  runApp(ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: MaterialApp(
        // home: token==null? MyApp(): HomeScreen(token: token),
        home: token == null
            ? MyApp()
            : HomeScreen(
                token: token,
                validated: validated,
              )),
  ));
}

// void checkUserPersonalDetails(token) async {
//   Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token);
//   var userId = jwtDecodeToken['_id'];
//   var regBody = {
//     "userId": userId,
//   };

//   var response = await http.post(Uri.parse(addUserDetails),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(regBody));

//   var jsonResponse = jsonDecode(response.body);

//   print(jsonResponse['status']);
//   print(jsonResponse);
//   validated = jsonResponse['status'];
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
