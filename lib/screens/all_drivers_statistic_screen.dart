import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/screens/one_driver_statistic_screen.dart';
import 'package:post_now_fleet/services/all_driver_statistic_service.dart';
import 'package:post_now_fleet/services/all_drivers_service.dart';
import 'package:post_now_fleet/services/week_year_to_readable_date_interval.dart';

class AllDriversStatisticScreen extends StatefulWidget {
  final String date;
  AllDriversStatisticScreen(this.date);

  @override
  _AllDriversStatisticScreenState createState() => _AllDriversStatisticScreenState();
}

class _AllDriversStatisticScreenState extends State<AllDriversStatisticScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekYearToReadableDateInterval.getReadable(week: int.parse(widget.date.split("-").last), year: int.parse(widget.date.split("-").first))),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: AllDriversStatisticsService.statistics[widget.date].keys.map((e) => _getSingleDriverWidget(e)).toList(),
      ),
    );
  }

  Widget _getSingleDriverWidget(String driverKey) {
    final driverStatistics = AllDriversStatisticsService.statistics[widget.date][driverKey];
    final Driver driver = AllDriverService.allDrivers.where((element) => element.key == driverKey).first;
    return InkWell(
      onTap: () {
        print(driver.name);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OneDriverStatisticScreen(widget.date, driver, driverStatistics)));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 20, top: 5),
                  child: Row(
                    children: [
                      _circularImage(driver.image),
                      Text(driver.name + " " + driver.surname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    _getValueWidget(driverStatistics.weeklyIncome.getTotalIncome().toStringAsFixed(2) + " €", "OVERVIEW.NET_INCOME"),
                    Container(),
                    _getValueWidget(_getTotalOnlineTime(driverStatistics.getTotalOnlineDuration()), "OVERVIEW.TOTAL_ONLINE_TIME".tr(namedArgs: {'max': '168'})),
                    Container(),
                  ],
                ),
                Container(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    _getValueWidget(driverStatistics.getCancelRate().toStringAsFixed(2) + " %", "OVERVIEW.CANCEL_RATE"),
                    Container(),
                    _getValueWidget(driverStatistics.getTripCount().toString(), "OVERVIEW.TOTAL_TRIP_COUNT"),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1,)
        ],
      ),
    );
  }

  Widget _getValueWidget(String val, String titleKey) => Flexible(
    flex: 1,
    child: Column(
      children: [
        Text(val, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(titleKey.tr(), textAlign: TextAlign.center, maxLines: 1)
      ],
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

  String _getTotalOnlineTime(Duration duration) {
    String hours = duration.inHours.toString();
    String minutes = (duration.inMinutes % 60).toString();
    hours = hours.length<2?'0'+hours:hours;
    minutes = minutes.length<2?'0'+minutes:minutes;
    return hours + ':' + minutes.toString();
  }
}