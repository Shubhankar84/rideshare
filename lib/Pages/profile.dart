import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildUserInfoCard(),
            SizedBox(height: 20),
            _buildCarInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildUserInfoRow('First Name', widget.userData['firstName']),
            _buildUserInfoRow('Last Name', widget.userData['lastName']),
            _buildUserInfoRow('Age', widget.userData['age'].toString()),
            _buildUserInfoRow('Mobile No', widget.userData['mobileNo']),
            _buildUserInfoRow('License No', widget.userData['licenseNo']),
            _buildUserInfoRow('Aadhar No', widget.userData['aadharNo']),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildCarInfoCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildCarInfoRow('Car Name', widget.userData['carName']),
            _buildCarInfoRow('Car No', widget.userData['carNo']),
            _buildCarInfoRow('Seats in Car', widget.userData['seatsInCar'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ProfilePage(
//       userData: {
//         'firstName': 'John',
//         'lastName': 'Doe',
//         'age': '30',
//         'mobileNo': '1234567890',
//         'licenseNo': 'ABCD1234',
//         'aadharNo': '123456789012',
//         'carName': 'Toyota Camry',
//         'carNo': 'XYZ123',
//         'seatsInCar': '5',
//       },
//     ),
//   ));
// }
