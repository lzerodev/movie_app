import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di_extensions.dart';
import '../../../../core/mixins/design_system_mixin.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/movie_modern_bloc.dart';
import '../widgets/search_results_list.dart';

class SearchMoviesPage extends StatelessWidget {
  const SearchMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieModernBloc>(
      create: context.createMovieModernBloc,
      child: const _SearchMoviesView(),
    );
  }
}

class _SearchMoviesView extends StatefulWidget {
  const _SearchMoviesView();

  @override
  State<_SearchMoviesView> createState() => _SearchMoviesViewState();
}

class _SearchMoviesViewState extends State<_SearchMoviesView>
    with DesignSystemMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        _searchMovies();
      }
    });
  }

  void _searchMovies() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    context.read<MovieModernBloc>().add(
          MovieModernSearchRequested(query),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: 'Buscar Filmes',
      padding: defaultPadding,
      body: Column(
        children: [
          AppSearchField(
            controller: _searchController,
            hintText: 'Digite o nome do filme...',
            onSubmitted: (_) => _searchMovies(),
            autofocus: true,
          ),
          verticalSpaceMd,
          Expanded(
            child: BlocBuilder<MovieModernBloc, MovieModernState>(
              builder: (context, state) {
                if (!state.isSearchMode) {
                  return const _EmptySearchState();
                }

                return switch (state.status) {
                  MovieModernStatus.loading when state.movies.isEmpty =>
                    const AppLoading.large(
                      message: 'Buscando filmes...',
                    ),
                  MovieModernStatus.failure => _SearchErrorState(
                      errorMessage: state.errorMessage ?? 'Erro desconhecido',
                      onRetry: _searchMovies,
                    ),
                  MovieModernStatus.success when state.movies.isEmpty =>
                    const _NoResultsState(),
                  _ => SearchResultsList(movies: state.movies),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Estado vazio quando ainda não pesquisou
class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyPageLayout(
      showAppBar: false,
      emptyTitle: 'Encontre seus filmes favoritos',
      emptyMessage:
          'Digite o nome de um filme na barra de busca acima para começar a pesquisar.',
      emptyIcon: Icons.movie_filter_outlined,
    );
  }
}

// Estado de erro na busca
class _SearchErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _SearchErrorState({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorPageLayout(
      showAppBar: false,
      errorTitle: 'Erro ao buscar filmes',
      errorMessage: errorMessage,
      errorIcon: Icons.search_off,
      retryButtonText: 'Tentar novamente',
      onRetry: onRetry,
    );
  }
}

// Estado quando não há resultados
class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyPageLayout(
      showAppBar: false,
      emptyTitle: 'Nenhum filme encontrado',
      emptyMessage:
          'Tente pesquisar com outras palavras-chave ou verifique a ortografia.',
      emptyIcon: Icons.search_off,
    );
  }
}
