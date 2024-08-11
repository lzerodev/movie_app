import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/repositories/movie_repository.dart';

class MovieController {
  final MovieRepository _movieRepository;
  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  // Construtor inicializa o MovieRepository com o Dio
  MovieController(Dio dio) : _movieRepository = MovieRepository(dio);

  // Getters para acessar o estado atual dos filmes e carregamento
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  // Função para buscar filmes
  Future<void> fetchMovies() async {
    _setLoading(true);
    try {
      // Busca filmes da página atual
      final movies = await _movieRepository.getNowPlayingMovies(page: _currentPage);
      _movies = movies;
      _hasMore = movies.isNotEmpty; // Verifica se há mais filmes
    } catch (e) {
      // Tratamento de erro, imprime a exceção e ajusta o estado
      debugPrint('Erro ao buscar filmes: $e');
      _movies = []; // Limpa a lista em caso de erro
      _hasMore = false; // Define hasMore como false se ocorrer erro
    } finally {
      _setLoading(false); // Ajusta o estado de carregamento
    }
  }

  // Função para buscar mais filmes
  Future<void> fetchMoreMovies() async {
    // Retorna se não houver mais filmes ou se já estiver carregando
    if (!_hasMore || _isLoading) return;

    _setLoading(true);
    try {
      // Busca mais filmes da próxima página
      final moreMovies = await _movieRepository.getNowPlayingMovies(page: _currentPage + 1);
      if (moreMovies.isEmpty) {
        _hasMore = false; // Se não houver mais filmes, define hasMore como false
      } else {
        _currentPage++; // Atualiza a página atual
        _movies.addAll(moreMovies); // Adiciona os filmes à lista existente
      }
    } catch (e) {
      // Tratamento de erro, imprime a exceção
      debugPrint('Erro ao buscar mais filmes: $e');
      // Não altera _currentPage nem _hasMore para manter o estado consistente
    } finally {
      _setLoading(false); // Ajusta o estado de carregamento
    }
  }

  // Função privada para ajustar o estado de carregamento
  void _setLoading(bool loading) {
    _isLoading = loading;
  }
}
