import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/daily_income.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/income_element.dart';
import 'package:post_now_fleet/services/driver_statistics_service.dart';
import 'package:post_now_fleet/widgets/chart_widget.dart';

class OneDriverStatisticScreen extends StatefulWidget {
  final DriverStatistics driverStatistics;
  final Driver driver;
  final String date;

  OneDriverStatisticScreen(this.date, this.driver, this.driverStatistics);

  @override
  _OneDriverStatisticScreenState createState() => _OneDriverStatisticScreenState();
}

class _OneDriverStatisticScreenState extends State<OneDriverStatisticScreen> {
  int _chosenDay = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver.name + " " + widget.driver.surname),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          _getDriverInfo(),
          ChartWidget(
            widget.driverStatistics.weeklyIncome,
            int.parse(widget.date.split("-").last),
            int.parse(widget.date.split("-").first),
                (val) => setState((){
              _chosenDay = val;
            }
          )),
          _chosenDay == -1? Container():
          Column(
            children: widget.driverStatistics.weeklyIncome.dailyIncomes[_chosenDay].incomes.map((e) => _getSingleJobWidget(e)).toList()
          )
        ],
      ),
    );
  }

  Widget _getSingleJobWidget(IncomeElement incomeElement) {
    if (incomeElement == null)
      return null;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.lightBlueAccent,
        child: InkWell(
            borderRadius: BorderRadius.circular(18),
            highlightColor: Colors.lightBlue,
            onTap: () {},
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getReadableFinishDay(incomeElement.time), style: TextStyle(color: Colors.white))
                  ],
                )
            )
        )
    );
  }

  String getReadableFinishDay(DateTime d) {
    final DateFormat formatter = DateFormat('dd. MMMM, HH:mm');
    return formatter.format(d);
  }

  Widget _getDriverInfo() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(widget.driver.image),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}