import 'package:firebase_database/firebase_database.dart';
import 'package:post_now_fleet/models/driver.dart';

import 'first_screen_service.dart';

class AllDriverService {
  static final List<Driver> allDrivers = List();

  static Future<void> initList(String fleetId) async {
    allDrivers.clear();
    DataSnapshot result = await FirebaseDatabase.instance.reference().child('fleets').child(fleetId).child("drivers").once();
    List<Future<void>> list = List();
    result.value.forEach((e) => list.add(fetchAndAddDriver(e)));
    await Future.wait(list).catchError((onError) => print(onError));
  }

  static Future<void> fetchAndAddDriver(String driverKey) async {
    DataSnapshot result = await FirebaseDatabase.instance.reference().child('drivers').child(driverKey).once().catchError((onError) => print(onError));
    allDrivers.add(Driver.fromSnapshot(result));
  }
}