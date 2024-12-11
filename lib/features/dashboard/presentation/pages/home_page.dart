import 'package:flutter/material.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/features/dashboard/presentation/widgets/music_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Audio',
                style: CustomTextStyles.baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              )
            ],
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 20,
              itemBuilder: (context, index) {
                return MusicCardWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
