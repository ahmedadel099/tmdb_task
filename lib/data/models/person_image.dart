class PersonImage {
  final String filePath;
  final double aspectRatio;

  PersonImage({
    required this.filePath,
    required this.aspectRatio,
  });

  factory PersonImage.fromJson(Map<String, dynamic> json) {
    return PersonImage(
      filePath: json['file_path'],
      aspectRatio: json['aspect_ratio'].toDouble(),
    );
  }
}
