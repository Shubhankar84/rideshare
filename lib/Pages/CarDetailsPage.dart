import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/HomeScreen.dart';
import 'package:rideshare/config.dart';
import 'package:http/http.dart' as http;

class CarDetailsPage extends StatefulWidget {
  final token;
  
  const CarDetailsPage({super.key, required this.token});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late String userId;

  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carNoController = TextEditingController();
  final TextEditingController _seatsInCarController = TextEditingController();

  bool _carDetailsEntered = false;
  bool _validated = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = widget.token;
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['_id'];
  }

  void _saveUserDetails() async {
    if (_validateCarFields()) {
      print("validate car successfully");

      var regBody = {
        "userId": userId,
        "carDetails": [
          {
            "carName": _carNameController.text,
            "carNo": _carNoController.text,
            "seats": _seatsInCarController.text,
          }
        ],
      };

      var response = await http.post(Uri.parse(updateCarDetails),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);
      print(jsonResponse);

      checkUserPersonalDetails(widget.token);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen(token:widget.token, validated: _validated,)));
      } else {
        print("Someting went wrong");
      }
    } else {
      showToastMsg("All fields are required");
    }
  }

  void checkUserPersonalDetails(token) async {
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token);
    var userId = jwtDecodeToken['_id'];
    var regBody = {
      "userId": userId,
    };

    var response = await http.post(Uri.parse(checkPersonalDetails),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);
    print(jsonResponse);
    _validated = jsonResponse['status'];
  }

  bool _validateCarFields() {
    if (_carDetailsEntered &&
        (_carNameController.text.isEmpty ||
            _carNoController.text.isEmpty ||
            _seatsInCarController.text.isEmpty)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add your Car Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildCarInputField('Car Name', _carNameController),
          SizedBox(height: 10),
          _buildCarInputField('Car No', _carNoController),
          SizedBox(height: 10),
          _buildNumericInputField('Seats in Car', _seatsInCarController),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Implement save functionality
              _saveUserDetails();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCarInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontSize: 16),
      onChanged: (value) {
        setState(() {
          _carDetailsEntered = _carNameController.text.isNotEmpty ||
              _carNoController.text.isNotEmpty ||
              _seatsInCarController.text.isNotEmpty;
        });
      },
      validator: (_) {
        if (_carDetailsEntered &&
            (_carNameController.text.isEmpty ||
                _carNoController.text.isEmpty ||
                _seatsInCarController.text.isEmpty)) {
          return 'All car details are required if any parameter is entered';
        }
        return null;
      },
    );
  }

  Widget _buildNumericInputField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(fontSize: 16),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  void showToastMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Perform some undo action
          },
        ),
      ),
    );
  }
}
