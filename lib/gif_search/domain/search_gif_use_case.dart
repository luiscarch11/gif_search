import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:gif_searcher/gif_search/domain/gif_search_failure.dart';
import 'package:gif_searcher/shared/domain/paginated_response.dart';

abstract interface class SearchGifUseCase {
  Future<(GifSearchFailure?, PaginatedResponse<Gif>?)> execute(String query);
  Future<(GifSearchFailure?, PaginatedResponse<Gif>?)> requestedMore();
}
