import 'package:flutter/material.dart';
import 'app_router.dart';
import 'app_routes.dart';
import '../../features/movie/data/models/movie.dart';

/// Extensões para facilitar a navegação
extension NavigationExtensions on BuildContext {
  // === NAVEGAÇÃO BÁSICA ===
  
  /// Navega para uma nova rota
  Future<T?> pushRoute<T extends Object?>(AppRoute<T> route) {
    return AppRouter.push(route);
  }

  /// Substitui a rota atual
  Future<T?> pushReplacementRoute<T extends Object?, TO extends Object?>(
    AppRoute<T> route, {
    TO? result,
  }) {
    return AppRouter.pushReplacement(route, result: result);
  }

  /// Remove a rota atual
  void popRoute<T extends Object?>([T? result]) {
    AppRouter.pop(result);
  }

  /// Verifica se pode voltar
  bool canPopRoute() {
    return AppRouter.canPop();
  }

  // === NAVEGAÇÃO ESPECÍFICA DA APP ===
  
  /// Navega para a tela inicial
  Future<void> goToHome() {
    return AppRouter.pushReplacementNamed(AppRoutes.home);
  }

  /// Navega para filmes em cartaz
  Future<void> goToNowPlayingMovies() {
    return AppRouter.push(AppRoutes.nowPlayingMoviesRoute());
  }

  /// Navega para busca de filmes
  Future<void> goToSearchMovies() {
    return AppRouter.push(AppRoutes.searchMoviesRoute());
  }

  /// Navega para detalhes do filme
  Future<void> goToMovieDetail(Movie movie) {
    return AppRouter.push(AppRoutes.movieDetailRoute(movie));
  }

  /// Navega para detalhes do filme com transição hero
  Future<void> goToMovieDetailWithHero(Movie movie) {
    return Navigator.of(this).push(
      AppRoutes.movieDetailRoute(movie).heroTransitionRoute,
    );
  }

  /// Navega para a demo de navegação
  Future<void> goToNavigationDemo() {
    return AppRouter.push(AppRoutes.navigationDemoRoute());
  }

  // === UTILIDADES ===
  
  /// Mostra bottom sheet modal
  Future<T?> showAppBottomSheet<T>({
    required Widget content,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return AppRouter.showBottomSheet<T>(
      content: content,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
    );
  }

  /// Mostra dialog
  Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return AppRouter.showAppDialog<T>(
      dialog: dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  /// Mostra snackbar simples
  void showMessage(String message) {
    AppRouter.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Mostra snackbar de sucesso
  void showSuccessMessage(String message) {
    AppRouter.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mostra snackbar de erro
  void showErrorMessage(String message) {
    AppRouter.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Extensões para rotas específicas
extension MovieRouteExtensions on Movie {
  /// Cria rota para detalhes deste filme
  MovieDetailRoute get detailRoute => AppRoutes.movieDetailRoute(this);
  
  /// Navega para detalhes deste filme
  Future<void> navigateToDetail(BuildContext context) {
    return context.goToMovieDetail(this);
  }

  /// Navega para detalhes com transição hero
  Future<void> navigateToDetailWithHero(BuildContext context) {
    return context.goToMovieDetailWithHero(this);
  }
}

/// Extensões para facilitação de dialogs
extension DialogExtensions on BuildContext {
  /// Mostra dialog de confirmação
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) {
    return showAppDialog<bool>(
      dialog: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => AppRouter.pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => AppRouter.pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog de informação
  Future<void> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showAppDialog<void>(
      dialog: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => AppRouter.pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog de loading
  Future<T?> showLoadingDialog<T>({
    String message = 'Carregando...',
    required Future<T> future,
  }) async {
    // Mostra o dialog
    showAppDialog<void>(
      dialog: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Executa a operação
      final result = await future;
      
      // Remove o dialog
      AppRouter.pop();
      
      return result;
    } catch (error) {
      // Remove o dialog
      AppRouter.pop();
      
      // Mostra erro
      showErrorMessage('Erro: $error');
      
      rethrow;
    }
  }
}
