import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/HomeScreen.dart';
import 'package:rideshare/Pages/PublishRide.dart';
import 'package:rideshare/Pages/bookedrides/bookedRides.dart';
import 'package:rideshare/Pages/profile.dart';
import 'package:rideshare/Pages/searchride.dart';
import 'package:rideshare/Pages/yourRide.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/main.dart';
import 'package:http/http.dart' as http;

class NavigatonBar extends StatefulWidget {
  const NavigatonBar({super.key});

  @override
  State<NavigatonBar> createState() => _NavigatonBarState();
}

class _NavigatonBarState extends State<NavigatonBar> {
  int currentPage = 0;
  List ride = [] ;
  List<Widget> Pages =  [
    SearchRide(),
    YourRidesPage(), // need  to be delete this
    BookedRides(),
    ProfilePage(
      userData: {
        'firstName': 'John',
        'lastName': 'Doe',
        'age': '30',
        'mobileNo': '1234567890',
        'licenseNo': 'ABCD1234',
        'aadharNo': '123456789012',
        'carName': 'Toyota Camry',
        'carNo': 'XYZ123',
        'seatsInCar': '5',
      },
    ),
    PublishRidePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentPage = 4;
            });
          },
          child: Icon(
            Icons.add,
            color: Color.fromRGBO(251, 168, 52, 1),
            size: 35,
          ),
          // backgroundColor: const Color.fromRGBO(251, 168, 52, 1),
          backgroundColor: const Color.fromRGBO(51, 58, 115, 1),
          shape: CircleBorder(),
        ),
        body: IndexedStack(
          index: currentPage,
          children: Pages,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(80, 196, 237, 1),
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 35,
                  color: Color.fromRGBO(32, 14, 48, 1),
                ),
                onPressed: () {
                  // Handle home button press
                  setState(() {
                    currentPage = 0;
                  });
                },
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                icon: Icon(
                  Icons.chat,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle chat button press
                  setState(() {
                    currentPage = 1;
                  });
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.directions_car,
                  size: 35,
                ),
                onPressed: () async {
                  // Handle your rides button press
                  Map<String, dynamic> jwtDecodeToken =
                      JwtDecoder.decode(Globaltoken.toString());
                  var userId = jwtDecodeToken['_id'];

                  print(userId);

                  var regBody = {
                    "userId": userId,
                  };

                  print("Inside get booked rides: ");

                  // var response = await http.post(Uri.parse(getbookedrides),
                  //     headers: {"Content-Type": "application/json"},
                  //     body: jsonEncode(regBody));

                  // var jsonResponse = jsonDecode(response.body);
                  // print("json response:");
                  // print(jsonResponse['status']);
                  // // print(jsonResponse);

                  // ride = jsonResponse['bookedRides'];
                  // print(ride);
                  setState(() {
                    currentPage = 2;
                  });
                },
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                icon: Icon(Icons.person, size: 35),
                onPressed: () {
                  // Handle profile button press
                  setState(() {
                    currentPage = 3;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
