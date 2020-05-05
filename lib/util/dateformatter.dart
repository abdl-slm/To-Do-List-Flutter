import 'package:intl/intl.dart';


String dateFormatted(){

  var now = DateTime.now();
  var formatter = DateFormat("EEE, MM d, ''yy");

  String formattedDate = formatter.format(now);

  return formattedDate;
}