import 'package:flutter/material.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/file_type_selection_widget.dart';

Future<String?> showingFileTypeDialog(BuildContext context, String currentType) async {
  final result = await Navigator.of(context).push<String>(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      pageBuilder: (_, __, ___) {
        return FileTypeSelectionWidget(selectedType: currentType);
      },
    ),
  );

  return result;
}
