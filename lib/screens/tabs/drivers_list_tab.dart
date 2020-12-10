import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/decoration/my_colors.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/widgets/custom_button1.dart';

import '../register_new_driver_screen.dart';

class DriversListTab extends StatefulWidget {
  final Fleet myFleet;
  DriversListTab(this.myFleet);

  @override
  _DriversListTabState createState() => _DriversListTabState();
}

class _DriversListTabState extends State<DriversListTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: [
            CustomButton1(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterNewDriverScreen(widget.myFleet))),
              text: "Register New Driver",
              icon: Icons.add
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (_, i) => _singleDriverWidget(i)
            )
          ]
      ),
    );
  }

  Widget _singleDriverWidget(int i) {
    return Text(i.toString());
  }

}