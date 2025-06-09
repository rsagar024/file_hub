import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:file_hub/core/services/audio_service/audio_page_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioControlButtons extends StatelessWidget {
  final bool shuffle;
  final bool miniPlayer;
  final List buttons;

  const AudioControlButtons({
    super.key,
    this.shuffle = false,
    this.miniPlayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
  });

  @override
  Widget build(BuildContext context) {
    final audioPageManager = getIt<AudioPageManager>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Previous':
            return ValueListenableBuilder<bool>(
              valueListenable: audioPageManager.isFirstSongNotifier,
              builder: (context, isFirst, _) {
                return IconButton(
                  onPressed: isFirst ? null : audioPageManager.previous,
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    ImageResources.iconPrevious,
                    width: miniPlayer ? 15 : 50,
                    height: miniPlayer ? 15 : 50,
                  ),
                );
              },
            );
          case 'Next':
            return ValueListenableBuilder<bool>(
              valueListenable: audioPageManager.isLastSongNotifier,
              builder: (context, isLast, _) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: isLast ? null : audioPageManager.next,
                  icon: SvgPicture.asset(
                    ImageResources.iconNext,
                    width: miniPlayer ? 15 : 50,
                    height: miniPlayer ? 15 : 50,
                  ),
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              width: miniPlayer ? 50 : 70,
              height: miniPlayer ? 50 : 70,
              child: ValueListenableBuilder<AudioButtonState>(
                valueListenable: audioPageManager.audioPlayButtonNotifier,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      if (value == AudioButtonState.loading)
                        Center(
                          child: SizedBox(
                            width: miniPlayer ? 60 : 70,
                            height: miniPlayer ? 60 : 70,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        ),
                      if (miniPlayer)
                        Center(
                          child: value == AudioButtonState.playing
                              ? IconButton(
                                  onPressed: audioPageManager.pause,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPause,
                                    width: miniPlayer ? 40 : 50,
                                    height: miniPlayer ? 40 : 50,
                                  ),
                                )
                              : IconButton(
                                  onPressed: audioPageManager.play,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPlay,
                                    width: miniPlayer ? 40 : 50,
                                    height: miniPlayer ? 40 : 50,
                                  ),
                                ),
                        )
                      else
                        Center(
                          child: value == AudioButtonState.paused
                              ? IconButton(
                                  onPressed: audioPageManager.play,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPause,
                                    width: miniPlayer ? 20 : 50,
                                    height: miniPlayer ? 20 : 50,
                                  ),
                                )
                              : IconButton(
                                  onPressed: audioPageManager.pause,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPlay,
                                    width: miniPlayer ? 20 : 50,
                                    height: miniPlayer ? 20 : 50,
                                  ),
                                ),
                        )
                    ],
                  );
                },
              ),
            );
          default:
            return Container();
        }
      }).toList(),
    );
  }
}
