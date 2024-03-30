enum DocType {
  image(0, "image"),
  video(1, "video"),
  pdf(2, "pdf"),
  audio(3, "audio"),
  document(4, "document");

  const DocType(this.type, this.name);

  final int type;
  final String name;
}
