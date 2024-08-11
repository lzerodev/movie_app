import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/movie_controller.dart';
import '../services/scroll_controller.dart';
import '../widgets/movie_list_view.dart';
import '../screens/search_movies.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  State<NowPlayingMoviesPage> createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  late MovieController _movieController;
  late ScrollService _scrollService;

  @override
  void initState() {
    super.initState();
    final Dio dio = Dio();
    _movieController = MovieController(dio);

    // Inicializa o ScrollService e passa o callback de carregamento
    _scrollService = ScrollService(() {
      if (!_movieController.isLoading) {
        _movieController.fetchMoreMovies();
      }
    });

    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    await _movieController.fetchMovies();
    setState(() {}); // Atualiza o estado para refletir as mudanças na UI
  }

  @override
  void dispose() {
    _scrollService.dispose(); // Libera os recursos do ScrollService
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchMoviesPage()),
              );
            },
          ),
        ],
      ),
      body: MovieListView(
        scrollController: _scrollService.scrollController,
        movies: _movieController.movies,
        isLoading: _movieController.isLoading,
        fetchMoreMovies: _movieController.fetchMoreMovies,
      ),
    );
  }
}
