import 'package:intl/intl.dart';

class DateTimeConverter {
  static String getDayMonthYear(
      {String? dateTimeString,
      DateTime? datetime,
      bool isFullMonthName = true}) {
    String dateMonthYear = '';
    if (dateTimeString != null && datetime == null) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      isFullMonthName == true
          ? dateMonthYear = DateFormat('d MMMM y').format(dateTime)
          : dateMonthYear = DateFormat('d MMM y').format(dateTime);
    } else {
      isFullMonthName == true
          ? dateMonthYear = DateFormat('d MMMM y').format(datetime!)
          : dateMonthYear = DateFormat('d MMM y').format(datetime!);
    }
    return dateMonthYear;
  }
}
