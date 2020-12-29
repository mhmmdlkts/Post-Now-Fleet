import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:post_now_fleet/models/daily_income.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/services/overview_service.dart';
import 'package:intl/intl.dart';
import 'package:post_now_fleet/widgets/chart_widget.dart';

class OverviewScreen extends StatefulWidget {
  final BitmapDescriptor bitmapDescriptorDestination;
  final BitmapDescriptor bitmapDescriptorOrigin;
  final Driver driver;
  OverviewScreen(this.driver, this.bitmapDescriptorDestination, this.bitmapDescriptorOrigin);

  @override
  _OverviewScreen createState() => _OverviewScreen(driver);
}

class _OverviewScreen extends State<OverviewScreen> {
  final int proYearWeekCount = 53; // TODO sometimes 52
  final Driver driver;
  OverviewService _overviewService;
  PageController _pageController;
  int _chosenWeek;
  DailyIncome _selectedIncome;
  int _maxPage = 52 * 5;
  int _lastWeek;

  _OverviewScreen(this.driver) {
    _overviewService = OverviewService(driver);
  }

  @override
  void initState() {
    super.initState();
    _lastWeek = OverviewService.dayOfWeek();
    _chosenWeek = _lastWeek;
    _pageController = PageController(initialPage: _getPageIndex());

    _initOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("OVERVIEW.TITLE".tr()),
          centerTitle: false,
          brightness: Brightness.dark,
        ),
        body: PageView.builder(
          itemCount: _maxPage,
          controller: _pageController,
          onPageChanged: (index) {
            int year = _pageToYear(_pageToReadable(index));
            _chosenWeek = _pageToWeek(_pageToReadable(index));
            _initOverview(year: year, week: _chosenWeek);
          },
          itemBuilder: (context, index) {
            return _getContent();
          },
        )
    );
  }

  int _getPageIndex() => _maxPage + _lastWeek - _chosenWeek;
  int _pageToReadable(int page) => _lastWeek + 1 + page - _maxPage;

  _getContent() => ListView(
    shrinkWrap: true,
    padding: EdgeInsets.only(left: 8, right: 8, top: 10),
    children: [
      ChartWidget(_overviewService.weeklyIncome, _chosenWeek,2020, (val) {
        setState(() {
          //_selectedIncome = val;
        });
      }),
      _isInitialized()?Container(
        child: Row(
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
                            Text(_overviewService.getTotalTripsCount().toString(), style: TextStyle(fontSize: 36, color: Colors.white), textAlign: TextAlign.center),
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
                            Text("404", style: TextStyle(fontSize: 36, color: Colors.white), textAlign: TextAlign.center),
                            Text("OVERVIEW.TOTAL_DRIVE_TIME".tr(), style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
                          ],
                        ),
                      )
                  )
              ),
            ),
          ],
        ),
      ):Container(),
    ],
  );

  String getReadableFinishDay(DateTime d) {
    final DateFormat formatter = DateFormat('dd. MMMM, HH:mm');
    return formatter.format(d);
  }

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

  _initOverview({int year, int week, isNext = false, isPrev = false}) {
    setInitialized(false);
    _overviewService.initCompletedJobs(year: year, week: week).then((value) async {
      await Future.delayed(const Duration(milliseconds: 400));
      setInitialized(true);
    });
  }

  setInitialized(bool isInitialized) {
    setState(() {
      _overviewService.weeklyIncome.isInitialized = isInitialized;
    });
  }

  bool _isInitialized() => _overviewService.weeklyIncome.isInitialized;

}