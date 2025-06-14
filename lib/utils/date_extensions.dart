import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormattedString() {
    return format(format: "dd/MM/yyyy");
  }

  String format({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(this);
  }

  String toFormattedStringWithTime() {
    return format(format: "dd/MM/yyyy HH:mm");
  }

  DateTime get toLocalTime => subtract(const Duration(hours: 3));

  String getNameMonthFromNumber() {
    switch (month) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "Junio";
      case 7:
        return "Julio";
      case 8:
        return "Agosto";
      case 9:
        return "Septiembre";
      case 10:
        return "Octubre";
      case 11:
        return "Noviembre";
      case 12:
        return "Diciembre";
      default:
        throw Exception("Invalid month: $month");
    }
  }
}
