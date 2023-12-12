import 'package:gif_searcher/shared/domain/number_constants.dart';

final class StringConstants {
  static const _giphyBaseUrl = 'https://api.giphy.com/v1/gifs';
  static const _giphyAPIKey = String.fromEnvironment('GIPHY_API_KEY');
  static const giphySearchUrl = '$_giphyBaseUrl/search?api_key=$_giphyAPIKey';
  static const localDatabaseName = 'gif_searcher_database';
  static String giphySearchWithPaginationUrl(
    String searchQuery, [
    int offset = 0,
    int limit = NumberConstants.maximumGifsPerPage,
  ]) {
    return '$giphySearchUrl&q=$searchQuery&limit=$limit&offset=$offset';
  }
}
