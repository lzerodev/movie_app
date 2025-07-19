import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/home/widgets/home.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR')],
      title: 'Movies App',
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.theme,
      home: const HomePage(),      
    );
  }
}