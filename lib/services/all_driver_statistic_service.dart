import 'package:firebase_database/firebase_database.dart';

import 'driver_statistics_service.dart';

class AllDriversStatisticsService {
  static final Map<String, Map<String, DriverStatistics>> statistics = Map();
  static String currentDate;

  static Future<Map<String, DriverStatistics>> getDriversMap(String fleetId, {String date}) async {
    if (date == null)
      date = currentDate;
    if (statistics.containsKey(date))
      return statistics[date];
    Map<String, DriverStatistics> newValue = Map();
    DataSnapshot result = await FirebaseDatabase.instance.reference().child('fleets').child(fleetId).child("statistics").child(date).once();

    result.value.forEach((key,val) {
      newValue[key] = DriverStatistics.fromJson(key, val);
    });

    statistics[date] = newValue;
    return newValue;
  }
}