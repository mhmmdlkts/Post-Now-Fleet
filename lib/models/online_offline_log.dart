class OnlineOfflineLog implements Comparable {
  String driverKey;
  DateTime time;
  bool val;

  OnlineOfflineLog(this.driverKey, String timeStamp, bool val) {
    this.val = val;
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp), isUtc: true);
  }

  @override
  int compareTo(other) => time.compareTo(other.time);
}