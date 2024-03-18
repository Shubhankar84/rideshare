import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/Widgets/searchPlace.dart';
import 'package:rideshare/cartProvider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Publish a ride",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
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
                    Text(
                      "Add Pickup Location Details",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // for selecting source
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return GoogleMapSearchPlacesApi(str: "source");
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
                          return GoogleMapSearchPlacesApi(str: "dest");
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
                      decoration: InputDecoration(hintText: "Car Name"),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
