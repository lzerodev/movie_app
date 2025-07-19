part of 'movie_modern_bloc.dart';

/// Eventos base para o MovieModernBloc
sealed class MovieModernEvent extends Equatable {
  const MovieModernEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para buscar filmes em cartaz
class MovieModernNowPlayingFetched extends MovieModernEvent {
  const MovieModernNowPlayingFetched();
}

/// Evento para pesquisar filmes
class MovieModernSearchRequested extends MovieModernEvent {
  final String query;

  const MovieModernSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para fazer refresh da lista
class MovieModernRefreshRequested extends MovieModernEvent {
  const MovieModernRefreshRequested();
}
