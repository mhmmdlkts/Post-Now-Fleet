import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:post_now_fleet/decoration/my_colors.dart';
import 'package:post_now_fleet/dialogs/custom_notification_dialog.dart';
import 'package:post_now_fleet/models/custom_notification.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/screens/splash_screen.dart';
import 'package:post_now_fleet/screens/tabs/drivers_list_tab.dart';
import 'package:post_now_fleet/screens/tabs/maps_view_tab.dart';
import 'package:post_now_fleet/screens/tabs/total_statistic_tab.dart';
import 'package:post_now_fleet/services/all_driver_statistic_service.dart';
import 'package:post_now_fleet/services/all_drivers_service.dart';
import 'package:post_now_fleet/services/auth_service.dart';
import 'package:post_now_fleet/services/notification_service.dart';
import 'package:post_now_fleet/services/legal_service.dart';
import 'package:post_now_fleet/services/main_screen_service.dart';
import 'package:post_now_fleet/services/overview_service.dart';
import 'package:screen/screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;
import 'package:intl/date_symbol_data_local.dart';

import 'contact_form_screen.dart';



class MainScreen extends StatefulWidget {
  final User user;
  final Fleet myFleet;
  MainScreen(this.user, this.myFleet);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  BitmapDescriptor _driverLocationIcon, _driverLocationIconOnJob;
  bool _isInitialized = false;
  bool _isInitDone = false;
  int _initCount = 0;
  int _initDone = 0;
  int _tabBarIndex = 1;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);

    final markerSize = Platform.isIOS?130:80;

    _initCount++;
    MainScreenService.getBytesFromAsset('assets/driver_map_marker_grey.png', (markerSize*1.15).round()).then((value) => { setState((){
      _driverLocationIcon = BitmapDescriptor.fromBytes(value);
      _nextInitializeDone('3');
    })});

    _initCount++;
    MainScreenService.getBytesFromAsset('assets/driver_map_marker.png', (markerSize*1.15).round()).then((value) => { setState((){
      _driverLocationIconOnJob = BitmapDescriptor.fromBytes(value);
      _nextInitializeDone('4');
    })});

    NotificationService.fetch(widget.user.uid).then((value) => {
      NotificationService.notifications.forEach((element) async {
        await _showCustomNotificationDialog(element);
        await Future.delayed(Duration(milliseconds: 300));
      })
    });

    _initCount++;
    initializeDateFormatting().then((value) => {
      _nextInitializeDone('0.0'),
    });

    _initCount++;
    AllDriverService.initList(widget.myFleet.key, (val) => setState((){
      _initCount += val;
    }), () => _nextInitializeDone('5')).then((value) => _nextInitializeDone("1"));
    AllDriversStatisticsService.currentDate = OverviewService.getChildKey(null, null);

    _initCount++;
    AllDriversStatisticsService.getDriversMap(widget.myFleet.key, () => _nextInitializeDone("2"));
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
              iconTheme:  IconThemeData( color: Colors.white),
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
            drawer: Drawer(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.myFleet.name, style: TextStyle(fontSize: 22, color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                    ),
                  ),
                  ListTile(
                    title: Text('MAIN_SCREEN.SIDE_MENU.CONTACT'.tr()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactFormScreen(widget.user)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('MAIN_SCREEN.SIDE_MENU.SOFTWARE_LICENCES'.tr()),
                    onTap: () {
                      LegalService.openLicences(context);
                    },
                  ),
                  ListTile(
                    title: Text('MAIN_SCREEN.SIDE_MENU.PRIVACY_POLICY'.tr()),
                    onTap: () {
                      LegalService.openPrivacyPolicy(context);
                    },
                  ),
                  ListTile(
                    title: Text('MAIN_SCREEN.SIDE_MENU.SIGN_OUT'.tr(), style: TextStyle(color: Colors.redAccent),),
                    onTap: () {
                      AuthService().signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        _isInitialized ? Container() : SplashScreen(totalTask: _initCount, completedTask: _initDone,),
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
    setState((){
      _isInitialized = true;
    });
    return true;
  }

  Widget _getBody() {
    switch (_tabBarIndex) {
      case 0:
        return DriversListTab(widget.myFleet);
      case 1:
        return TotalStatisticTab(widget.myFleet);
      case 2:
        return MapsViewTab(widget.myFleet, _driverLocationIcon, _driverLocationIconOnJob);
    }
    return Container();
  }

  _showCustomNotificationDialog(CustomNotification customNotification) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomNotificationDialog(customNotification);
        }
    );
  }
}