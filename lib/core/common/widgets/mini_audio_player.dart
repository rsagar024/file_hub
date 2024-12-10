import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/common/widgets/control_buttons.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/services/audio_service/page_manager.dart';

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
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<AudioProcessingState>(
      valueListenable: pageManager.playbackStateNotifier,
      builder: (context, processingState, _) {
        if (processingState == AudioProcessingState.idle) {
          return const SizedBox();
        }
        return ValueListenableBuilder<MediaItem?>(
          valueListenable: pageManager.currentSongNotifier,
          builder: (context, mediaItem, _) {
            if (mediaItem == null) return const SizedBox();
            return Dismissible(
              key: const Key('mini_player'),
              direction: DismissDirection.down,
              onDismissed: (direction) {
                Feedback.forLongPress(context);
                pageManager.stop();
              },
              child: Dismissible(
                key: Key(mediaItem.id),
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    pageManager.previous();
                  } else {
                    pageManager.next();
                  }
                  return Future.value(false);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  elevation: 0,
                  color: Colors.white,
                  child: SizedBox(
                    height: 76,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<ProgressBarState>(
                              valueListenable: pageManager.progressNotifier,
                              builder: (context, value, _) {
                                final position = value.current;
                                final totalDuration = value.total;
                                return (position.inSeconds.toDouble() < 0.0 || (position.inSeconds.toDouble() > totalDuration.inSeconds.toDouble()))
                                    ? const SizedBox()
                                    : SliderTheme(
                                        data: const SliderThemeData(
                                          activeTrackColor: Colors.green,
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
                                              pageManager.seek(Duration(seconds: newPosition.round()));
                                            },
                                          ),
                                        ),
                                      );
                              },
                            ),
                            ListTile(
                              dense: false,
                              onTap: () {},
                              title: Text(mediaItem.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text(mediaItem.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
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
                              trailing: const ControlButtons(
                                miniPlayer: true,
                                buttons: ['Play/Pause', 'Next'],
                              ),
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
