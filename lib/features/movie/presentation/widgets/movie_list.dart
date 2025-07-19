import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/theme/app_design_system.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_modern_bloc.dart';
import 'package:movie_app/features/movie/presentation/widgets/movie_list_item.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({super.key});

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

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
        return Stack(
          children: [
            // Lista principal
            switch (state.status) {
              MovieModernStatus.initial =>
                const Center(child: CircularProgressIndicator(color: Colors.black)),
              MovieModernStatus.loading when state.movies.isEmpty =>
                const Center(child: CircularProgressIndicator(color: Colors.black)),
              MovieModernStatus.failure => Center(
                  child:
                      Text('Erro: ${state.errorMessage ?? "Erro desconhecido"}')),
              MovieModernStatus.success =>
                _buildMovieList(state.movies, state.hasReachedMax),
              MovieModernStatus.loading => _buildMovieList(
                  state.movies, false), // Mostra loading no fim da lista
            },
            
            // Botão de voltar ao topo
            if (_showScrollToTop)
              Positioned(
                bottom: AppDesignSystem.spaceLg,
                right: AppDesignSystem.spaceLg,
                child: _buildScrollToTopButton(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildScrollToTopButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppDesignSystem.accentGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppDesignSystem.accentColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        mini: true,
        onPressed: _scrollToTop,
        backgroundColor: Colors.transparent,
        foregroundColor: AppDesignSystem.textPrimaryColor,
        elevation: 0,
        child: const Icon(
          Icons.keyboard_arrow_up_rounded,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildMovieList(List movies, bool hasReachedMax) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_outlined,
              size: 64,
              color: AppDesignSystem.textSecondaryColor,
            ),
            const SizedBox(height: AppDesignSystem.spaceMd),
            Text(
              'Nenhum filme encontrado',
              style: AppDesignSystem.titleMedium.copyWith(
                color: AppDesignSystem.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
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
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppDesignSystem.accentColor,
        backgroundColor: AppDesignSystem.cardColor,
        strokeWidth: 3.0,
        displacement: 50.0,
        child: ListView.separated(
          controller: _scrollController,
          
          // === CONFIGURAÇÕES DE PADDING E ESPAÇAMENTO ===
          padding: const EdgeInsets.only(
            top: AppDesignSystem.spaceMd,
            bottom: AppDesignSystem.spaceXl, // Espaço extra no final
            left: AppDesignSystem.spaceSm,
            right: AppDesignSystem.spaceSm,
          ),
          
          // === CONFIGURAÇÕES DE FÍSICA DE SCROLL ===
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          
          // === CONFIGURAÇÕES DE PERFORMANCE ===
          clipBehavior: Clip.antiAlias,
          shrinkWrap: false, // Para performance otimizada
          addAutomaticKeepAlives: true, // Mantém widgets na memória
          addRepaintBoundaries: true, // Otimiza repaint
          addSemanticIndexes: true, // Para acessibilidade
          
          // === CONFIGURAÇÕES DE CACHE ===
          cacheExtent: 500.0, // Cache extra para scroll suave
          
          // === CONFIGURAÇÕES EXISTENTES ===
          itemCount: hasReachedMax ? movies.length : movies.length + 1,
          separatorBuilder: (context, index) => const SizedBox(
            height: AppDesignSystem.spaceSm,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index >= movies.length) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.spaceXl),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppDesignSystem.cardColor,
                          AppDesignSystem.cardColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppDesignSystem.accentColor,
                                AppDesignSystem.accentColor.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.movie_creation_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: AppDesignSystem.spaceMd),
                        Text(
                          'Carregando mais filmes...',
                          style: AppDesignSystem.bodyMedium.copyWith(
                            color: AppDesignSystem.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 50)),
              curve: Curves.easeOutBack,
              child: MovieListItem(movie: movies[index]),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Reset da paginação e recarregamento
    context.read<MovieModernBloc>().add(
      const MovieModernNowPlayingFetched(),
    );
    
    // Simula um delay mínimo para UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Controle do botão "voltar ao topo"
    final bool shouldShowButton = _scrollController.offset > 500;
    if (shouldShowButton != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShowButton;
      });
    }

    // Carregamento infinito (pagination)
    if (_isBottom) {
      final state = context.read<MovieModernBloc>().state;

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
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}
