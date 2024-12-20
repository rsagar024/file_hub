part of 'upload_bloc.dart';

class UploadState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool isButtonEnabled;
  final bool isFileSelection;
  final List<File> files;
  final int uploadedFile;

  const UploadState({
    this.pageState = PageState.initial,
    this.errorMessage,
    this.isButtonEnabled = true,
    this.isFileSelection = true,
    this.files = const [],
    this.uploadedFile = 0,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, isButtonEnabled, isFileSelection, files, uploadedFile];

  UploadState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isButtonEnabled,
    bool? isFileSelection,
    List<File>? files,
    int? uploadedFile,
  }) {
    return UploadState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isFileSelection: isFileSelection ?? this.isFileSelection,
      files: files ?? this.files,
      uploadedFile: uploadedFile ?? this.uploadedFile,
    );
  }
}
