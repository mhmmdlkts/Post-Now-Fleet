import 'package:flutter/material.dart';
import 'package:post_now_fleet/decoration/my_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/postnow_icon.png', width: 120),
          )
        ],
      )
    );
  }
}