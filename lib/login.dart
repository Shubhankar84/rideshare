import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rideshare/Pages/HomeScreen.dart';
import 'package:rideshare/config.dart';
import 'package:rideshare/homescreen.dart';
import 'package:rideshare/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _passwordVisible = false;
  bool status = false;
  String error = "";
  bool _validated = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    log(emailController.text);
    log(passwordController.text);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        print(response.statusCode);
        print(prefs.getString("token"));
        // checkUserPersonalDetails(myToken);

        //------------------------Check if userDetails is already present or not
        Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(myToken);
        var userId = jwtDecodeToken['_id'];
        var regBody = {
          "userId": userId,
        };

        var response2 = await http.post(Uri.parse(checkPersonalDetails),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse2 = jsonDecode(response2.body);

        print(jsonResponse2['status']);
        print(jsonResponse2);
        _validated = jsonResponse2['status'];
        // ----------------------ends here ----------------------------------

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      token: myToken,
                      validated: _validated,
                    )));
      } else {
        setState(() {
          var jsonResponse = jsonDecode(response.body);
          error = jsonResponse['error'];
          status = true;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  // void checkUserPersonalDetails(token) async {
  //   Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token);
  //   var userId = jwtDecodeToken['_id'];
  //   var regBody = {
  //     "userId": userId,
  //   };

  //   var response = await http.post(Uri.parse(checkPersonalDetails),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(regBody));

  //   var jsonResponse = jsonDecode(response.body);

  //   print(jsonResponse['status']);
  //   print(jsonResponse);
  //   _validated = jsonResponse['status'];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  const Image(
                    image: NetworkImage(
                        "https://img.freepik.com/free-vector/carpool-concept-illustration_114360-9919.jpg?size=626&ext=jpg&ga=GA1.1.87170709.1707782400&semt=ais"),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email Address", icon: Icon(Icons.person)),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Email cannot be empty";
                      }

                      if (text.length < 2) {
                        return "Please enter a valid email";
                      }

                      if (text.length > 99) {
                        return "Email cant be more than 100 characters";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              // update the state i.e. toggle the state of passwordVisible variable
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (status)
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      loginUser();
                    },
                    color: Colors.blue,
                    child: Text("Log In"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Create an Account"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard {}
