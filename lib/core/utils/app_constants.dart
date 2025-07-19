/// Constantes globais da aplicação.
/// 
/// Centraliza todas as constantes usadas em toda a aplicação,
/// incluindo URLs, chaves, configurações e valores padrão.
class AppConstants {
  // URLs e Endpoints
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  
  // Tamanhos de imagem do TMDB
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String profileSize = 'w185';
  
  // Endpoints específicos
  static const String nowPlayingEndpoint = '/movie/now_playing';
  static const String searchMovieEndpoint = '/search/movie';
  static const String movieDetailsEndpoint = '/movie';
  
  // Configurações de API
  static const int defaultPage = 1;
  static const int itemsPerPage = 20;
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String serverErrorMessage = 'Erro no servidor. Tente novamente mais tarde.';
  static const String unknownErrorMessage = 'Erro desconhecido. Tente novamente.';
  static const String noResultsMessage = 'Nenhum resultado encontrado.';
  static const String searchHintMessage = 'Digite o nome do filme...';
  
  // Success Messages
  static const String dataLoadedMessage = 'Dados carregados com sucesso!';
  
  // Asset Paths
  static const String iconsPath = 'assets/icons';
  static const String fontsPath = 'fonts';
  
  // Font Families
  static const String primaryFontFamily = 'Poppins';
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(minutes: 30);
  static const int maxCacheSize = 100; // MB
  
  // Validation
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
}

/// Helper para construir URLs de imagens do TMDB.
class ImageUrlBuilder {
  /// Constrói URL completa para poster de filme.
  static String buildPosterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '${AppConstants.tmdbImageBaseUrl}/${AppConstants.posterSize}$path';
  }
  
  /// Constrói URL completa para backdrop de filme.
  static String buildBackdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '${AppConstants.tmdbImageBaseUrl}/${AppConstants.backdropSize}$path';
  }
  
  /// Constrói URL completa para foto de perfil.
  static String buildProfileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '${AppConstants.tmdbImageBaseUrl}/${AppConstants.profileSize}$path';
  }
}

/// Helper para construir URLs de endpoints da API.
class ApiUrlBuilder {
  /// Constrói URL para buscar filmes em cartaz.
  static String buildNowPlayingUrl({int page = AppConstants.defaultPage}) {
    return '${AppConstants.nowPlayingEndpoint}?page=$page';
  }
  
  /// Constrói URL para buscar filmes por query.
  static String buildSearchUrl(String query, {int page = AppConstants.defaultPage}) {
    return '${AppConstants.searchMovieEndpoint}?query=${Uri.encodeComponent(query)}&page=$page';
  }
  
  /// Constrói URL para detalhes de um filme específico.
  static String buildMovieDetailsUrl(int movieId) {
    return '${AppConstants.movieDetailsEndpoint}/$movieId';
  }
}

/// Enum para diferentes tipos de erro da aplicação.
enum AppErrorType {
  network,
  server,
  validation,
  unknown,
  noResults,
}

/// Extensão para converter enum de erro em mensagem.
extension AppErrorTypeExtension on AppErrorType {
  String get message {
    switch (this) {
      case AppErrorType.network:
        return AppConstants.networkErrorMessage;
      case AppErrorType.server:
        return AppConstants.serverErrorMessage;
      case AppErrorType.validation:
        return 'Dados inválidos fornecidos.';
      case AppErrorType.noResults:
        return AppConstants.noResultsMessage;
      case AppErrorType.unknown:
      default:
        return AppConstants.unknownErrorMessage;
    }
  }
}
