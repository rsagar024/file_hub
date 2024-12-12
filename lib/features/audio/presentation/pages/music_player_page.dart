import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vap_uploader/core/common/widgets/player_bottom_button.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(ImageResources.iconBack),
        ),
        // title: Text('Now Playing', style: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.8))),
        title: Text('Now Playing', style: CustomTextStyles.custom17Medium.copyWith(color: Colors.white.withOpacity(0.8))),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            color: const Color(0xFF383B49),
            offset: const Offset(-20, 50),
            elevation: 1,
            icon: SvgPicture.asset(ImageResources.iconMore),
            padding: EdgeInsets.zero,
            onSelected: (value) {},
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  height: 30,
                  child: Text(
                    'Social Share',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  height: 30,
                  child: Text(
                    'Playing Queue',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  height: 30,
                  child: Text(
                    'Add to playlist...',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  height: 30,
                  child: Text(
                    'Lyrics',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  height: 30,
                  child: Text(
                    'Volume',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 6,
                  height: 30,
                  child: Text(
                    'Details',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 7,
                  height: 30,
                  child: Text(
                    'Sleep timer',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 8,
                  height: 30,
                  child: Text(
                    'Equaliser',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 9,
                  height: 30,
                  child: Text(
                    'Ringtone Cutter',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 10,
                  height: 30,
                  child: Text(
                    'Player theme',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
                PopupMenuItem(
                  value: 11,
                  height: 30,
                  child: Text(
                    'Driver mode',
                    style: CustomTextStyles.custom12Medium.copyWith(color: const Color(0xFFEEEEEE)),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.asset(
                    ImageResources.imagePerson,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 220,
                  height: 220,
                  child: SleekCircularSlider(
                    min: 0,
                    max: 100,
                    initialValue: 60,
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 5, progressBarWidth: 8, shadowWidth: 8),
                      customColors: CustomSliderColors(
                        dotColor: const Color(0xFFFFB1B2),
                        trackColor: const Color(0xFFFFFFFF).withOpacity(0.3),
                        progressBarColors: [const Color(0xFFFB9967), const Color(0xFFE9585A)],
                        shadowColor: const Color(0xFFFFB1B2),
                        shadowMaxOpacity: 0.05,
                      ),
                      infoProperties: InfoProperties(
                        topLabelStyle: const TextStyle(color: Colors.transparent, fontSize: 16, fontWeight: FontWeight.w400),
                        topLabelText: 'Elapsed',
                        bottomLabelStyle: const TextStyle(color: Colors.transparent, fontSize: 16, fontWeight: FontWeight.w400),
                        bottomLabelText: 'time',
                        mainLabelStyle: const TextStyle(color: Colors.transparent, fontSize: 50, fontWeight: FontWeight.w600),
                      ),
                      startAngle: 270,
                      angleRange: 360,
                      size: 350,
                    ),
                    onChange: (double value) {
                      // callback providing a value while its being changed (with a pan gesture)
                    },
                    onChangeStart: (double startValue) {
                      // callback providing a starting value (when a pan gesture starts)
                    },
                    onChangeEnd: (double endValue) {
                      // ucallback providing an ending value (when a pan gesture ends)
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('3:15 | 4:26', style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey)),
            const SizedBox(height: 25),
            Text(
              'Black or White',
              style: CustomTextStyles.custom18SemiBold.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(height: 10),
            Text(
              'Michael jackson \u2022 Album - Dangerous',
              style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            //
            // Equilizer (pending)
            //
            const Padding(
              padding: EdgeInsets.all(20),
              child: Divider(
                color: Colors.white24,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(ImageResources.iconPrevious, width: 20, height: 20),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(ImageResources.iconPlay, width: 40, height: 40),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(ImageResources.iconNext, width: 20, height: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerBottomButton(title: 'Playlist', icon: ImageResources.iconPlaylist, onPressed: () {}),
                PlayerBottomButton(title: 'Shuffle', icon: ImageResources.iconShuffle, onPressed: () {}),
                PlayerBottomButton(title: 'Repeat', icon: ImageResources.iconRepeat, onPressed: () {}),
                PlayerBottomButton(title: 'EQ', icon: ImageResources.iconEq, onPressed: () {}),
                PlayerBottomButton(title: 'Favorite', icon: ImageResources.iconFavorite, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
