part of 'video_bloc.dart';

class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class InitialVideoEvent extends VideoEvent {}

class GetAllVideosEvent extends VideoEvent {}

class GetVideosCountEvent extends VideoEvent {}
