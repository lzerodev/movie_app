import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../utils/secure_config.dart';
import '../../features/movie/presentation/bloc/movie_list_bloc.dart';

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

    _isInitialized = true;
  }

  /// Resolve uma dependência.
  static T get<T extends Object>() {
    if (!_isInitialized) {
      throw StateError('DependencyInjection não foi inicializado. Chame setup() primeiro.');
    }

    final instance = _instances[T];
    if (instance == null) {
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

  /// Factory methods para criação de objetos que precisam de dependências
  static MovieListBloc createMovieListBloc() {
    return MovieListBloc(dio: get<Dio>());
  }
}

/// Extensão para facilitar o acesso às dependências.
extension DependencyInjectionExtension on Object {
  /// Resolve uma dependência usando sintaxe mais limpa.
  T resolve<T extends Object>() => DependencyInjection.get<T>();
}
