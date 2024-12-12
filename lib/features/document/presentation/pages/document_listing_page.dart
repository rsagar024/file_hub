import 'package:flutter/material.dart';
import 'package:vap_uploader/features/document/presentation/widgets/document_card_widget.dart';

class DocumentListingPage extends StatelessWidget {
  const DocumentListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 20,
      itemBuilder: (context, index) {
        return const DocumentCardWidget();
      },
    );
  }
}
