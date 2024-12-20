class FileUploadState {
  final String fileName;
  final String message;
  final bool isSuccess;
  final bool showPopup;

  FileUploadState.success({required this.fileName, required this.message})
      : isSuccess = true,
        showPopup = false;

  FileUploadState.error({required this.fileName, required this.message})
      : isSuccess = false,
        showPopup = false;

  FileUploadState.popup({required this.message})
      : fileName = '',
        isSuccess = false,
        showPopup = true;
}
