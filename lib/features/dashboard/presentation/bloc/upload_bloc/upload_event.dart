part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

final class InitialUploadEvent extends UploadEvent {}

final class FilesSelectionEvent extends UploadEvent {}

final class FilesRemoveEvent extends UploadEvent {}

final class FilesUploadEvent extends UploadEvent {}

final class ClearAppCacheEvent extends UploadEvent {}
