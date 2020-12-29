import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'driver_statistics_service.dart';

class AllDriversStatisticsService {
  static final Map<String, Map<String, DriverStatistics>> statistics = Map();
  static String currentDate;

  static Map<String, DriverStatistics> getDriversMap(String fleetId, VoidCallback setState, {String date}) {
    if (date.toString() == null.toString())
      date = currentDate;
    else
      print(date);
    if (statistics.containsKey(date))
      return statistics[date];
    Map<String, DriverStatistics> newValue = Map();
    FirebaseDatabase.instance.reference().child('fleets').child(fleetId).child("statistics").child(date).once().then((value) {
      value?.value?.forEach((key,val) {
        newValue[key] = DriverStatistics.fromJson(key, val);
      });

      statistics[date] = newValue;
      setState.call();
    });

    return newValue;
  }
}