part of 'image_bloc.dart';

@immutable
sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

class InitialImageEvent extends ImageEvent {}

class GetAllImagesEvent extends ImageEvent {}

class GetImagesCountEvent extends ImageEvent {}

class ScrollEvent extends ImageEvent {}

class RefreshEvent extends ImageEvent {}
