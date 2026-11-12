import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di_extensions.dart';
import '../../../../core/mixins/design_system_mixin.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/movie_modern_bloc.dart';
import '../widgets/search_results_list.dart';

class SearchMoviesPage extends StatelessWidget {
  final bool embedded;
  final FocusNode? focusNode;
  const SearchMoviesPage({super.key, this.embedded = false, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieModernBloc>(
      create: context.createMovieModernBloc,
      child: _SearchMoviesView(embedded: embedded, focusNode: focusNode),
    );
  }
}

class _SearchMoviesView extends StatefulWidget {
  final bool embedded;
  final FocusNode? focusNode;
  const _SearchMoviesView({required this.embedded, this.focusNode});

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
    if (_searchController.text.trim().isEmpty) {
      setState(() {});
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        _searchMovies();
      }
    });
  }

  void _searchMovies() {
    _debounceTimer?.cancel();
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    context.read<MovieModernBloc>().add(MovieModernSearchRequested(query));
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        AppSearchField(
          controller: _searchController,
          hintText: 'Busque pelo nome do filme',
          onSubmitted: (_) => _searchMovies(),
          autofocus: !widget.embedded,
          focusNode: widget.focusNode,
        ),
        verticalSpaceMd,
        Expanded(
          child: BlocBuilder<MovieModernBloc, MovieModernState>(
            builder: (context, state) {
              if (_searchController.text.trim().isEmpty ||
                  !state.isSearchMode) {
                return const _EmptySearchState();
              }

              return switch (state.status) {
                MovieModernStatus.loading when state.movies.isEmpty =>
                  const AppLoading.large(message: 'Buscando filmes...'),
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
    );
    final body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: content,
        ),
      ),
    );
    if (widget.embedded) return body;
    return AppPageLayout(title: 'Buscar', body: body, appBarHeight: 64);
  }
}

// Estado vazio quando ainda não pesquisou
class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return const _SearchMessage(
      title: 'Qual filme você procura?',
      message: 'Busque um título para ver a sinopse e a nota do catálogo.',
      icon: Icons.search_rounded,
    );
  }
}

// Estado de erro na busca
class _SearchErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _SearchErrorState({required this.errorMessage, required this.onRetry});

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
    return const _SearchMessage(
      title: 'Nenhum filme encontrado',
      message: 'Tente outro título ou confira como ele foi escrito.',
      icon: Icons.search_off_rounded,
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const _SearchMessage({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
