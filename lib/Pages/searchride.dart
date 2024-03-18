import 'package:flutter/material.dart';
import 'package:rideshare/Widgets/searchBox.dart';

class SearchRide extends StatefulWidget {
  const SearchRide({super.key});

  @override
  State<SearchRide> createState() => _SearchRideState();
}

class _SearchRideState extends State<SearchRide> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBox(),
            Text("Other contents here"),
          ],
        ),
      ),
    );
  }
}
