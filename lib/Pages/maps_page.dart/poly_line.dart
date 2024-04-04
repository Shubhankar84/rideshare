import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLine extends StatefulWidget {
  const PolyLine({super.key});

  @override
  State<PolyLine> createState() => _PolyLineState();
}

class _PolyLineState extends State<PolyLine> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.02356532918498, 73.1912035938426),
    zoom: 14,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLine = {}; // Fixed the class name here

  List<LatLng> _latlng = [
    LatLng(19.02356532918498, 73.1912035938426),
    LatLng(19.011508896103162, 73.17096236027798),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _latlng.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latlng[i],
          infoWindow: InfoWindow(title: "PolyLine"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    // Add Polyline
    _polyLine.add(
      Polyline(
        polylineId: PolylineId('polyline'),
        color: Colors.blue,
        points: _latlng,
        width: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PolyLine in GMaps"),
      ),
      body: SafeArea(
        child: GoogleMap(
          markers: _markers,
          polylines: _polyLine,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
        ),
      ),
    );
  }
}
