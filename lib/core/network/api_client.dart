import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_constants.dart';
import '../utils/secrets.dart';

/// Cliente HTTP centralizado para toda a aplicação.
/// 
/// Fornece uma instância configurada do Dio com interceptors,
/// configurações de timeout e tratamento de erros padronizado.
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  /// Construtor que aceita uma instância do Dio.
  ApiClient(Dio dio) {
    _dio = dio;
    _configureDio();
  }

  /// Factory constructor para Singleton.
  factory ApiClient.getInstance() {
    _instance ??= ApiClient(Dio());
    return _instance!;
  }

  /// Configura o Dio com interceptors e configurações base.
  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _setupInterceptors();
  }

  /// Retorna a instância singleton do ApiClient.
  static ApiClient get instance {
    _instance ??= ApiClient(Dio());
    return _instance!;
  }

  /// Getter para acessar a instância do Dio.
  Dio get dio => _dio;

  /// Configura os interceptors para logging e tratamento de erros.
  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }

    // Interceptor para adicionar API key automaticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = AppSecrets.tmdbApiKey;
          options.queryParameters['language'] = 'pt-BR';
          handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  /// Método GET genérico.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Método POST genérico.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Método PUT genérico.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Método DELETE genérico.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
