import 'package:material_ui/material_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;

import '../../../core/navigation/navigation.dart';
import '../../../core/theme/app_theme.dart';

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
      supportedLocales: const [Locale('pt', 'BR')],

      // === CONFIGURAÇÕES BÁSICAS ===
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      // === SISTEMA DE NAVEGAÇÃO ===
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.namedRoutes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
