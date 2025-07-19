import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di_extensions.dart';
import '../bloc/movie_modern_bloc.dart';
import '../widgets/back_button.dart';
import '../widgets/search_bar.dart';
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
  // ignore: library_private_types_in_public_api
  _SearchMoviesViewState createState() => _SearchMoviesViewState();
}

class _SearchMoviesViewState extends State<_SearchMoviesView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Adiciona listener para busca automática com debounce
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
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Search Movies'),
        backgroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _searchMovies,
          ),
        ],
      ),
      body: Column(
        children: [
          MySearchBar(
            controller: _searchController,
            onSubmitted: _searchMovies,
          ),
          Expanded(
            child: BlocBuilder<MovieModernBloc, MovieModernState>(
              builder: (context, state) {
                if (!state.isSearchMode) {
                  return const _EmptySearchState();
                }

                return switch (state.status) {
                  MovieModernStatus.loading when state.movies.isEmpty => 
                    const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  
                  MovieModernStatus.failure => 
                    _SearchErrorState(
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 24),
          Text(
            'Pesquisar Filmes',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Digite o nome de um filme na barra de pesquisa acima',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'A pesquisa é feita automaticamente enquanto você digita',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Erro ao buscar filmes',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

// Estado quando não há resultados
class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum filme encontrado',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tente pesquisar com outras palavras-chave',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
