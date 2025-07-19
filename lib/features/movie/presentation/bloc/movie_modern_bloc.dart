import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:movie_app/core/error/result.dart';
import '../../data/models/movie.dart';
import '../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../domain/usecases/search_movies_usecase.dart';

part 'movie_modern_event.dart';
part 'movie_modern_state.dart';

/// Duração do throttle para evitar muitas requisições
const throttleDuration = Duration(milliseconds: 100);

/// Tamanho da página para paginação
const int pageSize = 20;

/// Transformer para throttle com drop de eventos duplicados
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

/// BLoC moderno para gerenciamento de lista de filmes.
/// 
/// Utiliza UseCases seguindo Clean Architecture e Result Pattern
/// para tratamento type-safe de erros.
class MovieModernBloc extends Bloc<MovieModernEvent, MovieModernState> {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final SearchMoviesUseCase _searchMoviesUseCase;

  MovieModernBloc({
    required GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase,
    required SearchMoviesUseCase searchMoviesUseCase,
  })  : _getNowPlayingMoviesUseCase = getNowPlayingMoviesUseCase,
        _searchMoviesUseCase = searchMoviesUseCase,
        super(const MovieModernState()) {
    
    // Registra handlers para eventos
    on<MovieModernNowPlayingFetched>(
      _onNowPlayingFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    
    on<MovieModernSearchRequested>(
      _onSearchRequested,
      transformer: throttleDroppable(const Duration(milliseconds: 500)),
    );
    
    on<MovieModernRefreshRequested>(
      _onRefreshRequested,
    );
  }

  /// Handler para buscar filmes em cartaz
  Future<void> _onNowPlayingFetched(
    MovieModernNowPlayingFetched event,
    Emitter<MovieModernState> emit,
  ) async {
    // Evita buscar mais se já chegou ao máximo
    if (state.hasReachedMax) return;

    try {
      // Calcula próxima página baseada na quantidade atual
      final currentPage = (state.movies.length ~/ pageSize) + 1;
      
      // Emite loading apenas se for a primeira página
      if (currentPage == 1) {
        emit(state.copyWith(status: MovieModernStatus.loading));
      }

      // Executa UseCase
      final result = await _getNowPlayingMoviesUseCase(
        GetNowPlayingMoviesParams(page: currentPage),
      );

      // Trata resultado usando pattern matching
      switch (result) {
        case Success(:final data):
          if (data.isEmpty) {
            emit(state.copyWith(hasReachedMax: true));
          } else {
            emit(state.copyWith(
              status: MovieModernStatus.success,
              movies: [...state.movies, ...data],
              hasReachedMax: data.length < pageSize,
            ));
          }
        case Error(:final failure):
          emit(state.copyWith(
            status: MovieModernStatus.failure,
            errorMessage: failure.message,
          ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MovieModernStatus.failure,
        errorMessage: 'Erro inesperado: $e',
      ));
    }
  }

  /// Handler para pesquisar filmes
  Future<void> _onSearchRequested(
    MovieModernSearchRequested event,
    Emitter<MovieModernState> emit,
  ) async {
    // Valida entrada
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(
        status: MovieModernStatus.success,
        movies: [],
        isSearchMode: false,
      ));
      return;
    }

    emit(state.copyWith(
      status: MovieModernStatus.loading,
      isSearchMode: true,
    ));

    // Executa UseCase de busca
    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: event.query, page: 1),
    );

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          status: MovieModernStatus.success,
          movies: data,
          hasReachedMax: data.length < pageSize,
          searchQuery: event.query,
        ));
      case Error(:final failure):
        emit(state.copyWith(
          status: MovieModernStatus.failure,
          errorMessage: failure.message,
          movies: [],
        ));
    }
  }

  /// Handler para refresh da lista
  Future<void> _onRefreshRequested(
    MovieModernRefreshRequested event,
    Emitter<MovieModernState> emit,
  ) async {
    // Reset do estado para buscar novamente
    emit(const MovieModernState());
    add(const MovieModernNowPlayingFetched());
  }
}
