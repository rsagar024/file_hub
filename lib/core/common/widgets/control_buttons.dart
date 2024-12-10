import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/services/audio_service/page_manager.dart';

class ControlButtons extends StatelessWidget {
  final bool shuffle;
  final bool miniPlayer;
  final List buttons;

  const ControlButtons({
    super.key,
    this.shuffle = false,
    this.miniPlayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
  });

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Previous':
            return ValueListenableBuilder<bool>(
              valueListenable: pageManager.isFirstSongNotifier,
              builder: (context, isFirst, _) {
                return IconButton(
                  onPressed: isFirst ? null : pageManager.previous,
                  icon: SvgPicture.asset(
                    ImageResources.iconPrevious,
                    width: miniPlayer ? 20 : 50,
                    height: miniPlayer ? 20 : 50,
                  ),
                );
              },
            );
          case 'Next':
            return ValueListenableBuilder<bool>(
              valueListenable: pageManager.isLastSongNotifier,
              builder: (context, isLast, _) {
                return IconButton(
                  onPressed: isLast ? null : pageManager.next,
                  icon: SvgPicture.asset(
                    ImageResources.iconNext,
                    width: miniPlayer ? 20 : 50,
                    height: miniPlayer ? 20 : 50,
                  ),
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              width: miniPlayer ? 40 : 70,
              height: miniPlayer ? 40 : 70,
              child: ValueListenableBuilder<ButtonState>(
                valueListenable: pageManager.playButtonNotifier,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      if (value == ButtonState.loading)
                        Center(
                          child: SizedBox(
                            width: miniPlayer ? 40 : 70,
                            height: miniPlayer ? 40 : 70,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        ),
                      if (miniPlayer)
                        Center(
                          child: value == ButtonState.playing
                              ? IconButton(
                                  onPressed: pageManager.pause,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPause,
                                    width: miniPlayer ? 20 : 50,
                                    height: miniPlayer ? 20 : 50,
                                  ),
                                )
                              : IconButton(
                                  onPressed: pageManager.play,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPlay,
                                    width: miniPlayer ? 20 : 50,
                                    height: miniPlayer ? 20 : 50,
                                  ),
                                ),
                        )
                      else
                        Center(
                          child: value == ButtonState.paused
                              ? IconButton(
                                  onPressed: pageManager.play,
                                  icon: SvgPicture.asset(
                                    ImageResources.iconPause,
                                    width: miniPlayer ? 20 : 50,
                                    height: miniPlayer ? 20 : 50,
                                  ),
                                )
                              : IconButton(
                                  onPressed: pageManager.pause,
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
