enum MediaType { image, video }

class MediaModel {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;
  final MediaType type;

  MediaModel({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.type,
  });

 factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      type: MediaType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaType.image,
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'type': type.name,
    };
  }
}
