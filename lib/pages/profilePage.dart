import 'package:expense_tracking/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking/models/user_model.dart'; // Import the UserModel class
import 'package:expense_tracking/services/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  ProfilePage({required this.userModel});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.userModel.photoURL),
            ),
            SizedBox(height: 20),
            Text('User ID: ${widget.userModel.uid}'),
            SizedBox(height: 10),
            Text('Name: ${widget.userModel.displayName}'),
            // Add more fields as needed

            // You can add a sign-out button or other actions
            ElevatedButton(
              onPressed: () {
                // Implement sign-out logic here
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                GoogleSignInProvider().signOutGoogle();
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
