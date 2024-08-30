import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'const.dart';

class MovieRepository {
  final Dio _dio;

  MovieRepository(this._dio);

  /// Obtém uma lista de filmes em exibição nos cinemas a partir da API.
  ///
  /// [page] é o número da página a ser buscada.
  /// Retorna uma [List<Movie>] de filmes.
  /// Lança uma [Exception] se a requisição falhar.
  ///
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final data = await _getRequest(
        '/movie/now_playing',
        queryParameters: {'api_key': apiKey, 'page': page, 'language': 'pt-BR'},
      );
      List<dynamic> results = data['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar filmes em exibição: $e');
      rethrow; // Relança a exceção para ser tratada pelo chamador
    }
  }

  /// Pesquisa filmes na API com base na consulta fornecida.
  ///
  /// [query] é o termo de pesquisa.
  /// [page] é o número da página a ser buscada.
  /// Retorna uma [List<Movie>] de filmes.
  /// Retorna uma lista vazia em caso de erro ou se nenhum resultado for encontrado.
  ///
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final data = await _getRequest(
        '/search/movie',
        queryParameters: {'api_key': apiKey, 'query': query, 'page': page},
      );
      List<dynamic> results = data['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erro ao pesquisar filmes: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  /// Faz uma requisição GET para o endpoint especificado.
  ///
  /// [endpoint] é o caminho da URL da API.
  /// [queryParameters] são os parâmetros da consulta.
  /// Retorna um [Map<String, dynamic>] com os dados da resposta.
  /// Lança uma [Exception] se a requisição falhar.
  ///
  Future<Map<String, dynamic>> _getRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        '$host$endpoint',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Falha ao buscar dados: código de status ${response.statusCode} para o endpoint $endpoint');
      }
    } catch (e) {
      debugPrint('Erro ao fazer requisição: $e');
      rethrow; // Relança a exceção para ser tratada pelo chamador
    }
  }
}
