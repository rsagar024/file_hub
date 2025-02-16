import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/extensions/string_extension.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/core/services/audio_service/audio_page_manager.dart';
import 'package:vap_uploader/features/audio/presentation/widgets/audio_player_bottom_button.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  @override
  Widget build(BuildContext context) {
    final audioPageManager = getIt<AudioPageManager>();
    return Dismissible(
      key: const Key("playScreen"),
      direction: DismissDirection.down,
      background: const ColoredBox(color: Colors.transparent),
      onDismissed: (direction) => Navigator.pop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(ImageResources.iconBack),
          ),
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
        body: ValueListenableBuilder<MediaItem?>(
          valueListenable: audioPageManager.currentSongNotifier,
          builder: (context, mediaItem, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Hero(
                          tag: 'currentArtWork',
                          child: ValueListenableBuilder(
                            valueListenable: audioPageManager.currentSongNotifier,
                            builder: (context, value, child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: mediaItem?.artUri == null
                                    ? Image.asset(
                                        ImageResources.imagePerson,
                                        width: 208,
                                        height: 208,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        mediaItem!.artUri.toString(),
                                        width: 208,
                                        height: 208,
                                        fit: BoxFit.cover,
                                      ),
                              );
                            },
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: audioPageManager.audioProgressNotifier,
                          builder: (context, valueState, child) {
                            bool dragging = false;
                            final totalMilliseconds = valueState.total.inMilliseconds.toDouble();
                            final currentMilliseconds = valueState.current.inMilliseconds.toDouble();
                            final validTotalMilliseconds = totalMilliseconds.isFinite && totalMilliseconds > 0 ? totalMilliseconds : 1.0;
                            final validCurrentMilliseconds = currentMilliseconds.isFinite && currentMilliseconds >= 0 ? min(currentMilliseconds, validTotalMilliseconds) : 0.0;
                            return SizedBox(
                              width: 220,
                              height: 220,
                              child: SleekCircularSlider(
                                min: 0,
                                max: validTotalMilliseconds,
                                initialValue: validCurrentMilliseconds,
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
                                  if (!dragging) {
                                    dragging = true;
                                  }
                                  audioPageManager.seek(Duration(milliseconds: value.round()));
                                },
                                onChangeStart: (double startValue) {},
                                onChangeEnd: (double endValue) {
                                  audioPageManager.seek(Duration(milliseconds: endValue.round()));
                                  dragging = false;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: audioPageManager.audioProgressNotifier,
                      builder: (context, valueState, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(valueState.current.toString().getTimeStamp() ?? '${valueState.current}', style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey)),
                            Text(' | ', style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey)),
                            Text(valueState.total.toString().getTimeStamp() ?? '${valueState.total}', style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Text(
                      mediaItem?.title ?? '',
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.custom18SemiBold.copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mediaItem?.artist ?? '',
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.custom12Regular.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    //
                    // Equilizer (pending)
                    //
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Divider(color: Colors.white24, height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: audioPageManager.isFirstSongNotifier,
                          builder: (context, isFirst, _) {
                            return IconButton(
                              onPressed: isFirst ? null : audioPageManager.previous,
                              icon: SvgPicture.asset(
                                ImageResources.iconPrevious,
                                width: 20,
                                height: 20,
                                colorFilter: isFirst ? ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn) : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder<AudioButtonState>(
                          valueListenable: audioPageManager.audioPlayButtonNotifier,
                          builder: (context, value, _) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                if (value == AudioButtonState.loading)
                                  const Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: value == AudioButtonState.playing
                                      ? IconButton(
                                          onPressed: audioPageManager.pause,
                                          icon: SvgPicture.asset(ImageResources.iconPause, width: 45, height: 45),
                                        )
                                      : IconButton(
                                          onPressed: audioPageManager.play,
                                          icon: SvgPicture.asset(ImageResources.iconPlay, width: 45, height: 45),
                                        ),
                                )
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder<bool>(
                          valueListenable: audioPageManager.isLastSongNotifier,
                          builder: (context, isLast, _) {
                            return IconButton(
                              onPressed: isLast ? null : audioPageManager.next,
                              icon: SvgPicture.asset(
                                ImageResources.iconNext,
                                width: 20,
                                height: 20,
                                colorFilter: isLast ? ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn) : null,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AudioPlayerBottomButton(title: 'Playlist', icon: ImageResources.iconPlaylist, onPressed: () {}),
                        AudioPlayerBottomButton(title: 'Shuffle', icon: ImageResources.iconShuffle, onPressed: () {}),
                        AudioPlayerBottomButton(title: 'Repeat', icon: ImageResources.iconRepeat, onPressed: () {}),
                        AudioPlayerBottomButton(title: 'EQ', icon: ImageResources.iconEq, onPressed: () {}),
                        AudioPlayerBottomButton(title: 'Favorite', icon: ImageResources.iconFavorite, onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
