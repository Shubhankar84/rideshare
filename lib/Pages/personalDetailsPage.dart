import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/CarDetailsPage.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/login.dart';
// import 'package:toast/toast.dart';

class UserDetailsPage extends StatefulWidget {
  final token;

  const UserDetailsPage({super.key, required this.token});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late String userId;

  
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _licenseNoController = TextEditingController();
  final TextEditingController _aadharNoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = widget.token;
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['_id'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField('First Name *', _firstNameController),
              const SizedBox(height: 10),
              _buildInputField('Last Name *', _lastNameController),
              const SizedBox(height: 10),
              _buildNumericInputField('Age *', _ageController),
              const SizedBox(height: 10),
              _buildNumericInputField('Mobile No *', _mobileNoController),
              const SizedBox(height: 10),
              _buildInputField('License No', _licenseNoController),
              const SizedBox(height: 10),
              _buildNumericInputField('Aadhar No', _aadharNoController),
              const SizedBox(height: 30),
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
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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

  void _saveUserDetails() async {
    if (_validatePersonalFields()) {
      // Show a toast message indicating successful save
      print("User Personal details validated successfully");

        var regBody = {
          "userId": userId,
          "personalInformation": {
            "firstName": _firstNameController.text,
            "lastName": _lastNameController.text,
            "age": _ageController.text,
            "mobile": _mobileNoController.text,
            "LiscenseNo": _licenseNoController.text,
            "aadharNo": _aadharNoController.text
          },
        };

        var response = await http.post(Uri.parse(updatePersonalDetails),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);

        // print(jsonResponse['status']);
        // print(jsonResponse);

        if (jsonResponse['status']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CarDetailsPage(token:widget.token)));
              print("Saved user successfully");
        } else {
          print("Someting went wrong");
        }
        
    }
    else {
      // Show a toast message indicating validation error
      print("All fields are required");
      showToastMsg("All fields are required");
    }
  }

  bool _validatePersonalFields() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _mobileNoController.text.isNotEmpty;
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
