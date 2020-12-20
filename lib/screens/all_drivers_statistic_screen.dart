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
                Row(
                  children: [
                    _circularImage(driver.image),
                    Text(driver.name + " " + driver.surname)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(driverStatistics.getTripCount().toString(), textAlign: TextAlign.center),
                          Text("OVERVIEW.TOTAL_TRIP_COUNT".tr(), textAlign: TextAlign.center, maxLines: 1)
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(_getTotalOnlineTime(driverStatistics.getTotalOnlineDuration()), textAlign: TextAlign.center),
                          Text("OVERVIEW.TOTAL_ONLINE_TIME".tr(namedArgs: {'max': '168'}), textAlign: TextAlign.center, maxLines: 1,)
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(driverStatistics.weeklyIncome.getTotalIncome().toStringAsFixed(2) + " €", textAlign: TextAlign.center),
                          Text("OVERVIEW.NET_INCOME".tr(), textAlign: TextAlign.center, maxLines: 1)
                        ],
                      ),
                    )
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