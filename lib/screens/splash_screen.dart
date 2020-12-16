import 'package:flutter/material.dart';
import 'package:post_now_fleet/decoration/my_colors.dart';

class SplashScreen extends StatefulWidget {
  final int totalTask;
  final int completedTask;
  const SplashScreen({this.completedTask = -1, this.totalTask = -1, Key key}) : super(key: key);

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
    double width = 120;
    return new Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/postnow_icon.png', width: width),
          ),
          Container(height: 20,),
          Opacity(
            opacity: (widget.completedTask != -1 && widget.totalTask != -1)?1:0,
            child: SizedBox(
              width: width,
              child: LinearProgressIndicator(
                  backgroundColor: primaryBlue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  value: widget.completedTask/widget.totalTask
              )
            ),
          )
        ],
      )
    );
  }
}