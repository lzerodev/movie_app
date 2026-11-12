import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'secrets.dart';

/// Classe responsável por gerenciar configurações sensíveis da aplicação
/// como API keys e outros dados que não devem ser expostos no código.
class SecureConfig {
  static String? _tmdbApiKey;
  
  /// Inicializa as configurações seguras.
  /// Deve ser chamado no início da aplicação.
  static Future<void> initialize() async {
    try {
      // Tenta carregar do arquivo .env primeiro (desenvolvimento)
      await dotenv.load(fileName: ".env");
      _tmdbApiKey = dotenv.env['TMDB_API_KEY'];
      
      if (kDebugMode) {
        debugPrint('✅ API key carregada do arquivo .env');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️  Arquivo .env não encontrado, usando configuração fallback');
      }
      
      // Fallback para o arquivo secrets.dart
      _tmdbApiKey = AppSecrets.tmdbApiKey;
    }
    
    if (_tmdbApiKey == null || _tmdbApiKey!.isEmpty) {
      throw Exception(
        'API Key do TMDB não configurada. '
        'Configure o arquivo .env ou secrets.dart'
      );
    }
  }
  
  /// Retorna a API key do TMDB de forma segura
  static String get tmdbApiKey {
    if (_tmdbApiKey == null) {
      throw Exception(
        'SecureConfig não foi inicializado. '
        'Chame SecureConfig.initialize() primeiro.'
      );
    }
    return _tmdbApiKey!;
  }
  
  /// Verifica se as configurações foram inicializadas
  static bool get isInitialized => _tmdbApiKey != null;
}
