import 'package:post_now_fleet/models/income_element.dart';
import 'package:post_now_fleet/models/online_offline_log.dart';
import 'package:post_now_fleet/models/weekly_income.dart';

class DriverStatistics {

  final String driverKey;
  final WeeklyIncome weeklyIncome = WeeklyIncome();
  final List<OnlineOfflineLog> _onOffs = List();
  int cancelCount;
  int requestCount;
  double _cancelRate;
  double _totalIncome;
  int _totalTripCount;
  Duration _totalDurationMs;

  DriverStatistics.fromJson(this.driverKey, json) {
    cancelCount = json["cancels"]??0;
    requestCount = json["requests"]??0;
    json["income"]?.forEach((key, val) {
      weeklyIncome.addIncome(IncomeElement(driverKey, key, val));
    });
    json["online_offline"]?.forEach((key, val) {
      _onOffs.add(OnlineOfflineLog(driverKey, key, val));
    });
    _onOffs.add(OnlineOfflineLog(driverKey, DateTime.now().millisecondsSinceEpoch.toString(), false));
  }

  double getTotalIncome({int day = -1}) {
    if (_totalIncome != null && day == -1)
      return _totalIncome;
    if (day == -1)
      _totalIncome = weeklyIncome.getTotalIncome();
    else
      return weeklyIncome.dailyIncomes[day].getIncome();
    return _totalIncome;
  }

  double getCancelRate() {
    if (requestCount == 0)
      return 0;
    return (cancelCount/requestCount) * 100;
  }

  int getTripCount({int day = -1}) {
    if (_totalIncome != null && day == -1)
      return _totalTripCount;
    if (day == -1)
      _totalTripCount = weeklyIncome.getTotalTripsCount();
    else
      return weeklyIncome.dailyIncomes[day].tripCount();
    return _totalTripCount;
  }

  Duration getTotalOnlineDuration() {
    if (_totalDurationMs != null)
      return _totalDurationMs;
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
  
  List<OnlineOfflineLog> getOnOffs() => _onOffs;
}