part of 'audio_bloc.dart';

@immutable
sealed class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

class InitialAudioEvent extends AudioEvent {}

class GetAllAudiosEvent extends AudioEvent {}

class GetAudiosCountEvent extends AudioEvent {}

class ScrollEvent extends AudioEvent {}

class RefreshEvent extends AudioEvent {}
