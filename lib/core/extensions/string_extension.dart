extension StringExtension on String? {
  bool isNullOrEmpty() => this?.isEmpty ?? true;

  bool isNotNullOrEmpty() => !isNullOrEmpty();
}
