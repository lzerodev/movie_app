import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_list_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) {
        switch (state.status) {
          case MovieListStatus.failure:
            return const Center(child: Text('Falha ao carregar filmes'));
          case MovieListStatus.sucess:
            if (state.movies.isEmpty) {
              return const Center(child: Text('Sem filmes'));
            }
            return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.movies.length
                    : state.movies.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.movies.length) {
                       return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 250),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ),
                        );
                    } 
                     
                    return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: Material(
                            type: MaterialType.canvas,
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 1.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                              ),
                              child: MovieListItem(movie: state.movies[index])
                            ),
                          ),
                        );
                });
          case MovieListStatus.initial:
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
        }
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
    if (_isBottom) context.read<MovieListBloc>().add(MovieListFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
