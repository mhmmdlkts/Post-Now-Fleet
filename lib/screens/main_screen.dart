import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:post_now_fleet/enums/permission_typ_enum.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/screens/splash_screen.dart';
import 'package:post_now_fleet/screens/tabs/drivers_list_tab.dart';
import 'package:post_now_fleet/services/permission_service.dart';
import 'package:screen/screen.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:screen/screen.dart';
import 'dart:io' show Platform;


class MainScreen extends StatefulWidget {
  final User user;
  final Fleet myFleet;
  MainScreen(this.user, this.myFleet);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool _isInitialized = false;
  bool _isInitDone = false;
  int _initCount = 0;
  int _initDone = 0;
  int _tabBarIndex = 0;
  Position _myPosition;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _initCount++;
    Future.delayed(Duration(milliseconds: 200), () => _nextInitializeDone("1"));
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          initialIndex: _tabBarIndex,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    _tabBarIndex = index;
                  });
                },
                tabs: [
                  Tab(icon: Icon(Icons.directions_car_sharp, color: Colors.white,),),
                  Tab(icon: Icon(Icons.bar_chart_outlined, color: Colors.white)),
                  Tab(icon: Icon(Icons.location_pin, color: Colors.white)),
                ],
              ),
              title: Text('APP_NAME'.tr()),
            ),
            body: _getBody(),
          ),
        ),
        _isInitialized ? Container() : SplashScreen(),
      ],
    );
  }

  void _nextInitializeDone(String code) {
    // print(code);
    _initDone++;
    if (_initCount == _initDone) {
      _initIsDone();
    }
  }

  bool _initIsDone() {
    if (_isInitDone)
      return false;
    _isInitDone = true;
    _initMyPosition().then((val) => {
      Future.delayed(Duration(milliseconds: 400), () =>
          setState((){
            _isInitialized = true;
          })
      )
    });
    return true;
  }

  void _setMyPosition(Position pos) {
    //_placesService = PlacesService(pos);
    _myPosition = pos;
  }

  void _onPositionChanged(Position position) {
    _setMyPosition(position);
  }

  Future<void> _initMyPosition() async {
    return;
    if (await PermissionService.positionIsNotGranted(context, PermissionTypEnum.LOCATION))
      return null;

    const locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator().getPositionStream(locationOptions).listen(_onPositionChanged);

    _setMyPosition(await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low));

    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) => {
      _myPosition = value,
    });

    /*await _mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 13)
    ));*/
  }

  Widget _getBody() {
    switch (_tabBarIndex) {
      case 0:
        return DriversListTab(widget.myFleet);
      case 1:
        return Container(color: Colors.green,);
      case 2:
        return Container(color: Colors.indigo,);
    }
    return Container();
  }

}