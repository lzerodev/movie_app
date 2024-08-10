import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import 'const.dart';

class MovieRepository {
  final Dio _dio;

  MovieRepository(this._dio);

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await _dio.get(
      '$host/movie/now_playing',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> results = response.data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

    Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '$host/search/movie',
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['results'] != null) {
          final List results = data['results'];
          return results.map((json) => Movie.fromJson(json)).toList();
        } else {
          return []; // Return an empty list if no results are found
        }
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      return []; // Return an empty list on error
    }
  }
}
