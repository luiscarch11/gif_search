import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:gif_searcher/gif_search/domain/gif_search_failure.dart';
import 'package:gif_searcher/gif_search/domain/search_gif_use_case.dart';
import 'package:gif_searcher/gif_search/infrastructure/gif_dto.dart';
import 'package:gif_searcher/gif_search/infrastructure/giphy_gif_dto.dart';
import 'package:gif_searcher/shared/domain/number_constants.dart';
import 'package:gif_searcher/shared/domain/paginated_response.dart';
import 'package:gif_searcher/shared/domain/string_constants.dart';
import 'package:sqflite/sqflite.dart';

class GiphyApiSearchGifUseCase implements SearchGifUseCase {
  final Dio _dioClient;

  GiphyApiSearchGifUseCase(
    this._dioClient,
    this.db,
  );
  String? _lastQuery;
  int? _lastPage;
  final Database db;

  Future<List<Gif>> _getFavoriteGifsFrom(List<GiphyGifDto> giphyGifs) async {
    final favoriteGifs = await db.query(
      'favorite_gifs',
      where: 'id IN (${giphyGifs.map(
            (_) => '?',
          ).join(',')})',
      whereArgs: giphyGifs
          .map(
            (e) => e.id,
          )
          .toList(),
    );
    return giphyGifs.map((e) {
      final gifIndex = favoriteGifs.indexWhere(
        (element) => element['id'] == e.id,
      );
      if (gifIndex != -1) {
        return GifDto.fromGiphyGifAndBool(
          e,
          favoriteGifs[gifIndex]['is_favorite'] == 1,
        ).toDomain;
      }
      return GifDto.fromGiphyGifAndBool(
        e,
        false,
      ).toDomain;
    }).toList();
  }

  @override
  Future<(GifSearchFailure?, PaginatedResponse<Gif>?)> execute(String query) async {
    final searchUrl = StringConstants.giphySearchWithPaginationUrl(
      query,
    );
    try {
      final result = await _dioClient.get(searchUrl);
      final data = result.data as Map<String, dynamic>;
      final giphyGifs = (data['data'] as List<dynamic>)
          .map(
            (e) => GiphyGifDto.fromJson(e),
          )
          .toList();
      final listToReturn = await _getFavoriteGifsFrom(giphyGifs);
      final totalCount = data['pagination']['total_count'] as int;
      _lastQuery = query;
      _lastPage = 0;
      return (
        null,
        PaginatedResponse<Gif>(
          data: listToReturn,
          hasMoreData: totalCount > NumberConstants.maximumGifsPerPage,
        ),
      );
    } on SocketException {
      return (
        GifSearchFailure.connectionError,
        null,
      );
    } on DioException catch (_) {
      return (
        GifSearchFailure.serverError,
        null,
      );
    } catch (_) {
      return (
        GifSearchFailure.unknownError,
        null,
      );
    }
  }

  @override
  Future<(GifSearchFailure?, PaginatedResponse<Gif>?)> requestedMore() async {
    if (_lastPage == null || _lastQuery == null) {
      return (
        GifSearchFailure.unknownError,
        null,
      );
    }
    final searchUrl = StringConstants.giphySearchWithPaginationUrl(
      _lastQuery!,
      _lastPage! + 1,
    );
    try {
      final result = await _dioClient.get(searchUrl);
      final data = result.data as Map<String, dynamic>;
      final giphyGifs = (data['data'] as List<dynamic>)
          .map(
            (e) => GiphyGifDto.fromJson(e),
          )
          .toList();
      final listToReturn = await _getFavoriteGifsFrom(giphyGifs);
      final totalCount = data['pagination']['total_count'] as int;
      _lastPage = _lastPage! + 1;
      return (
        null,
        PaginatedResponse<Gif>(
          data: listToReturn,
          hasMoreData: totalCount > NumberConstants.maximumGifsPerPage * _lastPage! + 1,
        ),
      );
    } on SocketException {
      return (
        GifSearchFailure.connectionError,
        null,
      );
    } on DioException catch (_) {
      return (
        GifSearchFailure.serverError,
        null,
      );
    } catch (_) {
      return (
        GifSearchFailure.unknownError,
        null,
      );
    }
  }
}
