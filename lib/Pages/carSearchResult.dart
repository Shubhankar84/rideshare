import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/cartProvider.dart';
import 'package:rideshare/config.dart';

class CarSearchResult extends StatefulWidget {
  final Map rides;
  const CarSearchResult({super.key, required this.rides});

  @override
  State<CarSearchResult> createState() => _CarSearchResultState();
}

class _CarSearchResultState extends State<CarSearchResult> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("---------------- Inside of car search resul printing the rides ");
    print(widget.rides);
  }

  @override
  Widget build(BuildContext context) {

    final List<dynamic> successList = widget.rides['success'];
    print("Length of success list: ${successList.length}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Rides"),
      ),
      body: widget.rides.isEmpty || widget.rides == null
          ? Center(
              child: Text("No rides avaiable for selected Route"),
            )
          : ListView.builder(
            itemCount: successList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      height: 200,
                      decoration: BoxDecoration(
                        // border: Border.all(), // Optional border
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "14.00",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("3h00",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text("17:00",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${successList[index]['srcAdd']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text("${successList[index]['destAdd']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ),
                              Text("Rs 300.00",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle),
                              Column(
                                children: [
                                  Text('Shubhankar',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text("Rating: 4.5",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
