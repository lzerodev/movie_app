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

  // Função privada para ajustar o estado de carregamento
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  // Função para buscar filmes
  Future<void> fetchMovies() async {
    if (_isLoading) return; // Verifica se já está carregando para evitar chamadas duplicadas
    _setLoading(true); // Define o estado de carregamento como verdadeiro
    try {
      // Busca filmes da página atual
      final movies = await _movieRepository.getNowPlayingMovies(page: _currentPage);
      if (movies.isNotEmpty) {
        if (_currentPage == 1) {
          _movies = movies;
          debugPrint('Substitui a lista de filmes'); // Substitui a lista de filmes se for a primeira página
        } else {
          _movies.addAll(movies);
          debugPrint('Adicionando mais filmes a lista'); // Adiciona os filmes à lista existente
        }
        _hasMore = true; 
        debugPrint('_hasMore é verdadeiro');// Há mais filmes para carregar
      } else {
        _hasMore = false; // Não há mais filmes para carregar
      }
    } catch (e) {
      // Tratamento de erro: imprime a exceção e ajusta o estado
      debugPrint('Erro ao buscar filmes: $e');
      _hasMore = false; // Define hasMore como false se ocorrer um erro
    } finally {
      _setLoading(false); // Define o estado de carregamento como falso
    }
  }

  // Função para buscar mais filmes
  Future<void> fetchMoreMovies() async {
    // Retorna se não houver mais filmes ou se já estiver carregando
    if (!_hasMore || _isLoading) return;

    _setLoading(true); // Define o estado de carregamento como verdadeiro
    try {
      // Busca mais filmes da próxima página
      final moreMovies = await _movieRepository.getNowPlayingMovies(page: _currentPage + 1);
      if (moreMovies.isNotEmpty) {
        _currentPage++; // Incrementa _currentPage após sucesso na requisição
        _movies.addAll(moreMovies);
        debugPrint('Adiciona filmes a lista existente'); // Adiciona os filmes à lista existente
      } else {
        _hasMore = false; // Define hasMore como false se não houver mais filmes
      }
    } catch (e) {
      // Tratamento de erro: imprime a exceção
      debugPrint('Erro ao buscar mais filmes: $e');
      // Não altera _currentPage nem _hasMore para manter o estado consistente
    } finally {
      _setLoading(false); // Define o estado de carregamento como falso
    }
  }
}
