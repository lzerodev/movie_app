import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/movie.dart';
import '../../domain/usecases/search_controller.dart';
import '../bloc/movie_list_bloc.dart';
import '../widgets/back_button.dart';
import '../widgets/movie_list.dart';
import '../widgets/search_bar.dart';

class SearchMoviesPage extends StatefulWidget {
  const SearchMoviesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchMoviesPageState createState() => _SearchMoviesPageState();
}

class _SearchMoviesPageState extends State<SearchMoviesPage> {
  late SearchService _searchService;
  Future<List<Movie>>? _searchResultsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final Dio dio = Dio();
    _searchService = SearchService(dio);
  }

  void _searchMovies() {
    setState(() {
      _searchResultsFuture = _searchService.searchMovies(_searchController.text);
    });
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
      body: 
      BlocProvider(
        create: (context) => MovieListBloc(dio: Dio())..add(MovieListFetched()),
        child: Column(
        children: [
          MySearchBar(
            controller: _searchController,
            onSubmitted: _searchMovies,
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _searchResultsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.black,));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                } else {
                  // ignore: unused_local_variable
                  final movies = snapshot.data!;
                  return const MovieListView(
                  );
                }
              },
            ),
          ),
        ],
      ),
    )
  );}
}
