import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:movie_app/features/home/presentation/movieapp.dart';

import 'core/utils/secure_config.dart';
import 'features/movie/domain/entities/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa as configurações seguras (API keys, etc.)
  try {
    await SecureConfig.initialize();
    debugPrint('✅ Configurações seguras inicializadas com sucesso');
  } catch (e) {
    debugPrint('❌ Erro ao inicializar configurações seguras: $e');
    // Em produção, você pode querer mostrar uma tela de erro
    // ou usar uma API key padrão (não recomendado)
  }
  
  Bloc.observer = const SimpleBlocObserver();
  await initializeDateFormatting('pt_BR', null); 
  runApp(const MovieApp());
}