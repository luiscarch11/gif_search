import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_searcher/gif_search/application/search_page_cubit.dart';
import 'package:gif_searcher/gif_search/domain/add_or_remove_gif_from_favorites_use_case.dart';
import 'package:gif_searcher/gif_search/domain/gif.dart';
import 'package:gif_searcher/gif_search/domain/gif_search_failure.dart';
import 'package:gif_searcher/gif_search/domain/search_gif_use_case.dart';
import 'package:gif_searcher/shared/presentation/search_text_field_widget.dart';

part 'widgets/search_results_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchPageCubit(
        context.read<SearchGifUseCase>(),
        context.read<AddOrRemoveGifFromFavoritesUseCase>(),
      ),
      child: const SearchPageView(),
    );
  }
}

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SearchTextFieldWidget(
                onSubmit: context.read<SearchPageCubit>().onSubmitted,
                onChanged: context.read<SearchPageCubit>().onTextFieldChanged,
              ),
              const SizedBox(
                height: 16,
              ),
              const SearchResultsView()
            ],
          ),
        ),
      ),
    );
  }
}
