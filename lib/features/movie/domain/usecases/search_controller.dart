import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class SearchService {
  final MovieRepository _movieRepository;

  SearchService(Dio dio) : _movieRepository = MovieRepository(dio);

  /// Pesquisa filmes com base na consulta fornecida.
  ///
  /// [query] é o termo de pesquisa.
  /// Retorna uma [List<Movie>] de filmes ou uma lista vazia em caso de erro.
  /// Implementa validação de entrada e tratamento de erros robusto.
  Future<List<Movie>> searchMovies(String query) async {
    // Validação de entrada
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      debugPrint('Query de pesquisa vazia');
      return [];
    }

    if (trimmedQuery.length < 2) {
      debugPrint('Query muito curta: $trimmedQuery');
      return [];
    }

    try {
      debugPrint('Pesquisando filmes com query: $trimmedQuery');
      final movies = await _movieRepository.searchMovies(trimmedQuery);
      debugPrint('Encontrados ${movies.length} filmes');
      return movies;
    } on DioException catch (e) {
      debugPrint('Erro de rede ao buscar filmes: ${e.message}');
      if (e.response?.statusCode == 404) {
        debugPrint('Endpoint não encontrado');
      } else if (e.response?.statusCode == 401) {
        debugPrint('Erro de autenticação - verifique a API key');
      } else if (e.response?.statusCode == 429) {
        debugPrint('Muitas requisições - rate limit atingido');
      }
      return [];
    } catch (e) {
      debugPrint('Erro inesperado ao buscar filmes: $e');
      return [];
    }
  }
}
