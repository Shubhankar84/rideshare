import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rideshare/Pages/calanderScreen.dart';
import 'package:rideshare/Pages/carSearchResult.dart';
import 'package:rideshare/Widgets/searchPlace.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/cartProvider.dart';
import 'package:rideshare/config.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  int _passengers = 1;
  DateTime selectedDate = DateTime.now();
  String? selectedSource;
  String? selectedDest;

  void _incrementPassengers() {
    setState(() {
      _passengers++;
    });
  }

  void _decrementPassengers() {
    setState(() {
      if (_passengers > 1) {
        _passengers--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    // Future<List<dynamic>> getRides() async {
    //   var regBody = {
    //     "source": [provider.source['latitude'], provider.source['longitude']],
    //     "dest": [provider.dest['latitude'], provider.dest['longitude']]
    //   };
    //   print("Inside getRides searching");

    //   var response = await http.post(Uri.parse(searchRides),
    //       headers: {"Content-Type": "application/json"},
    //       body: jsonEncode(regBody));

    //   var jsonResponse = jsonDecode(response.body);
    //   print("json response:");
    //   print(jsonResponse['status']);

    //   List<dynamic> rides = jsonResponse['success'];
    //   print(rides);
    //   return rides;
    // }

    void search() async {
      print(
          "source:${selectedSource}, dest: ${selectedDest}, date: ${selectedDate}, _passanger: ${_passengers}");
      if (selectedSource != null && selectedDest != null) {
        // List<dynamic> ride = await getRides();

        // get ride function here
        var regBody = {
          "source": [provider.source['latitude'], provider.source['longitude']],
          "dest": [provider.dest['latitude'], provider.dest['longitude']],
          "date": "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}"
        };
        print("Inside getRides searching");

        var response = await http.post(Uri.parse(searchRides),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);
        print("json response:");
        print(jsonResponse['status']);
        // List<dynamic> sourceCoordinates = jsonResponse['success'][0]["source"];
        // double latitude = sourceCoordinates[0];
        // double longitude = sourceCoordinates[1];

        // List<Placemark> placemarks =
        //     await placemarkFromCoordinates(latitude, longitude);

            // print(placemarks.reversed.last.country.toString());
            // print(placemarks.reversed.last.locality.toString());

            // print(placemarks.reversed.last.name.toString());

            // print(placemarks.reversed.last.postalCode.toString());

            // print(placemarks.reversed.last.street.toString());

        // List rides = jsonResponse['success'];
        // print(rides);
        // ends here

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CarSearchResult(
            rides: jsonResponse,
          );
        }));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Card(
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // for selecting source
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GoogleMapSearchPlacesApi(str: "source", n: 0,);
                  }));
                  setState(() {
                    selectedSource = provider.source['add'];
                    print("selected source: ${selectedSource}");
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.symmetric(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          selectedSource == null
                              ? "Search your Source"
                              : "${selectedSource}",
                          style: selectedSource == null
                              ? TextStyle(color: Colors.grey)
                              : TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // for selecting destination
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GoogleMapSearchPlacesApi(str: "dest", n: 0,);
                  }));
                  setState(() {
                    selectedDest = provider.dest['add'];
                    print("selected destinatio: ${selectedDest}");
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.symmetric(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          selectedDest == null
                              ? "Search your destination"
                              : "${selectedDest}",
                          style: selectedDest == null
                              ? TextStyle(color: Colors.grey)
                              : TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align fields on same line
                children: [
                  Flexible(
                      // Wrap Date field in Flexible to prevent overflow
                      child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            DateTime? datePicked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2027));

                            if (datePicked != null) {
                              print(
                                  "Selected datde ${datePicked.day}-${datePicked.month}-${datePicked.year}");
                              setState(() {
                                selectedDate = datePicked;
                              });
                            }
                          },
                          icon: Icon(Icons.date_range)),
                      SizedBox(
                        width: 0,
                      ),
                      Text(
                        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(width: 5), // Add spacing between fields
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 3),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _decrementPassengers,
                      ),
                      Text(
                        '$_passengers',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _incrementPassengers,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement search button functionality
                  search();
                },
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
