import 'dart:math';

import 'package:flutter/material.dart';

class CalanderScreen extends StatefulWidget {
  const CalanderScreen({super.key});

  @override
  State<CalanderScreen> createState() => _CalanderScreenState();
}

class _CalanderScreenState extends State<CalanderScreen> {

  DateTime? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$date"),
              ElevatedButton(
                  onPressed: () async {
                    DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2027));

                    if (datePicked != null) {
                      print(
                          "Selected datde ${datePicked.day}-${datePicked.month}-${datePicked.year}");
                      setState(() {
                        date = datePicked;
                      });
                    }
                  },
                  child: Icon(Icons.date_range)),
              
              Text("$time"),
              ElevatedButton(onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context, 
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dial
                );

                if(pickedTime!=null){
                  print("Selected Time: ${pickedTime.hour}-${pickedTime.minute}" );
                  setState(() {
                    time = pickedTime;
                  });
                }
              }, child: Text("select time"))
            ],
          ),
        ),
      ),
    );
  }
}
