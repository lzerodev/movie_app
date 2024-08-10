import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/movie_model.dart';
import '../data/repositories/movie_repository.dart';
import '../widgets/movie_list_view.dart';
import 'search_movies.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  State<NowPlayingMoviesPage> createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  late MovieRepository _movieRepository;
  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final Dio dio = Dio();
    _movieRepository = MovieRepository(dio);
    _fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _fetchMoreMovies();
      }
    });
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _movieRepository.getNowPlayingMovies(page: _currentPage);
      setState(() {
        _movies = movies;
        _hasMore = movies.isNotEmpty;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreMovies() async {
    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final moreMovies = await _movieRepository.getNowPlayingMovies(page: _currentPage + 1);
      setState(() {
        if (moreMovies.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage++;
          _movies.addAll(moreMovies);
        }
      });
    } catch (e) {
      debugPrint("Error fetching more movies");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          fontWeight: FontWeight.bold
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchMoviesPage()),
              );
            },
          ),
        ],
      ),
      body: MovieListView(
        scrollController: _scrollController,
        movies: _movies,
        isLoading: _isLoading,
        fetchMoreMovies: _fetchMoreMovies,
      ),
    );
  }
}
