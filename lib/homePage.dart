import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page ${widget.user.email}"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await GoogleSignInProvider().signOutGoogle();
            Navigator.pop(context);
          },
          child: Text("Sign out"),
        ),
      ),
    );
  }
}
