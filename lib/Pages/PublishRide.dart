import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/Pages/carModel.dart';
import 'package:rideshare/Widgets/searchPlace.dart';
import 'package:rideshare/cartProvider.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/config.dart';
import 'package:rideshare/main.dart';

class PublishRidePage extends StatefulWidget {
  const PublishRidePage({super.key});

  @override
  State<PublishRidePage> createState() => _PublishRidePageState();
}

class _PublishRidePageState extends State<PublishRidePage> {
  int _passengers = 1;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? srcTime;
  TimeOfDay? destTime;

  String? selectedSource;
  String? selectedDest;
  TextEditingController _carNameController = TextEditingController();
  TextEditingController _carNoController = TextEditingController();
  bool validate = false;

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

  Future<List<CarModel>> getCar() async {
    print("Clicked get car");

    // CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    // String? token = cartProvider.token();
    print(Globaltoken);

    Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
    var userId = jwtDecodeToken['_id'];
    var regBody = {
      "userId": userId,
    };

    try {
      var response = await http.post(Uri.parse(getCarDetails),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      final body = json.decode(response.body);
      print(body['data']);

      List<Map<String, dynamic>> carList =
          List<Map<String, dynamic>>.from(body['data']);

      if (response.statusCode == 200) {
        return carList.map((e) {
          final map = e as Map<String, dynamic>;
          return CarModel(sId: map['carName']);
        }).toList(); // Convert Iterable<CarModel> to List<CarModel>
      } else {
        throw Exception(
            'Failed to load cars'); // Throw an exception if response status code is not 200
      }
    } catch (e) {
      print(e.toString());
      throw Exception(
          'Failed to load cars: $e'); // Throw an exception with the specific error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    void publishRide() async {
      String carName = _carNameController.text.trim();
      String carNo = _carNoController.text.trim();

      if (selectedSource != null &&
          selectedDest != null &&
          carName.isNotEmpty &&
          carNo.isNotEmpty) {
        List source = [
          provider.source2['latitude'],
          provider.source2['longitude']
        ];
        List dest = [provider.dest2['latitude'], provider.dest2['longitude']];

        print('source lat long: $source');
        print('source lat dest: $dest');
        print("selected source: $selectedSource");
        print("selected source: $srcTime");

        print("selected source: $selectedDate");
        print("selected source: $selectedDest");
        print("selected source: $destTime");
        print("selected source: $_passengers");
        print("selected source: $carName");
        print("selected source: $carNo");
        validate = true;
        Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
        var userId = jwtDecodeToken['_id'];
        print('scrtimehourrrrrrr: ${srcTime!.hour}:${srcTime!.minute}');

        var regBody = {
          "userId": userId,
          "source": source,
          "dest": dest,
          "srcAdd":selectedSource,
          "destAdd": selectedDest,
          "srcTime": "${srcTime!.hour}:${srcTime!.minute}",
          "destTime": "${destTime!.hour}:${destTime!.minute}",
          "date":
              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
          "carName":carName,
          "carNo": carNo,
          "seats": _passengers,
          "price": 300,
        };

        var response = await http.post(Uri.parse(createRide),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);
        print("json response:");
        print(jsonResponse['status']);

        setState(() {});
      } else {
        validate = false;
        setState(() {});
        print("all fields are mandatory");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Publish a ride",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: Padding(
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
                      const Text(
                        "Add Pickup Location Details",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // for selecting source
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const GoogleMapSearchPlacesApi(
                                str: "source", n: 1);
                          }));
                          setState(() {
                            selectedSource = provider.source2['add'];
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
                              const Icon(Icons.location_city,
                                  color: Colors.grey),
                              const SizedBox(width: 8.0),
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
                      // Time for source
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dial);

                          if (pickedTime != null) {
                            print(
                                "Selected Time: ${pickedTime.hour}-${pickedTime.minute}");
                            setState(() {
                              srcTime = pickedTime;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.symmetric(),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.time_to_leave, color: Colors.grey),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  srcTime == null
                                      ? "Departure Time"
                                      : "${srcTime!.hour}:${srcTime!.minute}",
                                  style: srcTime == null
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

                      SizedBox(
                        height: 20,
                      ),
                      Text("Add Destination Location Details",
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      SizedBox(
                        height: 10,
                      ),

                      // for selecting destination
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GoogleMapSearchPlacesApi(str: "dest", n: 1);
                          }));
                          setState(() {
                            selectedDest = provider.dest2['add'];
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
                      // Time for destination
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dial);

                          if (pickedTime != null) {
                            print(
                                "Selected Time: ${pickedTime.hour}-${pickedTime.minute}");
                            setState(() {
                              destTime = pickedTime;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.symmetric(),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.time_to_leave, color: Colors.grey),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  destTime == null
                                      ? "Departure Time"
                                      : "${destTime!.hour}:${destTime!.minute}",
                                  style: destTime == null
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
                      SizedBox(
                        height: 20,
                      ),
                      Text("Select Date and Passangers Count",
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align fields on same line
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
                                  fontSize: 20,
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
                      Text(
                        "Add your car Details",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),

                      TextField(
                        controller: _carNameController,
                        decoration: InputDecoration(
                          labelText: 'Car Name',
                          // border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _carNoController,
                        decoration: InputDecoration(
                          labelText: 'Car Name',
                          // border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      validate == false
                          ? Text(
                              "all fields are mandatory",
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(""),

                      TextButton(
                        onPressed: () {
                          // Add your onPressed logic here
                          publishRide();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Change the background color
                          primary: Colors.white, // Change the text color
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24), // Add padding
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8)), // Add rounded corners
                        ),
                        child: Text(
                          'Publish Ride',
                          style: TextStyle(
                              fontSize: 16), // Optional: Change text style
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
