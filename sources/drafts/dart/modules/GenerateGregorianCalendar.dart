import 'dart:collection';
import 'GenerateGregorianCalendar.dart';

const String column_1_EN = "Day(Year)";
const String column_2_EN = "Month";
const String column_3_EN = "Day(Month)";
const String column_4_EN = "Weekday";

const String column_1_CN = "年日";
const String column_2_CN = "月份";
const String column_3_CN = "月日";
const String column_4_CN = "平日";

const String column_1_BN = "দিন(বছর)";
const String column_2_BN = "মাস";
const String column_3_BN = "দিন(মাস)";
const String column_4_BN = "বার";

const List<String> weekdayNames_EN = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

const List<String> weekdayNames_CN = ["一", "二", "三", "四", "五", "六", "日"];

const List<String> weekdayNames_BN = [
  "সোমবার",
  "মঙ্গলবার",
  "বুধবার",
  "বৃহস্পতিবার",
  "শুক্রবার",
  "শনিবার",
  "রবিবার"
];

const List<String> monthNames_EN = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

const List<String> monthNames_BN = [
  "জানুয়ারি",
  "ফেব্রুয়ারি",
  "মার্চ",
  "এপ্রিল",
  "মে",
  "জুন",
  "জুলাই",
  "আগস্ট",
  "সেপ্টেম্বর",
  "অক্টোবর",
  "নভেম্বর",
  "ডিসেম্বর"
];

const String weekday_CN = "星期";
const String month_CN = "月";
const String day_CN = "日";

class GenerateGregorianCalendar {
  late final String locale;
  late final DateTime _targetTimeFrame;
  late final int _targetYear;
  late final DateTime _firstCalendarDate;
  late final DateTime _lastCalendarDate;
  late final int _totalCalendarDays;
  late final bool leapYearStatus;
  late final List<Map<String, String>> _generatedCalendarEntries;

  call() => entries;

  get entries => _generatedCalendarEntries;

  GenerateGregorianCalendar({int? year, this.locale = "EN"}) {
    if (year == null) {
      _targetTimeFrame = DateTime.now();
      _targetYear = _targetTimeFrame.year.toInt();
      _firstCalendarDate = DateTime.utc(_targetYear, DateTime.january, 01);
      _lastCalendarDate = DateTime.utc(_targetYear, DateTime.december, 31);
      _totalCalendarDays =
          _lastCalendarDate.difference(_firstCalendarDate).inDays + 1;
      leapYearStatus = (_totalCalendarDays == 366) ? true : false;
    } else {
      _targetTimeFrame = DateTime.utc(year);
      _targetYear = year;
      _firstCalendarDate = DateTime.utc(year, DateTime.january, 01);
      _lastCalendarDate = DateTime.utc(year, DateTime.december, 31);
      _totalCalendarDays =
          _lastCalendarDate.difference(_firstCalendarDate).inDays + 1;
      leapYearStatus = (_totalCalendarDays == 366) ? true : false;
    }
    _generatedCalendarEntries = generateCalendarEntries(locale);
  }

  List<Map<String, String>> generateCalendarEntries(String locale) {
    final List<Map<String, String>> calendarEntries = [];

    switch (locale) {
      case "CN":
        for (int i = 0; i <= _totalCalendarDays - 1; i++) {
          DateTime calendarDates = _firstCalendarDate.add(Duration(days: i));
          Map<String, String> singleCalendarDateEntry = {
            CalendarData.column_1_CN: "${i + 1}",
            CalendarData.column_2_CN: "${calendarDates.month}",
            CalendarData.column_3_CN: "${calendarDates.day}",
            CalendarData.column_4_CN: "${calendarDates.weekday}",
          };
          calendarEntries.add(singleCalendarDateEntry);
        }
        return localizeCalendarEntries(locale, calendarEntries);
      case "BN":
        for (int i = 0; i <= _totalCalendarDays - 1; i++) {
          DateTime calendarDates = _firstCalendarDate.add(Duration(days: i));
          Map<String, String> singleCalendarDateEntry = {
            CalendarData.column_1_BN: "${i + 1}",
            CalendarData.column_2_BN:
                "${CalendarData.monthNames_BN[calendarDates.month - 1]}",
            CalendarData.column_3_BN: "${calendarDates.day}",
            CalendarData.column_4_BN:
                "${CalendarData.weekdayNames_BN[calendarDates.weekday - 1]}",
          };
          calendarEntries.add(singleCalendarDateEntry);
        }
        return localizeCalendarEntries(locale, calendarEntries);
      default:
        for (int i = 0; i <= _totalCalendarDays - 1; i++) {
          DateTime calendarDates = _firstCalendarDate.add(Duration(days: i));
          Map<String, String> singleCalendarDateEntry = {
            CalendarData.column_1_EN: "${i + 1}",
            CalendarData.column_2_EN:
                "${CalendarData.monthNames_EN[calendarDates.month - 1]}",
            CalendarData.column_3_EN: "${calendarDates.day}",
            CalendarData.column_4_EN:
                "${CalendarData.weekdayNames_EN[calendarDates.weekday - 1]}",
          };
          calendarEntries.add(singleCalendarDateEntry);
        }
        return localizeCalendarEntries(locale, calendarEntries);
    }
  }

  List<Map<String, String>> localizeCalendarEntries(
      String locale, List<Map<String, String>> calendarEntries) {
    switch (locale) {
      case "BN":
        return calendarEntries;
      case "CN":
        calendarEntries.forEach((element) {
          element.forEach((key, value) {
            while (key.toString() == CalendarData.column_1_CN) {
              element.update(
                  key, (value) => value.toString() + CalendarData.day_CN);
              break;
              // value = "第" + value.toString() + "日";
            }
            while (key.toString() == CalendarData.column_2_CN) {
              element.update(
                  key, (value) => value.toString() + CalendarData.month_CN);
              break;
            }
            while (key.toString() == CalendarData.column_3_CN) {
              element.update(
                  key, (value) => value.toString() + CalendarData.day_CN);
              break;
            }
            while (key.toString() == CalendarData.column_4_CN) {
              element.update(
                  key,
                  (value) =>
                      CalendarData.weekday_CN +
                      CalendarData.weekdayNames_CN[int.parse(value) - 1]);
              break;
            }
          });
        });
        return calendarEntries;
      // break; - is not necessary as return breaks the execution
      default:
        return calendarEntries;
    }
  }
}

class GregorianCalendar extends ListBase<Map<String, String>> {
  late final GenerateGregorianCalendar _calendar;
  late final List<Map<String, String>> _calendarDates = [];
  late final bool isLeapYear;

  GregorianCalendar({int? year, String locale = "EN"}) {
    _calendar = GenerateGregorianCalendar(year: year, locale: locale);
    _calendarDates.addAll(_calendar.entries);
    isLeapYear = _calendar.leapYearStatus;
  }

  void set length(int newLength) {
    _calendarDates.length = newLength;
  }

  int get length => _calendarDates.length;

  Map<String, String> operator [](int dayOfYear) => _calendarDates[dayOfYear];

  void operator []=(int dayOfYear, Map<String, String> date) {
    _calendarDates[dayOfYear] = date;
  }
}
