import 'failure.dart';

/// Representa o resultado de uma operação que pode falhar.
/// 
/// Encapsula tanto o sucesso quanto o erro de uma operação,
/// forçando o tratamento explícito de erros.
sealed class Result<T> {
  const Result();

  /// Retorna `true` se o resultado é um sucesso.
  bool get isSuccess => this is Success<T>;

  /// Retorna `true` se o resultado é um erro.
  bool get isFailure => this is Error<T>;

  /// Obtém o valor do resultado ou lança uma exceção se for um erro.
  T get value {
    return switch (this) {
      Success<T>(:final data) => data,
      Error<T>(:final failure) => throw Exception('Result is an error: $failure'),
    };
  }

  /// Obtém o erro do resultado ou lança uma exceção se for um sucesso.
  Failure get error {
    return switch (this) {
      Success<T>() => throw Exception('Result is a success, not an error'),
      Error<T>(:final failure) => failure,
    };
  }

  /// Aplica uma função ao valor se for um sucesso, senão retorna o erro.
  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      Error<T>(:final failure) => Error(failure),
    };
  }

  /// Aplica uma função que retorna um Result ao valor se for um sucesso.
  Result<R> flatMap<R>(Result<R> Function(T) transform) {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      Error<T>(:final failure) => Error(failure),
    };
  }

  /// Executa uma função se for um sucesso, senão executa outra função.
  R fold<R>(
    R Function(Failure) onError,
    R Function(T) onSuccess,
  ) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Error<T>(:final failure) => onError(failure),
    };
  }
}

/// Representa um resultado de sucesso.
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Representa um resultado de erro.
class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  String toString() => 'Error($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
