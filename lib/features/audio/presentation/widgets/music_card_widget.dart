import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/features/audio/presentation/pages/music_player_page.dart';

class MusicCardWidget extends StatelessWidget {
  const MusicCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayerPage()));
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    ImageResources.imagePerson,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white60, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayerPage()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Milenge Hum Nahi',
                              style: CustomTextStyles.custom13SemiBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Kunaal Verma',
                              style: CustomTextStyles.custom10Regular,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(ImageResources.iconPlayColored, height: 30),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[800]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
