import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveTracking extends StatefulWidget {
  final List<dynamic> source;
  final List<dynamic> dest;
  
  const LiveTracking({super.key, required this.source, required this.dest});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  late LatLng sourceLocation;
  late LatLng destLocation;

  List<LatLng> polyLineCoordinates = [];
  LocationData? currentLocation;


  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "google-api-key",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polyLineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    // print("source: ${sourceLocation}");
    super.initState();
    sourceLocation= LatLng(widget.source[0], widget.source[1]);
    destLocation = LatLng(widget.dest[0], widget.dest[1]);
    getPolyPoints();


    print("Source Location in tracking initial: ${sourceLocation}");
    print("Destination Location in tracking initial: ${destLocation}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Tracking"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(sourceLocation.latitude, sourceLocation.longitude),
          zoom: 14,
        ),
        polylines: {
          Polyline(
              polylineId: PolylineId("route"),
              points: polyLineCoordinates,
              color: Colors.blue,
              width: 6),
        },
        markers: {
          // Marker(
          //   infoWindow: InfoWindow(title: "Currentlocation"),
          //     markerId: MarkerId("currentLocation"),
          //     position: LatLng(currentLocation!.latitude!,
          //         currentLocation!.longitude!)),
          Marker(
              infoWindow: InfoWindow(title: "sourcelocation"),
              markerId: MarkerId("source"),
              position: sourceLocation),
          Marker(
            infoWindow: InfoWindow(title: "destinationlocatdion"),
            markerId: MarkerId("Destination"),
            position: destLocation,
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}
