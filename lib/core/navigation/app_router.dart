import 'package:flutter/material.dart';

/// Sistema de navegação type-safe para a aplicação.
/// 
/// Centraliza todas as rotas e fornece navegação type-safe
/// com parâmetros tipados e transições customizáveis.
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Contexto do navigator atual
  static BuildContext? get currentContext => navigatorKey.currentContext;
  
  /// State do navigator atual
  static NavigatorState? get currentState => navigatorKey.currentState;

  // === NAVEGAÇÃO BÁSICA ===
  
  /// Navega para uma nova rota
  static Future<T?> push<T extends Object?>(AppRoute<T> route) {
    return currentState!.push(route.materialPageRoute);
  }

  /// Substitui a rota atual
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    AppRoute<T> route, {
    TO? result,
  }) {
    return currentState!.pushReplacement(route.materialPageRoute, result: result);
  }

  /// Navega e remove todas as rotas anteriores
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    AppRoute<T> route, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return currentState!.pushAndRemoveUntil(
      route.materialPageRoute,
      predicate ?? (route) => false,
    );
  }

  /// Remove a rota atual da pilha
  static void pop<T extends Object?>([T? result]) {
    return currentState!.pop(result);
  }

  /// Remove rotas até encontrar uma condição
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return currentState!.popUntil(predicate);
  }

  /// Verifica se pode voltar
  static bool canPop() {
    return currentState!.canPop();
  }

  // === NAVEGAÇÃO COM NOME ===

  /// Navega usando nome da rota
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Substitui usando nome da rota
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // === UTILITÁRIOS ===

  /// Mostra dialog
  static Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: currentContext!,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  /// Mostra bottom sheet
  static Future<T?> showBottomSheet<T>({
    required Widget content,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: currentContext!,
      builder: (_) => content,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
    );
  }

  /// Mostra snackbar
  static void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(snackBar);
  }

  /// Remove snackbars
  static void removeCurrentSnackBar() {
    ScaffoldMessenger.of(currentContext!).removeCurrentSnackBar();
  }
}

/// Classe base para definir rotas type-safe
abstract class AppRoute<T> {
  /// Nome da rota
  String get name;
  
  /// Caminho da rota
  String get path;
  
  /// Widget da página
  Widget get page;
  
  /// Configurações da rota
  AppRouteConfig get config;
  
  /// Cria o MaterialPageRoute
  MaterialPageRoute<T> get materialPageRoute {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: RouteSettings(name: name),
      fullscreenDialog: config.fullscreenDialog,
      maintainState: config.maintainState,
      allowSnapshotting: config.allowSnapshotting,
    );
  }
  
  /// Cria PageRouteBuilder customizado
  PageRouteBuilder<T> customPageRoute({
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) transitionsBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: RouteSettings(name: name),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return transitionsBuilder(context, animation, secondaryAnimation, child);
      },
      transitionDuration: transitionDuration ?? config.transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration ?? config.reverseTransitionDuration,
      fullscreenDialog: config.fullscreenDialog,
      maintainState: config.maintainState,
      opaque: config.opaque,
    );
  }
}

/// Configurações para rotas
class AppRouteConfig {
  /// Se é um dialog fullscreen
  final bool fullscreenDialog;
  
  /// Se deve manter o state
  final bool maintainState;
  
  /// Se permite snapshots
  final bool allowSnapshotting;
  
  /// Se a rota é opaca
  final bool opaque;
  
  /// Duração da transição
  final Duration transitionDuration;
  
  /// Duração da transição reversa
  final Duration reverseTransitionDuration;

  const AppRouteConfig({
    this.fullscreenDialog = false,
    this.maintainState = true,
    this.allowSnapshotting = true,
    this.opaque = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  });

  /// Configuração para modals
  static const AppRouteConfig modal = AppRouteConfig(
    fullscreenDialog: true,
    transitionDuration: Duration(milliseconds: 400),
  );

  /// Configuração para páginas rápidas
  static const AppRouteConfig fast = AppRouteConfig(
    transitionDuration: Duration(milliseconds: 200),
    reverseTransitionDuration: Duration(milliseconds: 200),
  );

  /// Configuração para páginas lentas/elaboradas
  static const AppRouteConfig slow = AppRouteConfig(
    transitionDuration: Duration(milliseconds: 500),
    reverseTransitionDuration: Duration(milliseconds: 500),
  );
}
