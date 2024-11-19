import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  
  late User _user;
  
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _emailController.text = _user.email ?? '';
  }

  Future<void> _updateEmail() async {
    try {
      await _user.updateEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email updated successfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating email: $e")));
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match.")));
      return;
    }
    try {
      await _user.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated successfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating password: $e")));
    }
  }

  Future<void> _updateDob() async {
    try {
      var dob = DateTime.parse(_dobController.text);
      await _firestore.collection('users').doc(_user.uid).update({
        'dateOfBirth': dob,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Date of Birth updated successfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating Date of Birth: $e")));
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error logging out: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Update Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (yyyy-mm-dd)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEmail,
              child: Text('Update Email'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text('Update Password'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateDob,
              child: Text('Update Date of Birth'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _logout(context);
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
