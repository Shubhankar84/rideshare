// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:http/http.dart' as http;
// import 'package:rideshare/config.dart';
// import 'package:rideshare/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen2 extends StatefulWidget {
//   final token;
//   const HomeScreen2({super.key, required this.token});

//   @override
//   State<HomeScreen2> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen2> {
//   late String userId;
//   TextEditingController _todoTitle = TextEditingController();
//   TextEditingController _todoDesc = TextEditingController();
//   List? items;
//   late SharedPreferences prefs;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
//     userId = jwtDecodeToken['_id'];
//     getTodoList(userId);
//   }

//   void logout() async {
//     try {
//       // Remove authentication data from local storage
//       WidgetsFlutterBinding.ensureInitialized();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('token');
//       await prefs.remove('userId'); // Add/remove other stored sensitive data

//       // Clear navigation stack and go to login screen
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//         ModalRoute.withName('/'),
//       );

//       // Show a success message (optional)

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Logged out successfully!'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } catch (error) {
//       // Handle errors gracefully
//       print(error);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An error occurred while logging out.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   void addTodo() async {
//     if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
//       var regBody = {
//         "userId": userId,
//         "title": _todoTitle.text,
//         "desc": _todoDesc.text,
//       };

//       var response = await http.post(Uri.parse(addtodo),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode(regBody));

//       var jsonResponse = jsonDecode(response.body);
//       print(jsonResponse['status']);

//       if (jsonResponse['status']) {
//         _todoDesc.clear();
//         _todoTitle.clear();
//         getTodoList(userId);
//       } else {
//         print("Someting went wrong");
//       }
//     }
//   }

//   void getTodoList(userId) async {
//     var regBody = {
//       "userId": userId,
//     };

//     var response = await http.post(Uri.parse(getToDoList),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(regBody));

//     var jsonResponse = jsonDecode(response.body);
//     print("json response:");
//     print(jsonResponse['status']);

//     items = jsonResponse['success'];

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () {
//                 // Show the alert dialog
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     // Create the AlertDialog
//                     return AlertDialog(
//                       title: Text("Sign Out"),
//                       content: Text("Are you sure you want to sign out?"),
//                       actions: [
//                         // Yes button
//                         TextButton(
//                           onPressed: () {
//                             // Close the dialog
//                             Navigator.of(context).pop();
//                             // Call the logout function
//                             logout();
//                           },
//                           child: Text("Yes"),
//                         ),
//                         // No button
//                         TextButton(
//                           onPressed: () {
//                             // Close the dialog
//                             Navigator.of(context).pop();
//                           },
//                           child: Text("No"),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: items == null
//           ? Text("No To do list Created")
//           : Container(
//               child: ListView.builder(
//                   itemCount: items!.length,
//                   itemBuilder: ((context, index) {
//                     return Card(
//                       child: ListTile(
//                         title: Text('${items![index]['title']}'),
//                         subtitle: Text('${items![index]['desc']}'),
//                       ),
//                     );
//                   })),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text('Create To Do'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _todoTitle,
//                     decoration: InputDecoration(hintText: 'Enter title'),
//                   ),
//                   SizedBox(height: 10), // Add spacing between fields
//                   TextField(
//                     controller: _todoDesc,
//                     decoration: InputDecoration(hintText: 'Enter description'),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     // Handle to-do creation logic here
//                     addTodo();
//                     Navigator.pop(context); // Close the dialog
//                   },
//                   child: const Text('Create'),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
