import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/weekly_income.dart';

class OverviewService {
  final Driver driver;
  final DatabaseReference _jobsRef = FirebaseDatabase.instance.reference().child('completed-jobs');
  final WeeklyIncome weeklyIncome = WeeklyIncome();
  
  OverviewService(this.driver);

  static int getDayOfMonth(int year, int month) {
    final List<int> days = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (year % 4 == 0) days[DateTime.february]++;
    return days[month];
  }
  
  Future<void> initCompletedJobs({int year, int week}) async {
    weeklyIncome.reset();
    await _jobsRef.child(getChildKey(year: year, week: week)).child(driver.key).orderByChild("finished-time").once().then((DataSnapshot snapshot) => {
    weeklyIncome.reset(),
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          weeklyIncome.addIncome(value);
        })
      }
    });
  }

  static String getChildKey({int year, int week}) {
    if (year == null) 
      year = currentYear();
    if (week == null) 
      week = dayOfWeek();
    return year.toString() + "-" + week.toString();
  }

  static int currentDayOfWeek() {
    return DateTime.now().weekday-1;
  }

  static int currentYear() {
    return DateTime.now().year;
  }

  static int dayOfWeek({DateTime date}) {
    if (date == null)
      date = DateTime.now();

    int w = ((dayOfYear(date) - date.weekday + 10) / 7).floor();

    if (w == 0) {
      w = getYearsWeekCount(date.year-1);
    } else if (w == 53) {
      DateTime lastDay = DateTime(date.year, DateTime.december, 31);
      if (lastDay.weekday < DateTime.thursday) {
        w = 1;
      }
    }
    return w;
  }

  static int getYearsWeekCount(int year) {
    DateTime lastDay = DateTime(year, DateTime.december, 31);
    int count = dayOfWeek(date: lastDay);
    if (count == 1)
      count = dayOfWeek(date: lastDay.subtract(Duration(days: 7)));
    return count;
  }

  static int dayOfYear(DateTime date) {
    int total = 0;
    for (int i = 1; i < date.month; i++) {
      total += getDayOfMonth(date.year, i);
    }
    total+=date.day;
    return total;
  }

  double getTotalIncome() => weeklyIncome.getTotalIncome();
  int getTotalTripsCount() => weeklyIncome.getTotalTripsCount();
  double getIncomeOfToday() => weeklyIncome.dailyIncomes[currentDayOfWeek()].getIncome();
}