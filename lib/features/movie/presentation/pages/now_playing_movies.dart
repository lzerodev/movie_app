import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_list_bloc.dart';
import '../widgets/movie_list.dart';

class NowPlayingMoviesPage extends StatelessWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MovieListBloc(dio: Dio())..add(MovieListFetched()),
        child: const MovieListView()),
    );
  }
}