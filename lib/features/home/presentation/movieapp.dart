import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/navigation/navigation.dart';
import '../widgets/home.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // === CONFIGURAÇÕES DE LOCALIZAÇÃO ===
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      
      // === CONFIGURAÇÕES BÁSICAS ===
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      
      // === SISTEMA DE NAVEGAÇÃO ===
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.namedRoutes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      
      // Página inicial (fallback)
      home: const HomePage(),
    );
  }
}