import 'package:intl/intl.dart';
String date(){
  var formatter =new DateFormat("EEE, M/d/y");
  String res=formatter.format(DateTime.now());
  return res;
}