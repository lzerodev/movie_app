import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../utils/secure_config.dart';
import '../../features/movie/presentation/bloc/movie_modern_bloc.dart';
import '../../features/movie/data/repositories/movie_repository_adapter.dart';
import '../../features/movie/domain/repositories/i_movie_repository.dart';
import '../../features/movie/domain/usecases/search_movies_usecase.dart';
import '../../features/movie/domain/usecases/get_now_playing_movies_usecase.dart';

/// Configuração central de injeção de dependências.
/// 
/// Sistema simples de DI para gerenciar as principais
/// dependências da aplicação.
class DependencyInjection {
  static final Map<Type, Object> _instances = {};
  static bool _isInitialized = false;

  /// Inicializa todas as dependências da aplicação.
  static Future<void> setup() async {
    if (_isInitialized) return;

    // Core - Configurações
    _instances[SecureConfig] = SecureConfig();

    // Core - Network
    final dio = Dio();
    _instances[Dio] = dio;
    _instances[ApiClient] = ApiClient(dio);

    // Movie - Data Layer
    final movieRepository = MovieRepositoryAdapter(dio);
    _instances[IMovieRepository] = movieRepository;

    // Movie - Domain Layer (UseCases)
    _instances[SearchMoviesUseCase] = SearchMoviesUseCase(movieRepository);
    _instances[GetNowPlayingMoviesUseCase] = GetNowPlayingMoviesUseCase(movieRepository);

    _isInitialized = true;
  }

  /// Resolve uma dependência.
  static T get<T extends Object>() {
    if (!_isInitialized) {
      print('❌ DependencyInjection não foi inicializado. Dependências registradas: ${_instances.keys}');
      throw StateError('DependencyInjection não foi inicializado. Chame setup() primeiro.');
    }

    final instance = _instances[T];
    if (instance == null) {
      print('❌ Dependência de tipo $T não foi registrada. Dependências disponíveis: ${_instances.keys}');
      throw StateError('Dependência de tipo $T não foi registrada.');
    }

    return instance as T;
  }

  /// Registra uma nova dependência.
  static void register<T extends Object>(T instance) {
    _instances[T] = instance;
  }

  /// Verifica se uma dependência está registrada.
  static bool isRegistered<T extends Object>() => _instances.containsKey(T);

  /// Remove todas as dependências (usado principalmente em testes).
  static void reset() {
    _instances.clear();
    _isInitialized = false;
  }

  /// Factory method para o BLoC moderno com UseCases
  static MovieModernBloc createMovieModernBloc() {
    try {
      final searchUseCase = get<SearchMoviesUseCase>();
      final nowPlayingUseCase = get<GetNowPlayingMoviesUseCase>();
      
      return MovieModernBloc(
        searchMoviesUseCase: searchUseCase,
        getNowPlayingMoviesUseCase: nowPlayingUseCase,
      );
    } catch (e, stackTrace) {
      print('❌ Erro ao criar MovieModernBloc: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

/// Extensão para facilitar o acesso às dependências.
extension DependencyInjectionExtension on Object {
  /// Resolve uma dependência usando sintaxe mais limpa.
  T resolve<T extends Object>() => DependencyInjection.get<T>();
}
