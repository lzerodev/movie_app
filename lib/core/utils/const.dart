import 'secure_config.dart';

// Configurações da API do The Movie Database (TMDB)
const String host = 'https://api.themoviedb.org/3';

// ⚠️ SEGURANÇA: API Key agora é carregada de forma segura
// Use SecureConfig.tmdbApiKey em vez de uma constante hardcoded
String get apiKey => SecureConfig.tmdbApiKey;

// URLs para imagens
const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w1280';

// Configurações padrão
const String defaultLanguage = 'pt-BR';
const int defaultPageSize = 20;
