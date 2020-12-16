import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/services/driver_statitics_service.dart';
import 'package:post_now_fleet/services/all_driver_statistic_service.dart';
import 'package:post_now_fleet/services/driver_statistics_service.dart';
import 'package:post_now_fleet/widgets/chart_widget.dart';

class TotalStatisticTab extends StatefulWidget {
  final Fleet myFleet;
  TotalStatisticTab(this.myFleet);

  @override
  _TotalStatisticTabState createState() => _TotalStatisticTabState();
}

class _TotalStatisticTabState extends State<TotalStatisticTab> {
  String _shownDate = AllDriversStatisticsService.currentDate;
  Map<String, DriverStatistics> _shownDriverStatistics = Map();
  int _getTotalTripCount = 0;
  Duration _totalOnlineTime = Duration();
  DriverStatisticsService _driverStatisticsService = DriverStatisticsService();
  int _chosenDay = -1;
  TextStyle _titleTextStyle = TextStyle(fontSize: 28);
  TextStyle _textStyle = TextStyle(fontSize: 24, color: Colors.black.withOpacity(0.6));

  @override
  void initState() {
    super.initState();
    _initDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChartWidget(_driverStatisticsService.getWeeklyIncome(), int.parse(_shownDate.split("-").last), (val) => setState((){
          _chosenDay = val;
          //print(val?.getIncome()?.toStringAsFixed(2)??"");
        })),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Text(_driverStatisticsService.getTotalTripCount(day: _chosenDay).toString(), style: TextStyle(fontSize: 36, color: Colors.white), textAlign: TextAlign.center),
                        Text("OVERVIEW.TOTAL_TRIP_COUNT".tr(), style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                )
              ),
            ),
            Flexible(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Text(_getTotalOnlineTime(), style: TextStyle(fontSize: 36, color: Colors.white), textAlign: TextAlign.center),
                        Text("OVERVIEW.TOTAL_ONLINE_TIME".tr(namedArgs: {'max': (24 * (_chosenDay==-1?7:1)).toString()}), style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                )
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              _getInfo("Netto-Fahrpreis", _driverStatisticsService.getTotalIncome(day: _chosenDay).toStringAsFixed(2)+ " €", _titleTextStyle),
              _getInfo("Pro Fahrt", _getProDriveIncome().toStringAsFixed(2)+ " €", _textStyle),
              _getInfo("Pro Stunde bei Fahrt", _getProHourIncome().toStringAsFixed(2)+ " €", _textStyle),
            ],
          ),
        )
      ],
    );
  }

  double _getProDriveIncome() {
    final double income = _driverStatisticsService.getTotalIncome(day: _chosenDay)/_driverStatisticsService.getTotalTripCount(day: _chosenDay);
    if (income.isNaN)
      return 0.0;
    return income;
  }

  double _getProHourIncome() {
    final double income = _driverStatisticsService.getTotalIncome(day: _chosenDay)/(_driverStatisticsService.getTotalOnlineDuration(day: _chosenDay).inMinutes/60);
    if (income.isNaN)
      return 0.0;
    return income;
  }

  _initDrivers({String date}) {
    AllDriversStatisticsService.getDriversMap(widget.myFleet.key, date: date).then((value) => setState((){
      _driverStatisticsService = DriverStatisticsService();
      _getTotalTripCount = 0;
      _totalOnlineTime = Duration();
      value.forEach((key, value) {
        _driverStatisticsService.add(value);
        _getTotalTripCount += value.getTripCount();
        _totalOnlineTime += value.getTotalOnlineDuration();
      });
    }));
  }

  String _getTotalOnlineTime() {
    String hours = _driverStatisticsService.getTotalOnlineDuration(day: _chosenDay).inHours.toString();
    String minutes = (_driverStatisticsService.getTotalOnlineDuration(day: _chosenDay).inMinutes % 60).toString();
    hours = hours.length<2?'0'+hours:hours;
    minutes = minutes.length<2?'0'+minutes:minutes;
    return hours + ':' + minutes.toString();
  }

  Widget _getInfo(String text, String val, TextStyle textStyle) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(text, style: textStyle,),
      Text(val, style: textStyle,),
    ],
  );
}