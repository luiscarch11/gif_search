import 'package:gif_searcher/gif_search/domain/add_or_remove_gif_from_favorites_use_case.dart';
import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteAddOrRemoveGifFromFavoritesUseCase implements AddOrRemoveGifFromFavoritesUseCase {
  final Database db;

  SqfliteAddOrRemoveGifFromFavoritesUseCase(this.db);

  @override
  Future<void> execute(Gif gif) async {
    final favoriteGifs = await db.query(
      'favorite_gifs',
      where: 'id = ?',
      whereArgs: [gif.id],
    );
    if (favoriteGifs.isEmpty) {
      await db.insert(
        'favorite_gifs',
        {
          'id': gif.id,
          'title': gif.title,
          'is_favorite': 1,
        },
      );
    } else {
      await db.delete(
        'favorite_gifs',
        where: 'id = ?',
        whereArgs: [gif.id],
      );
    }
  }
}
