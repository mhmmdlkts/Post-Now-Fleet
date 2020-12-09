import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:screen/screen.dart';


class MainScreen extends StatefulWidget {
  final User user;
  final Fleet myFleet;
  MainScreen(this.user, this.myFleet);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.myFleet.name),
      ),
    );
  }

}