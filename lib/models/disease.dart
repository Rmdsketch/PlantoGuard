class Disease {
  final int diseaseId;
  final String label;
  final String plantName;
  final String imagePath;
  final String? cause;
  final String? solution;
  bool isFavorite;

  Disease({
    required this.diseaseId,
    required this.label,
    required this.plantName,
    required this.imagePath,
    this.cause,
    this.solution,
    this.isFavorite = false,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['id'],
      label: json['label'],
      plantName: json['name'],
      imagePath: json['image'],
      cause: json['cause'],
      solution: json['solution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": diseaseId,
      "label": label,
      "name": plantName,
      "image": imagePath.startsWith("http")
          ? imagePath.replaceFirst("http://127.0.0.1:5000", "")
          : imagePath,
      "cause": cause,
      "solution": solution,
    };
  }

  String get imageURL {
    return imagePath.startsWith("http")
        ? imagePath
        : "http://127.0.0.1:5000$imagePath";
  }
}
