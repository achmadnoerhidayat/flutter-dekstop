import 'package:intl/intl.dart';

class NumberFormats {
  static String convertToIdr(String number) {
    NumberFormat curentIdr = NumberFormat.currency(locale: 'id', symbol: '');
    double? numbers = double.tryParse(number);
    if (number.isEmpty) {
      return "";
    }
    return curentIdr.format(numbers).toString().replaceAll(',00', '');
  }

  static String getFormattedDate(DateTime? date) {
    String? month;
    switch (date!.month) {
      case 1:
        month = "Januari";
        break;
      case 2:
        month = "Februari";
        break;
      case 3:
        month = "Maret";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "Mei";
        break;
      case 6:
        month = "Juni";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "Agustus";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "Oktober";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "Desember";
        break;
    }

    String formattedDate =
        "${date.day} $month ${date.year} ${_formatTime(date)}";
    return formattedDate;
  }

  static String _formatTime(DateTime date) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String formattedTime =
        "${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}";
    return formattedTime;
  }

  static String getFormatDay(DateTime? date) {
    if (date == null) return '';

    String day = "";
    switch (date.weekday) {
      case DateTime.monday:
        day = "Senin";
        break;
      case DateTime.tuesday:
        day = "Selasa";
        break;
      case DateTime.wednesday:
        day = "Rabu";
        break;
      case DateTime.thursday:
        day = "Kamis";
        break;
      case DateTime.friday:
        day = "Jumat";
        break;
      case DateTime.saturday:
        day = "Sabtu";
        break;
      case DateTime.sunday:
        day = "Minggu";
        break;
      default:
        day = "";
    }

    var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return "$day ${formatter.format(date)}";
  }
}
