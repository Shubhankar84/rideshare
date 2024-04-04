import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({super.key});

  @override
  State<CustomMarkerScreen> createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  Uint8List? markerImage;

  List<String> images = ['assets/Car.png'];

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlang = <LatLng>[
    LatLng(19.02356532918498, 73.1912035938426),
    LatLng(19.011508896103162, 73.17096236027798),
    LatLng(19.01460530598159, 73.2010379658379),
    LatLng(19.009030996940673, 73.14628742656134),
  ];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.02356532918498, 73.1912035938426),
    zoom: 14,
  );

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async{
    for(int i=0; i<_latlang.length; i++){
      
      final Uint8List markerIcon = await getBytesFromAsset(images[0], 100);

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latlang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
            title: "Marker: " + i.toString()
          )
        
        )
      );
    }

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
