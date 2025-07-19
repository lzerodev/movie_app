import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:movie_app/features/home/presentation/movieapp.dart';

import 'core/utils/secure_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/utils/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializa as configurações seguras (API keys, etc.)
    await SecureConfig.initialize();
    debugPrint('✅ Configurações seguras inicializadas com sucesso');
    
    // Inicializa o sistema de Dependency Injection
    await DependencyInjection.setup();
    debugPrint('✅ Dependency Injection inicializado com sucesso');
    
    // Configura o observer do BLoC
    Bloc.observer = const SimpleBlocObserver();
    
    // Inicializa formatação de data em português
    await initializeDateFormatting('pt_BR', null);
    
    runApp(const MovieApp());
  } catch (e, stackTrace) {
    debugPrint('❌ Erro crítico na inicialização: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Em caso de erro, ainda executa o app mas com configuração mínima
    Bloc.observer = const SimpleBlocObserver();
    runApp(const MovieApp());
  }
}