import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/Pages/HomeScreen.dart';
import 'package:rideshare/Pages/searchride.dart';
import 'package:rideshare/cartProvider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GoogleMapSearchPlacesApi extends StatefulWidget {
  final int n;
  final String str;
  const GoogleMapSearchPlacesApi(
      {super.key, required this.str, required this.n});

  @override
  _GoogleMapSearchPlacesApiState createState() =>
      _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = "AIzaSyAmEZHkjwzmxDhXDVtfnkDXTIyZCfnCtrk";

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Search places Api',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search your location here",
                focusColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: const Icon(Icons.map),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    List<Location> locations = await locationFromAddress(
                        _placeList[index]['description']);
                    // location[0] = locations.last.longitude;
                    // location[1] = locations.last.latitude;
                    print("location add: ${_placeList[index]['description']}");
                    if (widget.n == 0) {
                      if (widget.str == "source") {
                        provider.source['latitude'] = locations.last.latitude;
                        provider.source['longitude'] = locations.last.longitude;
                        provider.source['add'] =
                            _placeList[index]['description'];
                      }
                      if (widget.str == "dest") {
                        provider.dest['latitude'] = locations.last.latitude;
                        provider.dest['longitude'] = locations.last.longitude;
                        provider.dest['add'] = _placeList[index]['description'];
                      }
                    }
                    else{
                      if (widget.str == "source") {
                        provider.source2['latitude'] = locations.last.latitude;
                        provider.source2['longitude'] = locations.last.longitude;
                        provider.source2['add'] =
                            _placeList[index]['description'];
                      }
                      if (widget.str == "dest") {
                        provider.dest2['latitude'] = locations.last.latitude;
                        provider.dest2['longitude'] = locations.last.longitude;
                        provider.dest2['add'] = _placeList[index]['description'];
                      }
                    }

                    print("source cartProvider: ${provider.source}");
                    print("dest cartProvider: ${provider.dest}");
                    print(locations.last.latitude);
                    print(locations.last.longitude);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
