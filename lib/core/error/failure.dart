import 'package:equatable/equatable.dart';

/// Classe base para todos os falhas da aplicação.
/// 
/// Representa erros que podem ocorrer em qualquer camada da aplicação
/// e que devem ser tratados pela UI.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Falha relacionada a problemas de servidor/API.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Falha relacionada a problemas de cache/armazenamento local.
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Falha relacionada a problemas de conexão de rede.
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Falha relacionada a dados de entrada inválidos.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? details;

  const ValidationFailure({
    required super.message,
    super.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

/// Falha quando um recurso não é encontrado.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}