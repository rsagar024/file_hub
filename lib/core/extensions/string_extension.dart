extension StringExtension on String? {
  bool isNullOrEmpty() => this?.isEmpty ?? true;

  bool isNotNullOrEmpty() => !isNullOrEmpty();

  String capitalize() => this![0].toUpperCase() + this!.substring(1);
}
