import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/movie_modern_bloc.dart';
import '../widgets/movie_list_item.dart';

/// Versão refatorada da MovieListView usando AppPaginatedList
class MovieListViewNew extends StatefulWidget {
  const MovieListViewNew({super.key});

  @override
  State<MovieListViewNew> createState() => _MovieListViewNewState();
}

class _MovieListViewNewState extends State<MovieListViewNew> {
  @override
  void initState() {
    super.initState();

    // Dispara o evento para carregar filmes em cartaz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieModernBloc>().add(
            const MovieModernNowPlayingFetched(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieModernBloc, MovieModernState>(
      builder: (context, state) {
        return AppPaginatedList(
          // === DADOS DA LISTA ===
          items: state.movies,
          hasReachedMax: state.hasReachedMax,
          isLoadingMore: state.status == MovieModernStatus.loading &&
              state.movies.isNotEmpty,
          isLoading:
              state.status == MovieModernStatus.loading && state.movies.isEmpty,
          hasError: state.status == MovieModernStatus.failure,
          errorMessage: state.errorMessage,

          // === BUILDERS ===
          itemBuilder: (context, movie, index) {
            return MovieListItem(movie: movie);
          },

          // === CALLBACKS ===
          onLoadMore: () => _handleLoadMore(state),
          onRefresh: () => _handleRefresh(),
          onRetry: () => _handleRetry(),

          // === CONFIGURAÇÕES ===
          emptyStateConfig: const AppEmptyStateConfig(
            icon: Icons.movie_outlined,
            title: 'Nenhum filme encontrado',
            subtitle: 'Não encontramos filmes para exibir.',
            variant: AppEmptyStateVariant.movies,
          ),

          scrollConfig: const AppScrollConfig(
            loadMoreThreshold: 0.9,
            scrollPhysics: AppScrollPhysicsType.bouncing,
            refreshIndicatorColor: AppDesignSystem.accentColor,
            refreshBackgroundColor: AppDesignSystem.cardColor,
            refreshStrokeWidth: 3.0,
            refreshDisplacement: 50.0,
            loadingMoreMessage: 'Carregando mais filmes...',
          ),

          layoutConfig: AppListLayoutConfig(
            padding: const EdgeInsets.only(
              top: AppDesignSystem.spaceMd,
              bottom: AppDesignSystem.spaceXl, // Espaço extra no final
              left: AppDesignSystem.spaceSm,
              right: AppDesignSystem.spaceSm,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppDesignSystem.backgroundColor,
                  AppDesignSystem.backgroundColor.withOpacity(0.95),
                  AppDesignSystem.primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            shrinkWrap: false,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
            cacheExtent: 500.0,
            separatorHeight: AppDesignSystem.spaceSm,
          ),

          animationConfig: const AppListAnimationConfig(
            enableItemAnimation: true,
            animationDuration: 300,
            staggerDelay: 50,
            animationCurve: Curves.easeOutBack,
          ),
        );
      },
    );
  }

  void _handleLoadMore(MovieModernState state) {
    // Se está em modo de busca, carrega mais resultados da busca
    if (state.isSearchMode && state.searchQuery != null) {
      context.read<MovieModernBloc>().add(
            MovieModernSearchRequested(state.searchQuery!),
          );
    } else {
      // Senão, carrega mais filmes em cartaz
      context.read<MovieModernBloc>().add(
            const MovieModernNowPlayingFetched(),
          );
    }
  }

  Future<void> _handleRefresh() async {
    // Reset da paginação e recarregamento
    context.read<MovieModernBloc>().add(
          const MovieModernNowPlayingFetched(),
        );

    // Simula um delay mínimo para UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _handleRetry() {
    context.read<MovieModernBloc>().add(
          const MovieModernNowPlayingFetched(),
        );
  }
}
