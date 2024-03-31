import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/bookedrides/rideBookedDetails.dart';
import 'package:rideshare/Widgets/rideCard.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/main.dart';
import 'package:http/http.dart' as http;

class BookedRides extends StatefulWidget {
  // final List ride;
  const BookedRides({
    Key? key,
  }) : super(key: key);

  @override
  State<BookedRides> createState() => _BookedRidesState();
}

class _BookedRidesState extends State<BookedRides> {
  bool book = true;
  List<dynamic>? ride;
  int fromWhichPage = 0;

  void getBookedRides() async {
    fromWhichPage = 1;
    ride = [];
    print("inside of getBookedRides");
    Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
    var userId = jwtDecodeToken['_id'];

    print("USER IDDDDDDDD");
    print(userId);

    var regBody = {
      "userId": userId,
    };

    print("Inside get booked rides: ");

    var response = await http.post(Uri.parse(getbookedrides),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print("json response:");
    print(jsonResponse['status']);
    // print(jsonResponse);
    print("Ride in booked rides:");
    ride = jsonResponse['bookedRides'];
    print(ride);
    setState(() {});

    print("Ride length in booked rides is : ${ride!.length}");

    // return ride;
  }

  void getPublishedRides() async {
    fromWhichPage = 2;
    print(
        "Published Rides-------------------------------------------------------");
    ride = [];
    Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
    var userId = jwtDecodeToken['_id'];
    print(userId);

    var regBody = {
      "userId": userId,
    };

    print("Inside get booked rides: ");

    var response = await http.post(Uri.parse(getpublishedrides),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print("json response:");
    print(jsonResponse['status']);
    // print(jsonResponse);

    print("Ride in published rides:");

    ride = jsonResponse['publishedRides'];
    print(ride);
    setState(() {});
    print("Ride length in published rides is : ${ride?.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildRideList(),
    );
  }

  Widget buildRideList() {
    return Column(
      children: [
        // FutureBuilder(
        //     future: getBookedRides(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return ListView.builder(
        //           itemCount: ride.length,
        //           itemBuilder: (context, index) {
        //             return RideCard(ride: ride[index]);
        //           },
        //         );
        //       } else{
        //         return Center(child: CircularProgressIndicator());
        //       }
        //     }),
        button(),
        const SizedBox(
          height: 15,
        ),
        (ride == null)
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: NetworkImage(
                          'https://media.istockphoto.com/id/1393876513/vector/ride-sharing-apps-isolated-cartoon-vector-illustrations.jpg?b=1&s=612x612&w=0&k=20&c=rNVthraUkgDgOt46MAWef5ZtFitxjxRswG-hwgbcXyU=')),
                  Text(
                    "No Rides available",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              )
            : Expanded(
                child: ride!.isNotEmpty
                    ? ListView.builder(
                        itemCount: ride!.length,
                        itemBuilder: (context, index) {
                          print(
                              "Ride index: ${index}, and contains: ${ride![index]}");
                          return RideCard(
                            ride: ride![index],
                            fromWhichPage: fromWhichPage,
                          );
                        },
                      )
                    : Center(
                        child:
                            CircularProgressIndicator(), // Or any loading indicator                   ),[index]
                      ),
              )
      ],
    );
  }

  Widget button() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  getBookedRides();
                  book = true;
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: book
                      ? Colors.blue
                      : const Color.fromARGB(255, 219, 213, 213),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Booked Rides",
                    style: book
                        ? TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                        : TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print('set to false');
                  getPublishedRides();
                  book = false;
                });
              },
              child: Container(
                height: 50, // Adjusted height for consistency
                decoration: BoxDecoration(
                  color: book == false
                      ? Colors.blue
                      : const Color.fromARGB(255, 219, 213, 213),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Published Rides",
                    style: book == false
                        ? TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                        : TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ride == null
  //         ? Text("Nulll")
  //         : Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             getBookedRides();
  //                             book = true;
  //                           });
  //                         },
  //                         child: Container(
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                             color: book
  //                                 ? Colors.blue
  //                                 : const Color.fromARGB(255, 219, 213, 213),
  //                             border: Border.all(),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "Booked Rides",
  //                               style: book
  //                                   ? TextStyle(
  //                                       color: Colors.black,
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold)
  //                                   : TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             print('set to false');
  //                             getPublishedRides();
  //                             book = false;
  //                           });
  //                         },
  //                         child: Container(
  //                           height: 50, // Adjusted height for consistency
  //                           decoration: BoxDecoration(
  //                             color: book == false
  //                                 ? Colors.blue
  //                                 : const Color.fromARGB(255, 219, 213, 213),
  //                             border: Border.all(),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               "Published Rides",
  //                               style: book == false
  //                                   ? TextStyle(
  //                                       color: Colors.black,
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold)
  //                                   : TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               // FutureBuilder(
  //               //     future: getBookedRides(),
  //               //     builder: (context, snapshot) {
  //               //       if (snapshot.hasData) {
  //               //         return ListView.builder(
  //               //           itemCount: ride.length,
  //               //           itemBuilder: (context, index) {
  //               //             return RideCard(ride: ride[index]);
  //               //           },
  //               //         );
  //               //       } else{
  //               //         return Center(child: CircularProgressIndicator());
  //               //       }
  //               //     }),
  //               Expanded(
  //                 child: ride.isNotEmpty
  //                     ? ListView.builder(
  //                         itemCount: ride.length,
  //                         itemBuilder: (context, index) {
  //                           print(
  //                               "Ride index: ${index}, and contains: ${ride[index]}");
  //                           return RideCard(
  //                             ride: ride[index],
  //                             fromWhichPage: 1,
  //                           );
  //                         },
  //                       )
  //                     : Center(
  //                         child:
  //                             CircularProgressIndicator(), // Or any loading indicator                   ),[index]
  //                       ),
  //               )
  //             ],
  //           ),
  //   );
  // }
}
