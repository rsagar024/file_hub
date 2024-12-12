class FileTypeChecker {
  static String checkFileType(String mimeType){
    String fieldName;
    if (mimeType.startsWith('image/')) {
      fieldName = 'image';
    } else if (mimeType.startsWith('video/')) {
      fieldName = 'video';
    } else if (mimeType.startsWith('audio/')) {
      fieldName = 'audio';
    } else {
      fieldName = 'document';
    }
    return fieldName;
  }
}