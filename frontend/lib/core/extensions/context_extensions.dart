import 'package:flutter/material.dart';

/// Extensions úteis para Context.
extension ContextExtensions on BuildContext {
  /// Acesso rápido ao MediaQuery.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Acesso rápido ao Theme.
  ThemeData get theme => Theme.of(this);

  /// Acesso rápido ao TextTheme.
  TextTheme get textTheme => theme.textTheme;

  /// Acesso rápido ao ColorScheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Largura da tela.
  double get screenWidth => mediaQuery.size.width;

  /// Altura da tela.
  double get screenHeight => mediaQuery.size.height;

  /// Verificar se é uma tela pequena (mobile).
  bool get isSmallScreen => screenWidth < 600;

  /// Verificar se é uma tela média (tablet).
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Verificar se é uma tela grande (desktop).
  bool get isLargeScreen => screenWidth >= 1200;

  /// Mostrar SnackBar de forma simples.
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mostrar SnackBar de erro.
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  /// Mostrar SnackBar de sucesso.
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Navegar para uma nova tela.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Substituir a tela atual.
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// Voltar para a tela anterior.
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
