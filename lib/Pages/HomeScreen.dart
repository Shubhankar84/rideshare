import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/Pages/calanderScreen.dart';
import 'package:rideshare/Pages/navigatorBar.dart';
import 'package:rideshare/Pages/personalDetailsPage.dart';
import 'package:rideshare/Widgets/searchPlace.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final token;
  final validated;
  const HomeScreen({super.key, required this.token, required this.validated});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userId;
  late SharedPreferences prefs;
  // late bool validated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['_id'];
    print("validated in Homescreen is: ${widget.validated}");
  }

  // void checkUserPersonalDetails() async {
  //   // Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token);
  //   // var userId = jwtDecodeToken['_id'];
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

  void logout() async {
    try {
      // Remove authentication data from local storage
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userId'); // Add/remove other stored sensitive data

      // Clear navigation stack and go to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        ModalRoute.withName('/'),
      );

      // Show a success message (optional)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      // Handle errors gracefully
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while logging out.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.validated == false
        ? UserDetailsPage(token: widget.token)
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "RideShare",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      // Show the alert dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Create the AlertDialog
                          return AlertDialog(
                            title: Text("Sign Out"),
                            content: Text("Are you sure you want to sign out?"),
                            actions: [
                              // Yes button
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                  // Call the logout function
                                  logout();
                                },
                                child: Text("Yes"),
                              ),
                              // No button
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: NavigatonBar(),
          );
  }
}
