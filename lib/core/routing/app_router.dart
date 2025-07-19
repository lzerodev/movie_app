import 'package:flutter/material.dart';
import '../../features/home/presentation/movieapp.dart';
import '../../features/movie/presentation/pages/search_movies.dart';
import '../../features/movie/presentation/pages/now_playing_movies.dart';

/// Sistema de roteamento centralizado da aplicação.
/// 
/// Define todas as rotas disponíveis e gerencia a navegação
/// entre as diferentes telas da aplicação.
class AppRouter {
  // Nomes das rotas
  static const String home = '/';
  static const String search = '/search';
  static const String nowPlaying = '/now-playing';

  /// Gera as rotas da aplicação.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _createRoute(const MovieApp(), settings);
      
      case search:
        return _createRoute(const SearchMoviesPage(), settings);
      
      case nowPlaying:
        return _createRoute(const NowPlayingMoviesPage(), settings);
      
      default:
        return _createErrorRoute('Rota não encontrada: ${settings.name}', settings);
    }
  }

  /// Cria uma rota com animação personalizada.
  static PageRoute<T> _createRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Cria uma rota de erro.
  static PageRoute<dynamic> _createErrorRoute(String message, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extensão para facilitar a navegação.
extension NavigationExtension on BuildContext {
  /// Navega para uma nova tela.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Substitui a tela atual.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Remove todas as telas e navega para uma nova.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  /// Volta para a tela anterior.
  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop<T>(result);
  }

  /// Verifica se pode voltar.
  bool canPop() {
    return Navigator.of(this).canPop();
  }
}
