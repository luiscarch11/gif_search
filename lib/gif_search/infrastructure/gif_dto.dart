import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:gif_searcher/gif_search/infrastructure/giphy_gif_dto.dart';

class GifDto {
  final String id;
  final String title;
  final int height;
  final String url;
  final bool isFavorite;

  factory GifDto.fromGiphyGifAndBool(GiphyGifDto giphyGifDto, bool isFavorite) {
    return GifDto(
      id: giphyGifDto.id,
      title: giphyGifDto.title,
      height: giphyGifDto.height,
      url: giphyGifDto.url,
      isFavorite: isFavorite,
    );
  }

  GifDto({
    required this.id,
    required this.title,
    required this.height,
    required this.url,
    required this.isFavorite,
  });
  Gif get toDomain {
    return Gif(
      id: id,
      title: title,
      height: height,
      url: url,
      isFavorite: isFavorite,
    );
  }
}
