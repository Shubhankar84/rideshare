import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation =
      LatLng(18.99146144812386, 73.11599850654602);
  static const LatLng destLocation =
      LatLng(19.002721833200685, 73.12537014484406);

  List<LatLng> polyLineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((value) {
      log("$value");
      currentLocation = value;
    });
    setState(() {
      
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
            zoom: 14),
      ));

    setState(() {});
    });
  }

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
    // TODO: implement initState
    // getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Tracking"),
      ),
      body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    sourceLocation.latitude, sourceLocation.longitude),
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
