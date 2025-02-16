import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/core/services/audio_service/audio_page_manager.dart';
import 'package:vap_uploader/features/audio/presentation/pages/audio_player_page.dart';
import 'package:vap_uploader/features/audio/presentation/widgets/audio_control_buttons.dart';

class MiniAudioPlayer extends StatefulWidget {
  static const MiniAudioPlayer _instance = MiniAudioPlayer._internal();

  factory MiniAudioPlayer() {
    return _instance;
  }

  const MiniAudioPlayer._internal();

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPageManager = getIt<AudioPageManager>();
    return ValueListenableBuilder<AudioProcessingState>(
      valueListenable: audioPageManager.playbackStateNotifier,
      builder: (context, processingState, _) {
        if (processingState == AudioProcessingState.idle) {
          return const SizedBox();
        }
        return ValueListenableBuilder<MediaItem?>(
          valueListenable: audioPageManager.currentSongNotifier,
          builder: (context, mediaItem, _) {
            if (mediaItem == null) return const SizedBox();
            return Dismissible(
              key: const Key('mini_player'),
              direction: DismissDirection.down,
              onDismissed: (direction) {
                Feedback.forLongPress(context);
                audioPageManager.stop();
              },
              child: Dismissible(
                key: Key(mediaItem.id),
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    audioPageManager.previous();
                  } else {
                    audioPageManager.next();
                  }
                  return Future.value(false);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  elevation: 0,
                  color: Colors.black.withOpacity(0.3),
                  child: SizedBox(
                    height: 76,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<AudioProgressBarState>(
                              valueListenable: audioPageManager.audioProgressNotifier,
                              builder: (context, value, _) {
                                final position = value.current;
                                final totalDuration = value.total;
                                return (position.inSeconds.toDouble() < 0.0 || (position.inSeconds.toDouble() > totalDuration.inSeconds.toDouble()))
                                    ? const SizedBox()
                                    : SliderTheme(
                                        data: const SliderThemeData(
                                          activeTrackColor: AppColors.primary,
                                          inactiveTrackColor: Colors.transparent,
                                          trackHeight: 3,
                                          thumbColor: Colors.green,
                                          thumbShape: RoundSliderOverlayShape(overlayRadius: 1.5),
                                          overlayColor: Colors.transparent,
                                          overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
                                        ),
                                        child: Center(
                                          child: Slider(
                                            inactiveColor: Colors.transparent,
                                            max: totalDuration.inSeconds.toDouble(),
                                            value: position.inSeconds.toDouble(),
                                            onChanged: (newPosition) {
                                              audioPageManager.seek(Duration(seconds: newPosition.round()));
                                            },
                                          ),
                                        ),
                                      );
                              },
                            ),
                            ListTile(
                              dense: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) => const AudioPlayerPage(),
                                  ),
                                );
                              },
                              title: Text(
                                mediaItem.title,
                                style: CustomTextStyles.custom15Regular,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                mediaItem.artist ?? '',
                                style: CustomTextStyles.custom11Regular,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Hero(
                                tag: 'currentArtWork',
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox.square(
                                    dimension: 40,
                                    child: Image.network(
                                      mediaItem.artUri.toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(ImageResources.imagePerson, fit: BoxFit.cover);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              trailing: const AudioControlButtons(miniPlayer: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
