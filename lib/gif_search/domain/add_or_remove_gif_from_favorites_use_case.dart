import 'package:gif_searcher/gif_search/domain/gif.dart';

abstract interface class AddOrRemoveGifFromFavoritesUseCase {
  Future<void> execute(Gif gif);
}
