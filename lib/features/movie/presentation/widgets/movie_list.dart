import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_modern_bloc.dart';
import 'package:movie_app/features/movie/presentation/widgets/movie_list_item.dart';

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
        return switch (state.status) {
          MovieModernStatus.initial => const Center(
              child: CircularProgressIndicator(color: Colors.black)),
          
          MovieModernStatus.loading when state.movies.isEmpty => const Center(
              child: CircularProgressIndicator(color: Colors.black)),
          
          MovieModernStatus.failure => Center(
              child: Text('Erro: ${state.errorMessage ?? "Erro desconhecido"}')),
          
          MovieModernStatus.success => _buildMovieList(state.movies, state.hasReachedMax),
          
          MovieModernStatus.loading => _buildMovieList(state.movies, false), // Mostra loading no fim da lista
        };
      },
    );
  }

  Widget _buildMovieList(List movies, bool hasReachedMax) {
    if (movies.isEmpty) {
      return const Center(child: Text('Nenhum filme encontrado'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: hasReachedMax ? movies.length : movies.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= movies.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 250),
            child: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
          child: Material(
            type: MaterialType.canvas,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: MovieListItem(movie: movies[index]),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
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
}
