import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class WeekYearToReadableDateInterval {

  static Map _dateJson = Map();

  static Future<void> init() async {
    if (_dateJson.isNotEmpty)
      return;
    await rootBundle.loadString("assets/date/date.json").then((value) {
      _dateJson = json.decode(value);
    });
  }

  static String getReadable({int year, int week}) {
    String nullReturn = 'OVERVIEW.TH_WEEK'.tr(namedArgs: {'week': week.toString()});
    if (year == null && year == null)
      return nullReturn;

    Map obj = _dateJson;
    if (obj == null) return nullReturn;
    obj = obj[year.toString()];
    if (obj == null) return nullReturn;
    obj = obj[week.toString()];
    if (obj == null) return nullReturn;

    return _getReadableDateFromObj(obj["START"]) + " - " + _getReadableDateFromObj(obj["END"]);
  }

  static String _getReadableDateFromObj(Map json) {
    String readableMonth = ("MONTHS." + json["MONTH"].toString()).tr();
    return json["DAY"].toString() + ". " + readableMonth.substring(0, min(readableMonth.length, 3));
  }
}