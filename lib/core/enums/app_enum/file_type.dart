enum FileType {
  image(0, 'image'),
  audio(1, 'audio'),
  video(2, 'video'),
  document(3, 'document');

  final int value;
  final String description;

  const FileType(this.value, this.description);
}
