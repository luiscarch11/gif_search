import 'package:gif_searcher/gif_search/domain/gif.dart';

class GiphyGifDto {
  const GiphyGifDto._({
    required this.url,
    required this.id,
    required this.height,
    required this.title,
  });
  final String url;
  final String id;
  final String title;
  final int height;

  factory GiphyGifDto.fromJson(Map<String, dynamic> json) {
    return GiphyGifDto._(
      url: json['images']['downsized']['url'],
      id: json['id'],
      title: json['title'],
      height: int.parse(
        json['images']['downsized']['height'] as String,
      ),
    );
  }

  factory GiphyGifDto.fromDomain(Gif domain) {
    return GiphyGifDto._(
      url: domain.url,
      height: domain.height,
      id: domain.id,
      title: domain.title,
    );
  }
}
