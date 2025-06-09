part of 'upload_bloc.dart';

class UploadState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool isButtonEnabled;
  final bool isFileSelection;
  final List<File> files;
  final String firstFileType;
  final bool hasUploadedSuccessfully;
  final bool loadingFileSelection;

  const UploadState({
    this.pageState = PageState.initial,
    this.errorMessage,
    this.isButtonEnabled = true,
    this.isFileSelection = true,
    this.files = const [],
    this.firstFileType = 'application/octet-stream',
    this.hasUploadedSuccessfully = false,
    this.loadingFileSelection = false,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, isButtonEnabled, isFileSelection, files,firstFileType, hasUploadedSuccessfully, loadingFileSelection];

  UploadState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isButtonEnabled,
    bool? isFileSelection,
    List<File>? files,
    String? firstFileType,
    bool? hasUploadedSuccessfully,
    bool? loadingFileSelection,
  }) {
    return UploadState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isFileSelection: isFileSelection ?? this.isFileSelection,
      files: files ?? this.files,
      firstFileType: firstFileType ?? this.firstFileType,
      hasUploadedSuccessfully: hasUploadedSuccessfully ?? this.hasUploadedSuccessfully,
      loadingFileSelection: loadingFileSelection ?? this.loadingFileSelection,
    );
  }
}
