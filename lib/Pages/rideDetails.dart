import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rideshare/Pages/bookedrides/bookedRides.dart';
import 'package:rideshare/Pages/maps_page.dart/tracking.dart';
import 'package:rideshare/config.dart';
import 'package:http/http.dart' as http;
import 'package:rideshare/main.dart';

class RideDetailsPage extends StatefulWidget {
  final Map<String, dynamic> rideInfo;

  const RideDetailsPage({super.key, required this.rideInfo});

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  int seatsAvailable = 0;
  int seatsToBook = 1;
  bool isLoading = false;
  String msg = "Request to book a ride";

  void decrement() {
    if (seatsToBook > 1) {
      seatsToBook--;
      setState(() {});
    }
  }

  void increment() {
    if (seatsToBook < seatsAvailable) {
      seatsToBook++;
      setState(() {});
    } else {
      print("maximum passangers allowed are $seatsAvailable");
    }
  }

  void sentRequest() async {
    showQuickAlert(QuickAlertType.loading, 'Sending request....', '');
    Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
    var userId = jwtDecodeToken['_id'];
    try {
      isLoading = true;
      setState(() {});
      var regBody = {
        "_id": widget.rideInfo['_id'],
        "userId": userId,
        "seats": seatsToBook
      };
      print("Inside request rides requesting a ride to be booked");

      var response = await http.post(Uri.parse(requestride),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      print("json response:");
      print(jsonResponse['status']);
      isLoading = false;
      setState(() {});
      if (jsonResponse['status']) {
        msg = 'Request sent successfllly';
        setState(() {});
        Navigator.pop(context);
        showQuickAlert(QuickAlertType.success, "Requested successfully",
            "Request sent successfully");
        // Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
        //   return BookedRides();
        // })));
      } else {
        Navigator.pop(context);
        showQuickAlert(QuickAlertType.error, "error", "error occured");
      }
    } catch (e) {
      print(e);
    }
  }

  requestRide() async {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: "Do you want to request to book a ride",
        confirmBtnText: 'Yes',
        confirmBtnColor: Colors.green,
        cancelBtnText: 'No',
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
        onConfirmBtnTap: () {
          Navigator.pop(context);
          sentRequest();
        });
  }

  void showQuickAlert(
      QuickAlertType quickAlertType, String title, String subtitle) {
    QuickAlert.show(
        context: context, title: title, text: subtitle, type: quickAlertType);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Ride info inside of ride details page: ");
    print(widget.rideInfo);
    seatsAvailable = widget.rideInfo['seats'] - widget.rideInfo['bookedSeats'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Source', '${widget.rideInfo['srcAdd']}'),
              _buildDetailItem('Destination', '${widget.rideInfo['destAdd']}'),
              _buildDetailItem('Source Time', '${widget.rideInfo['srcTime']}'),
              _buildDetailItem(
                  'Destination Time', '${widget.rideInfo['destTime']}'),
              SizedBox(height: 20),
              _buildDetailItem(
                  'Price for 1 Passenger', '${widget.rideInfo['price']}'),
              _buildDetailItem('Seats Available', '$seatsAvailable'),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Select Seats: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // Handle removing seats
                      decrement();
                    },
                  ),
                  Text(
                    '$seatsToBook',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Handle adding seats
                      increment();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDetailItem('Date of Ride', '${widget.rideInfo['date']}'),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Rider Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildRiderTile(
                  '${widget.rideInfo['userDetails'][0]['personalInformation']['firstName']}',
                  '${widget.rideInfo['userDetails'][0]['personalInformation']['age']}',
                  '4.5',
                  'https://listcarbrands.com/wp-content/uploads/2015/10/BMW-Log%D0%BE.png'),
              // _buildRiderTile('Bob', '35', '4.2',
              //     'https://listcarbrands.com/wp-content/uploads/2015/10/BMW-Log%D0%BE.png'),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Car Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: CircleAvatar(
                  child: Text('C'),
                ),
                title: Text(
                    '${widget.rideInfo['userDetails'][0]['carDetails'][0]['carName']}'),
                subtitle: Text('Color: Red'),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                    print('Source location to send to live maps: ${widget.rideInfo['source']}');
                    print('Dest location to send to live maps: ${widget.rideInfo['dest']}');
                    return LiveTracking(source: widget.rideInfo['source'], dest: widget.rideInfo['dest']);
                  })));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'See route on maps',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    Container(
                      height: 60,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://static.vecteezy.com/system/resources/thumbnails/020/995/200/small/3d-minimal-map-icon-navigation-icon-marking-a-position-map-with-a-location-pin-icon-3d-rendering-illustration-png.png'),
                                  fit: BoxFit.fill
                                  )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 10, right: 10),
              //   width: MediaQuery.of(context).size.width,
              //   height: 50,
              //   child: ElevatedButton(onPressed: (){

              //   },
              //   child: isLoading? CircularProgressIndicator(color: Colors.white,) : Text(msg),
              //   ),
              // )
              GestureDetector(
                onTap: () {
                  if (seatsAvailable > 0) {
                    requestRide();
                  } else {
                    print("Cannot book a ride as ride is booked already");
                  }
                },
                child: Container(
                  width:
                      double.infinity, // Make the container take the full width
                  height: 50, // Set the height of the container
                  decoration: BoxDecoration(
                    color: seatsAvailable > 0
                        ? Colors.blue
                        : Colors.grey, // Set the background color
                    borderRadius: BorderRadius.circular(
                        8), // Set border radius to create rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Add shadow
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            msg,
                            style: TextStyle(
                              color: Colors.white, // Set text color
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderTile(
      String name, String age, String rating, String imageUrl) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age: $age'),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              SizedBox(width: 5),
              Text(
                rating,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
