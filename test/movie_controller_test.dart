import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/services/movie_controller.dart';
import 'package:dio/dio.dart';
import 'mocks.mocks.dart';

void main() {
  late MovieController movieController;
  late MockMovieRepository mockMovieRepository;
  late Dio dio;

  // Configuração inicial antes de cada teste
  setUp(() {
    dio = Dio(); // Inicializa o Dio
    mockMovieRepository = MockMovieRepository(); // Cria o mock do MovieRepository
    movieController = MovieController(dio); // Inicializa o MovieController com o Dio

    // Configura o mock para retornar uma lista vazia de filmes por padrão
    when(mockMovieRepository.getNowPlayingMovies(page: anyNamed('page')))
        .thenAnswer((_) async => []);
  });

  test('estado inicial está correto', () {
    // Verifica o estado inicial do MovieController
    expect(movieController.movies, isEmpty); // Inicialmente, não há filmes
    expect(movieController.isLoading, isFalse); // Inicialmente, não está carregando
    expect(movieController.hasMore, isTrue); // Inicialmente, há mais filmes para carregar
  });

  test('fetchMovies atualiza o estado corretamente', () async {
    // Configura o mock para retornar uma lista de filmes quando fetchMovies é chamado
    final List<Movie> mockMovies = [
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: '/path/to/poster',
        releaseDate: '2010-07-16',
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
        backdropPath: '/path/to/backdrop',
      )
    ];
    when(mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => mockMovies);

    // Atualiza o MovieController para usar o mock repository
    movieController = MovieController(dio); // Inicializa novamente para usar o mock
    // Executa o método fetchMovies
    await movieController.fetchMovies();

    // Verifica se o estado foi atualizado corretamente
    expect(movieController.movies, mockMovies); // A lista de filmes deve ser a retornada pelo mock
    expect(movieController.hasMore, isTrue); // Ainda há mais filmes (simulado pelo mock)
  });

  test('fetchMoreMovies atualiza o estado corretamente quando há mais filmes', () async {
    // Configura o mock para retornar uma lista de filmes para as páginas 1 e 2
    final List<Movie> mockMovies = [
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: '/path/to/poster',
        releaseDate: '2010-07-16',
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
        backdropPath: '/path/to/backdrop',
      )
    ];
    when(mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => mockMovies);
    when(mockMovieRepository.getNowPlayingMovies(page: 2))
        .thenAnswer((_) async => mockMovies);

    // Atualiza o MovieController para usar o mock repository
    movieController = MovieController(dio); // Inicializa novamente para usar o mock
    // Executa os métodos fetchMovies e fetchMoreMovies
    await movieController.fetchMovies();
    await movieController.fetchMoreMovies();

    // Verifica se o estado foi atualizado corretamente
    expect(movieController.movies.length, 2); // Agora devem haver dois filmes (o inicial e o carregado)
    expect(movieController.hasMore, isTrue); // Ainda há mais filmes (simulado pelo mock)
  });

  test('fetchMoreMovies define hasMore como false quando não há mais filmes disponíveis', () async {
    // Configura o mock para retornar um filme para a página 1 e nenhum filme para a página 2
    final List<Movie> mockMovies = [
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: '/path/to/poster',
        releaseDate: '2010-07-16',
        overview: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
        voteAverage: 8.8,
        backdropPath: '/path/to/backdrop',
      )
    ];
    when(mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenAnswer((_) async => mockMovies);
    when(mockMovieRepository.getNowPlayingMovies(page: 2))
        .thenAnswer((_) async => []); // Nenhum filme disponível para a página 2

    // Atualiza o MovieController para usar o mock repository
    movieController = MovieController(dio); // Inicializa novamente para usar o mock
    // Executa os métodos fetchMovies e fetchMoreMovies
    await movieController.fetchMovies();
    await movieController.fetchMoreMovies();

    // Verifica se o estado foi atualizado corretamente
    expect(movieController.movies.length, 1); // Apenas o filme inicial deve estar presente
    expect(movieController.hasMore, isFalse); // Não há mais filmes disponíveis
  });

  test('fetchMovies lida com erros corretamente', () async {
    // Configura o mock para lançar uma exceção quando fetchMovies for chamado
    when(mockMovieRepository.getNowPlayingMovies(page: 1))
        .thenThrow(Exception('Falha ao buscar filmes'));

    // Atualiza o MovieController para usar o mock repository
    movieController = MovieController(dio); // Inicializa novamente para usar o mock
    // Executa o método fetchMovies
    await movieController.fetchMovies();

    // Verifica se o estado foi atualizado corretamente após um erro
    expect(movieController.movies, isEmpty); // A lista de filmes deve permanecer vazia
    expect(movieController.isLoading, isFalse); // O estado de carregamento deve ser definido como false
  });
}
