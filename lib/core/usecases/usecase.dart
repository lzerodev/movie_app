/// Interface base para todos os casos de uso da aplicação.
/// 
/// Esta classe abstrata define o contrato que todos os casos de uso
/// devem seguir, promovendo consistência e testabilidade.
/// 
/// Tipos genéricos:
/// - [Type]: O tipo de retorno do caso de uso
/// - [Params]: O tipo dos parâmetros de entrada
abstract class UseCase<Type, Params> {
  /// Executa o caso de uso com os parâmetros fornecidos.
  /// 
  /// Retorna um [Future] do tipo especificado.
  /// Pode lançar exceções específicas do domínio.
  Future<Type> call(Params params);
}

/// Caso de uso que não requer parâmetros.
/// 
/// Use esta classe quando o caso de uso não precisa de parâmetros de entrada.
abstract class NoParamsUseCase<Type> {
  /// Executa o caso de uso sem parâmetros.
  Future<Type> call();
}

/// Parâmetros vazios para casos de uso que não precisam de entrada.
class NoParams {
  const NoParams();
}
