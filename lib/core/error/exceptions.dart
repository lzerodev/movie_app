/// Exceções base da aplicação.
/// 
/// Define todas as exceções personalizadas que podem ocorrer
/// durante a execução da aplicação.

/// Exceção lançada quando há problemas de comunicação com o servidor.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Erro no servidor',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

/// Exceção lançada quando há problemas de cache/armazenamento local.
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Erro de cache',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exceção lançada quando não há conexão com a internet.
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Sem conexão com a internet',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exceção lançada quando os dados de entrada são inválidos.
class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? details;

  const ValidationException({
    this.message = 'Dados inválidos',
    this.details,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exceção lançada quando um recurso não é encontrado.
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({
    this.message = 'Recurso não encontrado',
  });

  @override
  String toString() => 'NotFoundException: $message';
}