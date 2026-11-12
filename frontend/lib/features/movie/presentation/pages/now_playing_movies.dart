import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di_extensions.dart';
import '../bloc/movie_modern_bloc.dart';
import '../widgets/movie_list.dart';

class NowPlayingMoviesPage extends StatelessWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MovieModernBloc>(
        create: context.createMovieModernBloc,
        child: const MovieListView(),
      ),
    );
  }
}