import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/services/audio_service/audio_handler.dart';

enum AudioButtonState {
  paused,
  playing,
  loading,
}

class AudioPlayButtonNotifier extends ValueNotifier<AudioButtonState> {
  AudioPlayButtonNotifier() : super(_initialValue);
  static const _initialValue = AudioButtonState.paused;
}

class AudioProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  AudioProgressBarState({required this.current, required this.buffered, required this.total});
}

class AudioProgressNotifier extends ValueNotifier<AudioProgressBarState> {
  AudioProgressNotifier() : super(_initialValue);
  static final _initialValue = AudioProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

enum AudioRepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class AudioRepeatButtonNotifier extends ValueNotifier<AudioRepeatState> {
  AudioRepeatButtonNotifier() : super(_initialValue);
  static const _initialValue = AudioRepeatState.off;

  void nextState() {
    final next = (value.index + 1) % AudioRepeatState.values.length;
    value = AudioRepeatState.values[next];
  }
}

class AudioPageManager {
  final currentSongNotifier = ValueNotifier<MediaItem?>(null);
  final playbackStateNotifier = ValueNotifier<AudioProcessingState>(AudioProcessingState.idle);
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final audioProgressNotifier = AudioProgressNotifier();
  final audioRepeatButtonNotifier = AudioRepeatButtonNotifier();
  final audioPlayButtonNotifier = AudioPlayButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final audioHandler = getIt<AudioHandler>();

  void init() async {
    listenToChangeInPlaylist();
    listenToPlayBackState();
    listenToCurrentPosition();
    listenToBufferedPosition();
    listenToTotalPosition();
    listenToChangeInSong();
  }

  void listenToChangeInPlaylist() {
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongNotifier.value = null;
      } else {
        playlistNotifier.value = playlist;
      }
      updateSkipButton();
    });
  }

  void updateSkipButton() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;

    if (playlist.isEmpty || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
      return;
    }

    final currentIndex = playlist.indexWhere((item) => item.id == mediaItem.id);

    isFirstSongNotifier.value = currentIndex == 0;
    isLastSongNotifier.value = currentIndex == playlist.length - 1;
  }

  void listenToPlayBackState() {
    audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      playbackStateNotifier.value = processingState;
      if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
        audioPlayButtonNotifier.value = AudioButtonState.loading;
      } else if (!isPlaying) {
        audioPlayButtonNotifier.value = AudioButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        audioPlayButtonNotifier.value = AudioButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }

  void listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = AudioProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenToBufferedPosition() {
    audioHandler.playbackState.listen((playbackState) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = AudioProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenToTotalPosition() {
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = audioProgressNotifier.value;
      audioProgressNotifier.value = AudioProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void listenToChangeInSong() {
    audioHandler.mediaItem.listen((mediaItem) {
      currentSongNotifier.value = mediaItem;
      updateSkipButton();
    });
  }

  void play() => audioHandler.play();

  void pause() => audioHandler.pause();

  void seek(Duration position) => audioHandler.seek(position);

  void previous() => audioHandler.skipToPrevious();

  void next() => audioHandler.skipToNext();

  Future<void> playAs() async {
    return await audioHandler.play();
  }

  Future<void> updateQueue(List<MediaItem> queue) async {
    return await audioHandler.updateQueue(queue);
  }

  Future<void> updateMediaItem(MediaItem mediaItem) async {
    return await audioHandler.updateMediaItem(mediaItem);
  }

  Future<void> moveMediaItem(int currentIndex, int newIndex) async {
    return await (audioHandler as AudioPlayerHandler).moveQueueItem(currentIndex, newIndex);
  }

  Future<void> removeQueueItem(int index) async {
    return await (audioHandler as AudioPlayerHandler).removeQueueItemIndex(index);
  }

  Future<void> customAction(String name) async {
    return await audioHandler.customAction(name);
  }

  Future<void> skipToQueueItem(int index) async {
    return await audioHandler.skipToQueueItem(index);
  }

  void repeat() {
    audioRepeatButtonNotifier.nextState();
    final repeatMode = audioRepeatButtonNotifier.value;
    switch (repeatMode) {
      case AudioRepeatState.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case AudioRepeatState.repeatSong:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case AudioRepeatState.repeatPlaylist:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        audioRepeatButtonNotifier.value = AudioRepeatState.off;
        break;
      case AudioServiceRepeatMode.one:
        audioRepeatButtonNotifier.value = AudioRepeatState.repeatSong;
        break;
      case AudioServiceRepeatMode.group:
        break;
      case AudioServiceRepeatMode.all:
        audioRepeatButtonNotifier.value = AudioRepeatState.repeatPlaylist;
        break;
    }
    audioHandler.setRepeatMode(repeatMode);
  }

  Future<void> shuffle() async {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> setShuffleMode(AudioServiceShuffleMode value) async {
    isShuffleModeEnabledNotifier.value = value == AudioServiceShuffleMode.all;
    return audioHandler.setShuffleMode(value);
  }

  Future<void> add(MediaItem mediaItem) async {
    audioHandler.addQueueItem(mediaItem);
  }

  Future<void> adds(List<MediaItem> mediaItems, int index) async {
    if (mediaItems.isEmpty) return;
    await (audioHandler as MyAudioHandler).setNewPlaylist(mediaItems, index);
  }

  void remove() {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    audioHandler.removeQueueItemAt(lastIndex);
  }

  Future<void> removeAll() async {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    audioHandler.customAction('dispose');
  }

  Future<void> stop() async {
    await audioHandler.stop();
    await audioHandler.seek(Duration.zero);
    currentSongNotifier.value = null;
    await removeAll();
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
