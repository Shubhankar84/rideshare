import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/Pages/rideDetails.dart';
import 'package:rideshare/Widgets/rideCard.dart';
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
      body: widget.rides.isEmpty
          ? Center(
              child: Text("No rides avaiable for selected Route"),
            )
          : ListView.builder(
              itemCount: successList.length,
              itemBuilder: (context, index) {
                return RideCard(ride: successList[index], fromWhichPage: 0,);
              },
            ),
    );
  }

}
