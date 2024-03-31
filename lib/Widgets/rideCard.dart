import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rideshare/Pages/bookedrides/rideBookedDetails.dart';
import 'package:rideshare/Pages/rideDetails.dart';

class RideCard extends StatefulWidget {
  final int fromWhichPage;
  final Map<String, dynamic> ride;
  const RideCard({super.key, required this.ride, required this.fromWhichPage});

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  int requests = 0;

  void calculateRequestBookingCount() {
    for (var booking in widget.ride['requestedBooking']) {
      if (booking['status'] == 'Requested') {
        requests++;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside ride card ${widget.ride.length}");
    print("${widget.ride}");
    if (widget.fromWhichPage == 2) {
      calculateRequestBookingCount();
    }
    print("Requests for ride is: $requests");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
            if (widget.fromWhichPage == 0) {
              return RideDetailsPage(rideInfo: widget.ride);
            } else {
              return BookedRideDetails(rideInfo: widget.ride);
            }
          })));
        },
        child: Container(
          height: 225,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                // Row for riders name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_2),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "${widget.ride['userDetails'][0]["personalInformation"]["firstName"]}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.ride['price']}',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),

                // A row for time of dest, src and its address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.ride['srcTime']}",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            'https://cdn.vectorstock.com/i/preview-1x/39/01/car-vehicle-speed-line-style-icon-vector-32303901.jpg')),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.ride['destTime']}",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("${widget.ride['srcAdd']}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Text('${widget.ride['destAdd']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (widget.fromWhichPage == 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 216, 212, 212),
                                ),
                                child: Center(child: Text('Started')),
                              ),
                              Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 216, 212, 212),
                                ),
                                child: Center(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        '${widget.ride['seats'] - widget.ride['bookedSeats']}'),
                                  ],
                                )),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 216, 212, 212),
                                ),
                                child: Center(child: Text('Requested')),
                              ),
                            ],
                          )
                        : (widget.fromWhichPage == 2)
                            ? Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // for published rides
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 216, 212, 212),
                                      ),
                                      child: Center(
                                          child: Text('Pending: $requests')),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 216, 212, 212),
                                      ),
                                      child: Center(
                                          child: Text(
                                              'Booked: ${widget.ride['bookedSeats']}/${widget.ride['seats']}')),
                                    )
                                  ],
                                ),
                              )
                            : Expanded(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // for booked rides i.e. fromwhichpage is 1 here
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 216, 212, 212),
                                      ),
                                      child: Center(child: Text('Started')),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 216, 212, 212),
                                      ),
                                      child: Center(
                                          child: Text(
                                              'Requested')),
                                    )
                                  ],
                                ),
                            )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String name, String age, String rating, String imageUrl) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 216, 212, 212),
      ),
      child: Center(child: Text('Requested')),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // If ride is null, return an empty container
  //   if (widget.ride.isEmpty) {
  //     return Container(
  //       child: Text("Ride is empty"),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
  //     child: GestureDetector(
  //       onTap: () {
  //         Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
  //           if (widget.fromWhichPage == 0) {
  //             return RideDetailsPage(rideInfo: widget.ride);
  //           }else{
  //             return BookedRideDetails(rideInfo: widget.ride);
  //           }
  //         })));
  //       },
  //       child: Card(
  //         color: Colors.white,
  //         elevation: 5,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //           height: 200,
  //           decoration: BoxDecoration(
  //             // border: Border.all(), // Optional border
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Text(
  //                         "${widget.ride['srcTime']}",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 25,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       Text("${widget.ride['destTime']}",
  //                           style: TextStyle(
  //                               color: Colors.grey,
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold)),
  //                       SizedBox(
  //                         height: 12,
  //                       ),
  //                       Text("${widget.ride['destTime']}",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 25,
  //                               fontWeight: FontWeight.bold))
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       height: 100,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "${widget.ride['srcAdd']}",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold),
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 1,
  //                           ),
  //                           Text(
  //                             "${widget.ride['destAdd']}",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold),
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 1,
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Text("${widget.ride['price']}",
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold))
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               Row(
  //                 children: [
  //                   Icon(Icons.person),
  //                   SizedBox(
  //                     width: 15,
  //                   ),
  //                   Column(
  //                     children: [
  //                       Text(
  //                           "${widget.ride['userDetails'][0]["personalInformation"]["firstName"]}",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.bold)),
  //                       Text("${widget.ride['carName']}",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.bold))
  //                     ],
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
