
import 'package:post_now_fleet/enums/days_enum.dart';
import 'package:post_now_fleet/enums/job_status_enum.dart';
import 'package:post_now_fleet/models/income_element.dart';

import 'daily_income.dart';

class WeeklyIncome {
  final List<DailyIncome> dailyIncomes = List(7);
  bool isInitialized;
  double _total;

  WeeklyIncome() {
    isInitialized = true;
    reset();
  }

  void reset() {
    dailyIncomes[0] = DailyIncome(Days.MONDAY);
    dailyIncomes[1] = DailyIncome(Days.TUESDAY);
    dailyIncomes[2] = DailyIncome(Days.WEDNESDAY);
    dailyIncomes[3] = DailyIncome(Days.THURSDAY);
    dailyIncomes[4] = DailyIncome(Days.FRIDAY);
    dailyIncomes[5] = DailyIncome(Days.SATURDAY);
    dailyIncomes[6] = DailyIncome(Days.SUNDAY);
    _total = null;
  }

  void addIncome(IncomeElement income) {
    dailyIncomes[income.time.weekday-1].addIncome(income);
    _total = null;
  }

  void addAllIncome(WeeklyIncome weeklyIncome) {
    for (int i = 0; i < weeklyIncome.dailyIncomes.length; i++) {
      weeklyIncome.dailyIncomes[i].incomes.forEach((element) {
        dailyIncomes[i].addIncome(element);
      });
    }
  }

  double getTotalIncome() {
    if (_total != null)
      return _total;
    _total = 0;
    dailyIncomes.forEach((element) {_total += element.getIncome();});
    return _total;
  }

  int getTotalTripsCount() {
    int count = 0;
    dailyIncomes.forEach((element) {count += element.tripCount();});
    return count;
  }

  double getMaxIncome() => dailyIncomes.reduce((val1, val2) {
    if (val1.getIncome() < val2.getIncome())
      return val2;
    return val1;
  }).getIncome();
  
  DailyIncome monday() => dailyIncomes[0];
  DailyIncome tuesday() => dailyIncomes[1];
  DailyIncome wednesday() => dailyIncomes[2];
  DailyIncome thursday() => dailyIncomes[3];
  DailyIncome friday() => dailyIncomes[4];
  DailyIncome saturday() => dailyIncomes[5];
  DailyIncome sunday() => dailyIncomes[6];
}