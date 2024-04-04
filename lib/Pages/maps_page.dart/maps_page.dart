import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapsRoute extends StatefulWidget {
  const ShowMapsRoute({super.key});

  @override
  State<ShowMapsRoute> createState() => ShowMapsRouteState();
}

class ShowMapsRouteState extends State<ShowMapsRoute> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(19.023498518721105, 73.19119730074328),
        infoWindow: InfoWindow(title: 'Current location')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(18.99134598362926, 73.12071866954028),
        infoWindow: InfoWindow(title: 'Panvel station'))
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          markers: Set<Marker>.of(_marker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(19.023498518721105, 73.19119730074328),
                zoom: 14,
              ),
            ),
          );
        },
        child: Icon(Icons.location_searching_sharp),
      ),
    );
  }
}
