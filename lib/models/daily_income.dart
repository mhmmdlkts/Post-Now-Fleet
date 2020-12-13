import 'package:easy_localization/easy_localization.dart';
import 'package:post_now_fleet/enums/days_enum.dart';
import 'package:post_now_fleet/models/income_element.dart';

class DailyIncome {
  final Days _day;
  List<IncomeElement> incomes = List();
  double _total;

  DailyIncome(this._day);

  void addIncome(IncomeElement income) {
    incomes.add(income);
    _total = null;
  }

  String getDayName() => ("ENUMS." + _day.toString().toUpperCase()).tr();

  double getIncome() {
    if (_total != null)
      return _total;
    _total = 0;
    incomes.forEach((element) {
      _total += element.income;
    });
    return _total;
  }

  int tripCount() => incomes.length;
}