part of '../search_page.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchPageCubit, SearchPageState>(
      listenWhen: (previous, current) => previous.gifsOrFailure != current.gifsOrFailure,
      listener: (context, state) {
        if (state.gifsOrFailure.$1 != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                switch (state.gifsOrFailure.$1!) {
                  GifSearchFailure.connectionError => 'Loading',
                  GifSearchFailure.serverError => 'Server error',
                  GifSearchFailure.unknownError => 'Unknown error',
                },
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.gifsToShow != current.gifsToShow ||
          previous.isLoadingFirstTime != current.isLoadingFirstTime ||
          previous.isLoadingPagination != current.isLoadingPagination,
      builder: (ctx, state) {
        if (state.gifsOrFailure.$1 != null) {
          return TextButton(
            onPressed: context.read<SearchPageCubit>().retryLastCall,
            child: const Row(
              children: [
                Icon(Icons.refresh),
                Text('Retry'),
              ],
            ),
          );
        }
        if (state.isLoadingFirstTime) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return _ScrollableStaggeredGifResults(
          gifsToShow: state.gifsToShow,
          hasMoreItems: state.gifsOrFailure.$2?.hasMoreData ?? false,
          isLoading: state.isLoadingPagination,
        );
      },
    );
  }
}

class _ScrollableStaggeredGifResults extends StatefulWidget {
  const _ScrollableStaggeredGifResults({
    required this.hasMoreItems,
    required this.isLoading,
    required this.gifsToShow,
  });
  final bool hasMoreItems;
  final bool isLoading;
  final List<Gif> gifsToShow;
  @override
  State<_ScrollableStaggeredGifResults> createState() => _ScrollableStaggeredGifResultsState();
}

class _ScrollableStaggeredGifResultsState extends State<_ScrollableStaggeredGifResults> {
  ScrollController? controller;
  @override
  void initState() {
    controller = ScrollController();
    controller!.addListener(
      () {
        if (controller!.position.pixels >= controller!.position.maxScrollExtent - 20 &&
            widget.hasMoreItems &&
            !widget.isLoading) {
          context.read<SearchPageCubit>().onRequestedMore();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: MasonryGridView.builder(
              controller: controller,
              itemCount: widget.gifsToShow.length,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (ctx, index) {
                return _GifToShow(
                  gif: widget.gifsToShow[index],
                );
              },
            ),
          ),
          if (widget.isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            )
        ],
      ),
    );
  }
}

class _GifToShow extends StatelessWidget {
  const _GifToShow({
    required this.gif,
  });
  final Gif gif;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => context.read<SearchPageCubit>().addOrRemoveFromFavorites(gif),
      child: Stack(
        children: [
          Image.network(
            gif.url,
            height: gif.height.toDouble(),
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: gif.isFavorite ? const Color(0xFFe54c33) : Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  gif.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  size: 16,
                  color: gif.isFavorite ? Colors.white : const Color(0xFFe54c33),
                ),
                onPressed: () => context.read<SearchPageCubit>().addOrRemoveFromFavorites(gif),
                color: const Color(0xFFe54c33),
                style: ButtonStyle(
                  shadowColor: gif.isFavorite
                      ? MaterialStateProperty.all(
                          const Color(0xFFe54c33),
                        )
                      : null,
                  elevation: MaterialStateProperty.all(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
