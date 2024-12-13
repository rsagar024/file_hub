import 'package:flutter/material.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/file_type_selection_widget.dart';

void showingFileTypeDialog(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      pageBuilder: (_, __, ___) {
        return const FileTypeSelectionWidget();
      },
    ),
  );
}
