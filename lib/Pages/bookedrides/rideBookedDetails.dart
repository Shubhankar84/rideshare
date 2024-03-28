import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/main.dart';

class BookedRideDetails extends StatefulWidget {
  final Map<String, dynamic> rideInfo;
  const BookedRideDetails({super.key, required this.rideInfo});

  @override
  State<BookedRideDetails> createState() => _BookedRideDetailsState();
}

class _BookedRideDetailsState extends State<BookedRideDetails> {
  int seatsAvailable = 0;
  List requests = [];
  double h = 100;
  bool showRideDetails = false;

  void addRequest() {
    Map<String, dynamic> jwtDecodeToken =
        JwtDecoder.decode(Globaltoken.toString());
    var userId = jwtDecodeToken['_id'];

    // Iterate through the requestedBooking list
    for (var booking in widget.rideInfo['requestedBooking']) {
      // Check if the userId matches
      if (booking['userId'] == userId) {
        // Add the booking to the requests list
        requests.add(booking);
      }
    }

    // Print the requests list
    print("Requests: $requests");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Ride info inside of ride details page: ");
    print(widget.rideInfo);
    seatsAvailable = widget.rideInfo['seats'] - widget.rideInfo['bookedSeats'];
    addRequest();
    print("Request length is: ${requests.length}");
    h = requests.length * 80;
    print(h);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Source:  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.rideInfo['srcAdd']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Destination:  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.rideInfo['destAdd']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Seats"),
              //     Text("Date"),
              //     Text("Status"),
              //   ],
              // ),
              Container(
                height: h,
                child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: ((context, index) {
                      print(
                          "Request at index ${index}, seats: ${requests[index]['reqseats']}");
                      print(
                          "Request at index ${index}, seats: ${requests[index]['status']}");
                      var st = requests[index]['status'];
                      return Column(
                        children: [
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: (st == 'Requested')
                                    ? Colors.yellow
                                    : (st == "Approved")
                                        ? Colors.green
                                        : Colors.red,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          'Seats: ${requests[index]['reqseats']}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('12-14-2024'),
                                    ],
                                  ),
                                  Text('${requests[index]['status']}'),
                                  Icon((st == "Requested")
                                      ? Icons.pending_actions_rounded
                                      : (st == "Approved")
                                          ? Icons.check
                                          : Icons.close)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    })),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("View Ride Details"),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showRideDetails = !showRideDetails;
                      });
                    },
                    child: Icon((showRideDetails == false)
                        ? Icons.arrow_drop_down_circle_rounded
                        : Icons.arrow_circle_up_outlined),
                  ),
                ],
              ),

              (showRideDetails == true)
                  ? Column(
                      children: [
                        _buildDetailItem(
                            'Source', '${widget.rideInfo['srcAdd']}'),
                        _buildDetailItem(
                            'Destination', '${widget.rideInfo['destAdd']}'),
                        _buildDetailItem(
                            'Source Time', '${widget.rideInfo['srcTime']}'),
                        _buildDetailItem('Destination Time',
                            '${widget.rideInfo['destTime']}'),
                        SizedBox(height: 20),
                        _buildDetailItem('Price for 1 Passenger',
                            '${widget.rideInfo['price']}'),
                        _buildDetailItem('Seats Available', '$seatsAvailable'),

                        SizedBox(height: 20),
                        _buildDetailItem(
                            'Date of Ride', '${widget.rideInfo['date']}'),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 10),
                        Text(
                          'Rider Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                      ],
                    )
                  : Text("")
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
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
