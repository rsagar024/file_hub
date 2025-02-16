extension StringExtension on String? {
  bool isNullOrEmpty() => this?.isEmpty ?? true;

  bool isNotNullOrEmpty() => !isNullOrEmpty();

  String capitalize() => this![0].toUpperCase() + this!.substring(1);

  String? getTimeStamp() => RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(this ?? '')?.group(1);
}
