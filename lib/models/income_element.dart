class IncomeElement {
  String driverKey;
  DateTime time;
  double income;

  IncomeElement(this.driverKey, String time, this.income) {
    this.time = DateTime.fromMillisecondsSinceEpoch(int.parse(time), isUtc: true);
  }
}