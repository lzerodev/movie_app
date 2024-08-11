import 'package:mockito/annotations.dart';
import 'package:movie_app/data/repositories/movie_repository.dart';
import 'package:dio/dio.dart';

// O pacote mockito é usado para criar objetos simulados (mocks) para testes.
// O annotation @GenerateMocks é usada para gerar automaticamente os mocks
// para as classes listadas dentro dos colchetes.

@GenerateMocks([Dio, MovieRepository])
void main() {
  // Este arquivo não possui testes ou lógica de teste definida aqui.
  // O propósito deste arquivo é gerar os mocks necessários para uso em testes.
}
