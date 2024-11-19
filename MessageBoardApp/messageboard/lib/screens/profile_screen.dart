import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(_user.uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.data!.exists) {
              return Center(child: Text('User data not found.'));
            }

            var userData = snapshot.data!;
            var firstName = userData['firstName'] ?? "First Name Not Set";
            var lastName = userData['lastName'] ?? "Last Name Not Set";
            var dobString = userData['dob'] ?? "Date of Birth Not Set"; // Ensure the dob is a String.
            var gender = userData['gender'] ?? "Gender Not Set";

            DateTime? dateOfBirth;
            String dateOfBirthString = dobString != "Date of Birth Not Set"
                ? DateFormat('yyyy-MM-dd').format(DateTime.parse(dobString))
                : dobString;

            if (dobString != "Date of Birth Not Set") {
              try {
                dateOfBirth = DateTime.parse(dobString);
              } catch (e) {
                dateOfBirth = null;
              }
            }

            String age = dateOfBirth != null ? _calculateAge(dateOfBirth).toString() : "Age Not Available";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $firstName $lastName',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('Email: ${_user.email}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text('Gender: $gender', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text('Date of Birth: $dateOfBirthString', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text('Age: $age', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  child: Text('Log Out'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
