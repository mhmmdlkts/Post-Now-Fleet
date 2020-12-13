import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/services/all_drivers_service.dart';
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
      child: ListView(
        shrinkWrap: true,
          children: [
            CustomButton1(
              onTap: () async  {
                String newDriverKey = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterNewDriverScreen(widget.myFleet)));
                if (newDriverKey == null)
                  return;
                await AllDriverService.fetchAndAddDriver(newDriverKey);
                setState(() {
                });
              },
              text: "Register New Driver",
              icon: Icons.add
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: AllDriverService.allDrivers.length,
                itemBuilder: (_, i) => _singleDriverWidget(AllDriverService.allDrivers[i]),
                separatorBuilder: (_, i) => Divider(height: 0,)
            )
          ]
      ),
    );
  }

  Widget _singleDriverWidget(Driver driver) => InkWell(
    onTap: () {

    },
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _circularImage(driver.image),
                  Container(width: 10,),
                  Text('${driver.name} ${driver.surname}', style: TextStyle(fontSize: 18),),
                ],
              ),
              _getOnlinePoint(driver.isOnline)
            ],
          ),
        ],
      ),
    ),
  );

  Widget _circularImage(String imgUrl) {
    return Container(
      margin: EdgeInsets.only(right: 14),
      child: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(imgUrl),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  _getOnlinePoint(bool isOnline) => Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: (isOnline??false)?Colors.green:Colors.redAccent,
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  );

}