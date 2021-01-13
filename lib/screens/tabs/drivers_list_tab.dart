import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/screens/edit_driver_screen.dart';
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
      child: Stack(
        children: [
          ListView(
              shrinkWrap: true,
              children: [
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: AllDriverService.allDrivers.length,
                    itemBuilder: (_, i) => _singleDriverWidget(AllDriverService.allDrivers[i]),
                    separatorBuilder: (_, i) => Divider(height: 0,)
                )
              ]
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
              onPressed: () async {
                String newDriverKey = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterNewDriverScreen(widget.myFleet)));
                if (newDriverKey == null)
                  return;
                await AllDriverService.fetchAndAddDriver(newDriverKey);
                setState(() {
                });
              },
              child: Icon(Icons.add, color: Colors.white,),
            ),
          )
        ],
      )
    );
  }

  Widget _singleDriverWidget(Driver driver) => InkWell(
    onTap: () async{
      await Navigator.push(context, MaterialPageRoute(builder: (context) => EditDriverScreen(driver)));
      setState(() {});
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
              _getOnlinePoint(driver.isOnline, driver.isActive())
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

  _getOnlinePoint(bool isOnline, bool isActive) => Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: isActive?((isOnline??false)?Colors.green:Colors.redAccent):Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  );

}