import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_searcher/gif_search/domain/add_or_remove_gif_from_favorites_use_case.dart';
import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:gif_searcher/gif_search/domain/gif_search_failure.dart';
import 'package:gif_searcher/gif_search/domain/search_gif_use_case.dart';
import 'package:gif_searcher/shared/domain/paginated_response.dart';

part 'search_page_state.dart';

enum _LastCallType {
  search,
  requestedMore;
}

class SearchPageCubit extends Cubit<SearchPageState> {
  SearchPageCubit(
    this._searchGifUseCase,
    this._addOrRemoveGifFromFavoritesUseCase,
  ) : super(
          const SearchPageInitial(),
        );
  final SearchGifUseCase _searchGifUseCase;
  final AddOrRemoveGifFromFavoritesUseCase _addOrRemoveGifFromFavoritesUseCase;

  var _lastCallType = _LastCallType.search;
  void onTextFieldChanged(String value) {
    emit(
      state.copyWith(
        searchQuery: value,
      ),
    );
  }

  void addOrRemoveFromFavorites(Gif gif) async {
    await _addOrRemoveGifFromFavoritesUseCase.execute(gif);
    final listToEmit = List<Gif>.from(
      state.gifsToShow,
    );
    final index = listToEmit.indexWhere(
      (element) => element.id == gif.id,
    );
    listToEmit[index] = gif.copyWith(
      isFavorite: !gif.isFavorite,
    );
    emit(
      state.copyWith(
        gifsToShow: listToEmit,
      ),
    );
  }

  void onSubmitted() async {
    _lastCallType = _LastCallType.search;
    emit(
      state.copyWith(
        isLoadingFirstTime: true,
      ),
    );
    final result = await _searchGifUseCase.execute(state.searchQuery);
    if (result.$2 != null) {
      emit(
        state.copyWith(
          isLoadingFirstTime: false,
          gifsOrFailure: result,
          gifsToShow: result.$2!.data,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoadingFirstTime: false,
        gifsOrFailure: result,
      ),
    );
  }

  void retryLastCall() {
    switch (_lastCallType) {
      case _LastCallType.search:
        onSubmitted();
        break;
      case _LastCallType.requestedMore:
        onRequestedMore();
        break;
    }
  }

  void onRequestedMore() async {
    _lastCallType = _LastCallType.requestedMore;
    emit(
      state.copyWith(
        isLoadingPagination: true,
      ),
    );
    final result = await _searchGifUseCase.requestedMore();
    if (result.$2 != null) {
      emit(
        state.copyWith(
          isLoadingPagination: false,
          gifsOrFailure: result,
          gifsToShow: [...state.gifsToShow, ...result.$2!.data],
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoadingPagination: false,
        gifsOrFailure: result,
      ),
    );
  }
}
