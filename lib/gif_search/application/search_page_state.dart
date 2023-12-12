part of 'search_page_cubit.dart';

@immutable
class SearchPageState {
  final bool isLoadingPagination;
  final bool isLoadingFirstTime;
  final (GifSearchFailure?, PaginatedResponse<Gif>?) gifsOrFailure;
  final String searchQuery;
  final List<Gif> gifsToShow;
  const SearchPageState(
    this.isLoadingPagination,
    this.isLoadingFirstTime,
    this.gifsOrFailure,
    this.searchQuery,
    this.gifsToShow,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchPageState &&
        other.isLoadingPagination == isLoadingPagination &&
        other.isLoadingFirstTime == isLoadingFirstTime &&
        other.gifsOrFailure == gifsOrFailure &&
        other.searchQuery == searchQuery &&
        listEquals(other.gifsToShow, gifsToShow);
  }

  @override
  int get hashCode {
    return isLoadingPagination.hashCode ^
        isLoadingFirstTime.hashCode ^
        gifsOrFailure.hashCode ^
        searchQuery.hashCode ^
        gifsToShow.hashCode;
  }

  SearchPageState copyWith({
    bool? isLoadingPagination,
    bool? isLoadingFirstTime,
    (GifSearchFailure?, PaginatedResponse<Gif>?)? gifsOrFailure,
    String? searchQuery,
    List<Gif>? gifsToShow,
  }) {
    return SearchPageState(
      isLoadingPagination ?? this.isLoadingPagination,
      isLoadingFirstTime ?? this.isLoadingFirstTime,
      gifsOrFailure ?? this.gifsOrFailure,
      searchQuery ?? this.searchQuery,
      gifsToShow ?? this.gifsToShow,
    );
  }
}

final class SearchPageInitial extends SearchPageState {
  const SearchPageInitial()
      : super(
          false,
          false,
          (
            null,
            null,
          ),
          '',
          const [],
        );
}
