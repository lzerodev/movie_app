import 'package:flutter/material.dart';

/// Coleção de transições customizadas para navegação
class AppTransitions {
  // === TRANSIÇÕES BÁSICAS ===

  /// Transição de slide da direita para esquerda
  static Widget slideRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
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
  }

  /// Transição de slide da esquerda para direita
  static Widget slideLeft(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Transição de slide de baixo para cima
  static Widget slideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Transição de slide de cima para baixo
  static Widget slideDown(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, -1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  // === TRANSIÇÕES DE FADE ===

  /// Transição de fade simples
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Transição de fade com scale
  static Widget fadeScale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: child,
      ),
    );
  }

  // === TRANSIÇÕES AVANÇADAS ===

  /// Transição de zoom
  static Widget zoom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.elasticOut),
      ),
      child: child,
    );
  }

  /// Transição de rotação
  static Widget rotation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Transição de slide com fade combinados
  static Widget slideFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    Offset begin = const Offset(1.0, 0.0),
  }) {
    var slideTween = Tween(begin: begin, end: Offset.zero).chain(
      CurveTween(curve: Curves.easeOut),
    );

    return SlideTransition(
      position: animation.drive(slideTween),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // === TRANSIÇÕES ESPECIAIS ===

  /// Transição para modals (bottom sheet style)
  static Widget modalSlide(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }

  /// Transição hero personalizada
  static Widget heroTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Combina slide suave com fade
    var slideTween = Tween(begin: const Offset(0.1, 0.0), end: Offset.zero).chain(
      CurveTween(curve: Curves.easeOutQuart),
    );

    return SlideTransition(
      position: animation.drive(slideTween),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      ),
    );
  }

  /// Transição tipo "cupertino" (iOS)
  static Widget cupertinoTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.easeInToLinear,
      )),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInToLinear,
        )),
        child: child,
      ),
    );
  }
}

/// Builder para transições customizadas
typedef TransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

/// Enum para tipos de transição pré-definidos
enum AppTransitionType {
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  fade,
  fadeScale,
  zoom,
  rotation,
  slideFade,
  modalSlide,
  heroTransition,
  cupertinoTransition,
}

/// Extensão para facilitar o uso das transições
extension AppTransitionTypeExtension on AppTransitionType {
  TransitionBuilder get builder {
    switch (this) {
      case AppTransitionType.slideRight:
        return AppTransitions.slideRight;
      case AppTransitionType.slideLeft:
        return AppTransitions.slideLeft;
      case AppTransitionType.slideUp:
        return AppTransitions.slideUp;
      case AppTransitionType.slideDown:
        return AppTransitions.slideDown;
      case AppTransitionType.fade:
        return AppTransitions.fade;
      case AppTransitionType.fadeScale:
        return AppTransitions.fadeScale;
      case AppTransitionType.zoom:
        return AppTransitions.zoom;
      case AppTransitionType.rotation:
        return AppTransitions.rotation;
      case AppTransitionType.slideFade:
        return AppTransitions.slideFade;
      case AppTransitionType.modalSlide:
        return AppTransitions.modalSlide;
      case AppTransitionType.heroTransition:
        return AppTransitions.heroTransition;
      case AppTransitionType.cupertinoTransition:
        return AppTransitions.cupertinoTransition;
    }
  }
}
