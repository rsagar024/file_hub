import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {
  String toDateTimeToFormattedString() {
    if (this == null) return "";
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime targetDate = DateTime(this!.year, this!.month, this!.day);

    if (targetDate == today) {
      return "Today";
    } else if (targetDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMd().format(this!);
    }
  }
}
