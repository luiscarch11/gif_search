import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_searcher/gif_search/domain/add_or_remove_gif_from_favorites_use_case.dart';
import 'package:gif_searcher/gif_search/domain/search_gif_use_case.dart';
import 'package:gif_searcher/gif_search/infrastructure/giphy_api_search_gif_use_case.dart';
import 'package:gif_searcher/gif_search/infrastructure/sqflite_add_or_remove_gif_from_favorites_use_case.dart';
import 'package:gif_searcher/shared/infrastructure/sqflite_database_initialization.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryManagerInitializer {
  static Future<MultiRepositoryProvider> initialize(
    Widget app,
  ) async {
    final db = await SQFLiteDatabaseInitialization.initialize();
    final dio = Dio();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Database>(
          create: (_) => db,
        ),
        RepositoryProvider<SearchGifUseCase>(
          create: (context) => GiphyApiSearchGifUseCase(
            dio,
            context.read<Database>(),
          ),
        ),
        RepositoryProvider<AddOrRemoveGifFromFavoritesUseCase>(
          create: (context) => SqfliteAddOrRemoveGifFromFavoritesUseCase(
            context.read<Database>(),
          ),
        ),
      ],
      child: app,
    );
  }
}
