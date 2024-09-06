import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:movie_app/features/movie/data/repositories/movie_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/models/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);
const int pageSize = 20;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {

  MovieListBloc({required this.dio}) : super(const MovieListState()) {

   on<MovieListFetched>(
    _onMovieListFetched,
    transformer: throttleDroppable(throttleDuration),
    );
  }

  final Dio dio;

  Future<void> _onMovieListFetched(
    MovieListFetched event, 
    Emitter<MovieListState> emit,
    ) async {
    MovieRepository controller = MovieRepository(dio);

    if (state.hasReachedMax) return;
    
    try {
      final page = (state.movies.length ~/ pageSize) + 1;
      // const page = 1 ;

      final movies = await controller.getNowPlayingMovies(startIndex: page) ;

      if (movies.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(
        state.copyWith(
          status: MovieListStatus.sucess,
          movies: [...state.movies,...movies],
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: MovieListStatus.failure));
    }
  }  
 }

