import 'package:intl/intl.dart';

class DateTimeConverter {


  static String getDayMonthYear({required String dateTimeString}) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String dateMonthYear = DateFormat('d MMMM y').format(dateTime);
    return dateMonthYear;
  }
}
