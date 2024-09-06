import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class SearchService {
  final MovieRepository _movieRepository;

  SearchService(Dio dio) : _movieRepository = MovieRepository(dio);

  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _movieRepository.searchMovies(query);
    } catch (e) {
      debugPrint('Erro ao buscar filmes: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }
}
