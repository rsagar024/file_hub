import 'package:flutter/material.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/music_player_page.dart';

class MusicCardWidget extends StatelessWidget {
  const MusicCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayerPage()));
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: const CircleAvatar(
            backgroundImage: AssetImage(ImageResources.imagePerson),
            radius: 30,
          ),
          title: const Text(
            'Be the girl',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'Bebe Rexa',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: const Color(0xFFFF007F)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
