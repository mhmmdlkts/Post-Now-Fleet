import 'package:post_now_fleet/models/online_offline_log.dart';
import 'package:post_now_fleet/models/weekly_income.dart';
import 'package:post_now_fleet/services/driver_statistics_service.dart';

class DriverStatisticsService {
  List<DriverStatistics> _statistics = List();
  DriverStatisticsService();
  WeeklyIncome _totalWeeklyIncome = WeeklyIncome();
  double _totalIncome;
  int _totalTrip;
  Duration _totalTime;

  add(DriverStatistics statistics) {
    _statistics.add(statistics);
    _totalWeeklyIncome.addAllIncome(statistics.weeklyIncome);
    _totalIncome = null;
  }

  WeeklyIncome getWeeklyIncome() => _totalWeeklyIncome;
  
  double getTotalIncome({int day = -1}) {
    if (_totalIncome != null && day == -1)
      return _totalIncome;
    double tmpTotal = 0;
    _statistics.forEach((element) {
      tmpTotal += element.getTotalIncome(day: day);
    });
    if (day == -1)
      _totalIncome = tmpTotal;
    else
      return tmpTotal;
    return _totalIncome;
  }
  
  int getTotalTripCount({int day = -1}) {
    if (_totalTrip != null && day == -1)
      return _totalTrip;
    int tmpTotal = 0;
    _statistics.forEach((element) {
      tmpTotal += element.getTripCount(day: day);
    });
    if (day == -1)
      _totalTrip = tmpTotal;
    else
      return tmpTotal;
    return _totalTrip;
  }

  Duration getTotalOnlineDuration({int day = -1}) {
    if (_totalTime != null && day == -1)
      return _totalTime;
    int tmpTotalMs = 0;
    List<OnlineOfflineLog> allOnOffs = List();
    Set<String> onlineUsers = {};
    int lastTime;

    _statistics.forEach((element) { allOnOffs.addAll(element.getOnOffs()); });
    allOnOffs.sort();

    if (day != -1)
      allOnOffs = allOnOffs.where((e) => e.time.weekday-1 == day).toList();

    allOnOffs.forEach((element) {
      if (onlineUsers.isNotEmpty && lastTime != null)
        tmpTotalMs += Duration(milliseconds: element.time.millisecondsSinceEpoch - lastTime).inMilliseconds;
      lastTime = element.time.millisecondsSinceEpoch;
      if (element.val)
        onlineUsers.add(element.driverKey);
      else
        onlineUsers.remove(element.driverKey);
    });


    if (day == -1)
      _totalTime = Duration(milliseconds: tmpTotalMs);
    else
      return Duration(milliseconds: tmpTotalMs);
    return _totalTime;
  }

  Duration getTotalOnlineDuration1(_onOffs) {
    Duration _totalDurationMs;
    _onOffs.sort();
    _totalDurationMs = Duration();
    int lastOnline;
    bool wasOnline = false;
    _onOffs.forEach((element) {
      if (wasOnline && lastOnline != null)
        _totalDurationMs += Duration(milliseconds: element.time.millisecondsSinceEpoch - lastOnline);
      wasOnline = element.val;
      if (element.val)
        lastOnline = element.time.millisecondsSinceEpoch;
    });
    return _totalDurationMs;
  }
}