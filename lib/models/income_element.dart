class IncomeElement {
  String driverKey;
  DateTime time;
  double income;

  IncomeElement(this.driverKey, String time, income) {
    this.income = income + 0.0;
    this.time = DateTime.fromMillisecondsSinceEpoch(int.parse(time), isUtc: true);
  }
}