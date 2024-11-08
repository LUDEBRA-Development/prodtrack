import 'package:intl/intl.dart';


String formatWithCommas(double numero) {
  final formatter = NumberFormat("#,###"); 
  return formatter.format(numero);
}

