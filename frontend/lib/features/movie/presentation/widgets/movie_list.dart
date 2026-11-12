import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_modern_bloc.dart';
import 'movie_list_item.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({super.key});
  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MovieModernBloc>().add(
          const MovieModernNowPlayingFetched(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<MovieModernBloc, MovieModernState>(
      builder: (context, state) {
        if (state.status == MovieModernStatus.initial ||
            (state.status == MovieModernStatus.loading &&
                state.movies.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == MovieModernStatus.failure && state.movies.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 40),
                  const SizedBox(height: 16),
                  const Text('Não foi possível carregar os filmes.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<MovieModernBloc>().add(
                      const MovieModernRefreshRequested(),
                    ),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.movies.isEmpty) {
          return const Center(
            child: Text('Nenhum filme em cartaz no momento.'),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0.0, 1080.0);
            final side = (constraints.maxWidth - width) / 2 + 8;
            final columns = width >= 900
                ? 4
                : width >= 600
                ? 3
                : 2;
            final tileWidth = (width - 16 - (columns - 1) * 16) / columns;
            final tileHeight =
                tileWidth * 1.5 +
                44 +
                MediaQuery.textScalerOf(context).scale(76);
            return RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(side, 12, side, 24),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FILMES EM CARTAZ',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'O que você vai assistir?',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          MovieListItem(
                            movie: state.movies.first,
                            featured: true,
                          ),
                          if (state.movies.length > 1) ...[
                            const SizedBox(height: 28),
                            Text(
                              'Mais filmes para descobrir',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: side),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: tileHeight,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => MovieListItem(
                          movie: state.movies[index + 1],
                          compact: false,
                        ),
                        childCount: state.movies.length - 1,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: state.status == MovieModernStatus.failure
                          ? TextButton(
                              onPressed: () => context
                                  .read<MovieModernBloc>()
                                  .add(const MovieModernNowPlayingFetched()),
                              child: const Text(
                                'Não foi possível carregar mais filmes. Tentar novamente',
                              ),
                            )
                          : !state.hasReachedMax
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refresh() async {
    final bloc = context.read<MovieModernBloc>();
    final done = bloc.stream.firstWhere(
      (s) =>
          s.status == MovieModernStatus.success ||
          s.status == MovieModernStatus.failure,
    );
    bloc.add(const MovieModernRefreshRequested());
    await done;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final bloc = context.read<MovieModernBloc>();
    if (position.extentAfter < 500 &&
        !bloc.state.hasReachedMax &&
        bloc.state.status == MovieModernStatus.success) {
      bloc.add(const MovieModernNowPlayingFetched());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
