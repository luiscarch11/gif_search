final class Gif {
  final String url;
  final String id;
  final int height;
  final String title;
  final bool isFavorite;
  const Gif({
    required this.url,
    required this.id,
    required this.height,
    required this.title,
    required this.isFavorite,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Gif &&
        other.url == url &&
        other.id == id &&
        other.height == height &&
        other.title == title &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return url.hashCode ^ id.hashCode ^ height.hashCode ^ title.hashCode ^ isFavorite.hashCode;
  }

  Gif copyWith({
    String? url,
    String? id,
    int? height,
    String? title,
    bool? isFavorite,
  }) {
    return Gif(
      url: url ?? this.url,
      id: id ?? this.id,
      height: height ?? this.height,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
