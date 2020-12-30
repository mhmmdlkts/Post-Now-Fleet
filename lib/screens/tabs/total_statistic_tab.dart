import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/services/driver_statitics_service.dart';
import 'package:post_now_fleet/services/all_driver_statistic_service.dart';
import 'package:post_now_fleet/services/driver_statistics_service.dart';
import 'package:post_now_fleet/services/overview_service.dart';
import 'package:post_now_fleet/services/week_year_to_readable_date_interval.dart';
import 'package:post_now_fleet/widgets/chart_widget.dart';

import '../all_drivers_statistic_screen.dart';

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
  final int proYearWeekCount = 53; // TODO sometimes 52
  OverviewService _overviewService;
  PageController _pageController;
  int _maxPage = 52 * 5;
  int _lastWeek;

  @override
  void initState() {
    super.initState();
    _initDrivers();
    _lastWeek = int.parse(_shownDate.split("-").last);

    _pageController = PageController(initialPage: _getPageIndex());

    _initOverview();
    WeekYearToReadableDateInterval.init().then((value) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: _maxPage,
      controller: _pageController,
      onPageChanged: (index) {
        int year = _pageToYear(_pageToReadable(index));
        int week = _pageToWeek(_pageToReadable(index));
        setState(() {
          _shownDate = '$year-$week';
        });
        _initOverview(year: year, week: week);
      },
      itemBuilder: (context, index) {
        return _getContent();
      },
    );
  }

  _initOverview({int year, int week}) {
    _initDrivers(date: '$year-$week');
  }

  _refresh() {
    print(_driverStatisticsService.getWeeklyIncome().getTotalIncome());
    setState(() { });
  }

  Widget _getContent() => ListView(
    children: [
      ChartWidget(
          _driverStatisticsService.getWeeklyIncome(),
          int.parse(_shownDate.split("-").last),
          int.parse(_shownDate.split("-").first),
          (val) => setState((){
            _chosenDay = val;
            //print(val?.getIncome()?.toStringAsFixed(2)??"");
          }
      )),
      Row(
        children: [
          getInfoCard( _getTotalOnlineTime(), "MAIN_SCREEN.TABS.STATISTICS.TOTAL_ONLINE_TIME".tr(namedArgs: {'max': (24 * (_chosenDay==-1?7:1)).toString()}) )
        ],
      ),
      Row(
        children: [
          getInfoCard( _driverStatisticsService.getTotalTripCount(day: _chosenDay).toString(), "MAIN_SCREEN.TABS.STATISTICS.TOTAL_TRIP_COUNT".tr()),
          getInfoCard( _driverStatisticsService.getTotalWorkedDrivers(day: _chosenDay).toString(), "MAIN_SCREEN.TABS.STATISTICS.TOTAL_WORKED_DRIVER_COUNT".tr(), onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllDriversStatisticScreen(_shownDate)));
          }),
        ],
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            _getInfo("MAIN_SCREEN.TABS.STATISTICS.NET_INCOME".tr(), _driverStatisticsService.getTotalIncome(day: _chosenDay).toStringAsFixed(2)+ " €", _titleTextStyle),
            _getInfo("MAIN_SCREEN.TABS.STATISTICS.INCOME_PRO_JOB".tr(), _getProDriveIncome().toStringAsFixed(2)+ " €", _textStyle),
            _getInfo("MAIN_SCREEN.TABS.STATISTICS.INCOME_PRO_HOUR".tr(), _getProHourIncome().toStringAsFixed(2)+ " €", _textStyle),
          ],
        ),
      )
    ],
  );

  int _getPageIndex() => _maxPage + _lastWeek - int.parse(_shownDate.split("-").last);
  int _pageToReadable(int page) => _lastWeek + 1 + page - _maxPage;

  int _pageToYear(page) {
    final a = OverviewService.currentYear() + ((page-1)/(proYearWeekCount)).floor();
    return a;
  }

  int _pageToWeek(page) {
    int year = _pageToYear(page);
    int a = page;// % (_overviewService.getYearsWeekCount(year));
    for (int i = OverviewService.currentYear()-1; i >= year; i--) {
      a += OverviewService.getYearsWeekCount(i);
    }
    return a;
  }

  Widget getInfoCard(String val, String explain, {VoidCallback onTap}) => Flexible(
    flex: 1,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.lightBlue,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text(val, style: TextStyle(fontSize: 36, color: Colors.white), textAlign: TextAlign.center),
                Text(explain, style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          )
        ),
      )
    ),
  );

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
    final value = AllDriversStatisticsService.getDriversMap(widget.myFleet.key, () => setState((){
      _initDrivers(date: date);
    }), date: date);
    _driverStatisticsService = DriverStatisticsService();
    _getTotalTripCount = 0;
    _totalOnlineTime = Duration();
    value.forEach((key, value) {
      _driverStatisticsService.add(value);
      _getTotalTripCount += value.getTripCount();
      _totalOnlineTime += value.getTotalOnlineDuration();
    });
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
      Text(text, style: textStyle, maxLines: 1,),
      Flexible(child: Text(val, style: textStyle, maxLines: 1,))
    ],
  );
}