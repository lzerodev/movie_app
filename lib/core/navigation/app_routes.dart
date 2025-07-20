import 'package:flutter/material.dart';
import '../navigation/app_router.dart';
import '../../features/movie/data/models/movie.dart';
import '../../features/movie/presentation/pages/movie_detail.dart';
import '../../features/movie/presentation/pages/now_playing_movies.dart';
import '../../features/movie/presentation/pages/search_movies.dart';
import '../../features/movie/presentation/pages/navigation_demo.dart';
import '../../features/home/widgets/home.dart';

/// Definições de todas as rotas da aplicação
class AppRoutes {
  // Nomes das rotas
  static const String home = '/';
  static const String nowPlayingMovies = '/movies/now-playing';
  static const String searchMovies = '/movies/search';
  static const String movieDetail = '/movies/detail';
  static const String navigationDemo = '/navigation-demo';

  // === ROTAS PRINCIPAIS ===

  /// Rota para a tela inicial
  static HomeRoute homeRoute() => HomeRoute();
  
  /// Rota para filmes em cartaz
  static NowPlayingMoviesRoute nowPlayingMoviesRoute() => NowPlayingMoviesRoute();
  
  /// Rota para busca de filmes
  static SearchMoviesRoute searchMoviesRoute() => SearchMoviesRoute();
  
  /// Rota para detalhes do filme
  static MovieDetailRoute movieDetailRoute(Movie movie) => MovieDetailRoute(movie);

  /// Rota para demo de navegação
  static NavigationDemoRoute navigationDemoRoute() => NavigationDemoRoute();

  // === MAPA DE ROTAS NOMEADAS ===
  
  static Map<String, WidgetBuilder> get namedRoutes => {
    home: (context) => const HomePage(),
    nowPlayingMovies: (context) => const NowPlayingMoviesPage(),
    searchMovies: (context) => const SearchMoviesPage(),
    navigationDemo: (context) => const NavigationDemoPage(),
    // movieDetail precisa de parâmetros, então não incluímos aqui
  };

  /// Gerador de rotas para rotas dinâmicas
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case movieDetail:
        if (settings.arguments is Movie) {
          return movieDetailRoute(settings.arguments as Movie).materialPageRoute;
        }
        return _errorRoute('Movie parameter required for movie detail route');
      
      default:
        return _errorRoute('Route ${settings.name} not found');
    }
  }

  /// Rota de erro
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erro de Navegação',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => AppRouter.pushReplacementNamed(home),
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rota da tela inicial
class HomeRoute extends AppRoute<void> {
  @override
  String get name => AppRoutes.home;
  
  @override
  String get path => '/';
  
  @override
  Widget get page => const HomePage();
  
  @override
  AppRouteConfig get config => AppRouteConfig.fast;
}

/// Rota para filmes em cartaz
class NowPlayingMoviesRoute extends AppRoute<void> {
  @override
  String get name => AppRoutes.nowPlayingMovies;
  
  @override
  String get path => '/movies/now-playing';
  
  @override
  Widget get page => const NowPlayingMoviesPage();
  
  @override
  AppRouteConfig get config => const AppRouteConfig();
}

/// Rota para busca de filmes
class SearchMoviesRoute extends AppRoute<void> {
  @override
  String get name => AppRoutes.searchMovies;
  
  @override
  String get path => '/movies/search';
  
  @override
  Widget get page => const SearchMoviesPage();
  
  @override
  AppRouteConfig get config => const AppRouteConfig();
}

/// Rota para detalhes do filme
class MovieDetailRoute extends AppRoute<void> {
  final Movie movie;

  MovieDetailRoute(this.movie);

  @override
  String get name => AppRoutes.movieDetail;
  
  @override
  String get path => '/movies/detail/${movie.id}';
  
  @override
  Widget get page => MovieDetailPage(movie: movie);
  
  @override
  AppRouteConfig get config => const AppRouteConfig(
    transitionDuration: Duration(milliseconds: 400),
    reverseTransitionDuration: Duration(milliseconds: 300),
  );

  /// Cria transição customizada para detalhes do filme
  PageRouteBuilder<void> get heroTransitionRoute {
    return customPageRoute(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Transição hero customizada
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
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

/// Rota para demo de navegação
class NavigationDemoRoute extends AppRoute<void> {
  @override
  String get name => AppRoutes.navigationDemo;
  
  @override
  String get path => '/navigation-demo';
  
  @override
  Widget get page => const NavigationDemoPage();
  
  @override
  AppRouteConfig get config => const AppRouteConfig(
    transitionDuration: Duration(milliseconds: 350),
  );
}
