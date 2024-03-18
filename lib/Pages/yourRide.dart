import 'package:flutter/material.dart';

class YourRidesPage extends StatefulWidget {
  const YourRidesPage({super.key});

  @override
  State<YourRidesPage> createState() => _YourRidesPageState();
}

class _YourRidesPageState extends State<YourRidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Rides"),
      ),
    );
  }
}