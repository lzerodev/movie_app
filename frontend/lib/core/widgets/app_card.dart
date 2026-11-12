import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';

/// Sistema de cards unificado seguindo o Design System.
///
/// Fornece cards padronizados com múltiplas variantes visuais,
/// tamanhos configuráveis e comportamentos consistentes.
class AppCard extends StatelessWidget {
  /// Conteúdo do card
  final Widget child;

  /// Variante visual do card
  final AppCardVariant variant;

  /// Tamanho do card
  final AppCardSize size;

  /// Padding interno do card
  final EdgeInsetsGeometry? padding;

  /// Margin externo do card
  final EdgeInsetsGeometry? margin;

  /// Função chamada quando o card é tocado
  final VoidCallback? onTap;

  /// Função chamada quando o card é pressionado e segurado
  final VoidCallback? onLongPress;

  /// Cor de fundo personalizada (sobrescreve variant)
  final Color? backgroundColor;

  /// Elevação personalizada (sobrescreve variant)
  final double? elevation;

  /// Raio da borda personalizado (sobrescreve variant)
  final BorderRadius? borderRadius;

  /// Gradiente de fundo (sobrescreve backgroundColor)
  final Gradient? gradient;

  /// Cor da borda (opcional)
  final Color? borderColor;

  /// Largura da borda (opcional)
  final double? borderWidth;

  /// Se deve mostrar animação de hover/press
  final bool enableAnimation;

  /// Duração da animação
  final Duration animationDuration;

  /// Se deve mostrar splash effect no tap
  final bool enableSplash;

  /// Hero tag para animações de navegação
  final String? heroTag;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.borderColor,
    this.borderWidth,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  });

  /// Factory para card primário (accent color)
  const AppCard.primary({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  })  : variant = AppCardVariant.primary,
        backgroundColor = null,
        elevation = null,
        gradient = null,
        borderColor = null,
        borderWidth = null;

  /// Factory para card secundário (surface color)
  const AppCard.secondary({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  })  : variant = AppCardVariant.secondary,
        backgroundColor = null,
        elevation = null,
        gradient = null,
        borderColor = null,
        borderWidth = null;

  /// Factory para card outlined (apenas borda)
  const AppCard.outlined({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  })  : variant = AppCardVariant.outlined,
        backgroundColor = null,
        elevation = null,
        gradient = null;

  /// Factory para card minimal (background transparente)
  const AppCard.minimal({
    super.key,
    required this.child,
    this.size = AppCardSize.medium,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  })  : variant = AppCardVariant.minimal,
        backgroundColor = null,
        elevation = null,
        gradient = null,
        borderColor = null,
        borderWidth = null;

  /// Factory para card pequeno
  const AppCard.small({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.borderColor,
    this.borderWidth,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  }) : size = AppCardSize.small;

  /// Factory para card grande
  const AppCard.large({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.borderColor,
    this.borderWidth,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableSplash = true,
    this.heroTag,
  }) : size = AppCardSize.large;

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = Container(
      margin: margin,
      decoration: _buildDecoration(),
      child: _buildCardContent(),
    );

    // Aplicar Hero animation se heroTag fornecido
    if (heroTag != null) {
      cardWidget = Hero(
        tag: heroTag!,
        child: cardWidget,
      );
    }

    // Aplicar animação de hover/press se habilitada
    if (enableAnimation && (onTap != null || onLongPress != null)) {
      cardWidget = AnimatedScale(
        scale: 1.0,
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        child: cardWidget,
      );
    }

    return cardWidget;
  }

  Widget _buildCardContent() {
    final effectivePadding = padding ?? _getDefaultPadding();

    Widget content = Padding(
      padding: effectivePadding,
      child: child,
    );

    // Se não há interação, retorna apenas o conteúdo
    if (onTap == null && onLongPress == null) {
      return content;
    }

    // Se há interação, envolve com Material para splash effect
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: _getEffectiveBorderRadius(),
        splashColor: enableSplash ? _getSplashColor() : Colors.transparent,
        highlightColor:
            enableSplash ? _getHighlightColor() : Colors.transparent,
        child: content,
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _getBackgroundColor(),
      gradient: gradient,
      borderRadius: _getEffectiveBorderRadius(),
      border: _getBorder(),
      boxShadow: _getBoxShadow(),
    );
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (gradient != null) return Colors.transparent;

    switch (variant) {
      case AppCardVariant.primary:
        return AppDesignSystem.accentColor.withOpacity(0.1);
      case AppCardVariant.secondary:
        return AppDesignSystem.surfaceColor;
      case AppCardVariant.elevated:
        return AppDesignSystem.cardColor;
      case AppCardVariant.outlined:
        return Colors.transparent;
      case AppCardVariant.minimal:
        return Colors.transparent;
    }
  }

  BorderRadius _getEffectiveBorderRadius() {
    if (borderRadius != null) return borderRadius!;

    switch (size) {
      case AppCardSize.small:
        return AppDesignSystem.borderRadiusSm;
      case AppCardSize.medium:
        return AppDesignSystem.borderRadiusMd;
      case AppCardSize.large:
        return AppDesignSystem.borderRadiusLg;
      case AppCardSize.xl:
        return AppDesignSystem.borderRadiusXl;
    }
  }

  Border? _getBorder() {
    Color? effectiveBorderColor = borderColor;
    double effectiveBorderWidth = borderWidth ?? 1.0;

    // Define border baseado na variant se não especificado
    if (borderColor == null) {
      switch (variant) {
        case AppCardVariant.outlined:
          effectiveBorderColor = AppDesignSystem.borderColor;
          break;
        case AppCardVariant.primary:
          effectiveBorderColor = AppDesignSystem.accentColor.withOpacity(0.3);
          break;
        default:
          return null;
      }
    }

    if (effectiveBorderColor == null) return null;

    return Border.all(
      color: effectiveBorderColor,
      width: effectiveBorderWidth,
    );
  }

  List<BoxShadow>? _getBoxShadow() {
    if (elevation != null) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.1 * (elevation! / 8)),
          blurRadius: elevation! * 2,
          offset: Offset(0, elevation! / 2),
        ),
      ];
    }

    switch (variant) {
      case AppCardVariant.elevated:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppDesignSystem.primaryColor.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ];
      case AppCardVariant.primary:
        return [
          BoxShadow(
            color: AppDesignSystem.accentColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      default:
        return null;
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (size) {
      case AppCardSize.small:
        return const EdgeInsets.all(AppDesignSystem.spaceSm);
      case AppCardSize.medium:
        return const EdgeInsets.all(AppDesignSystem.spaceMd);
      case AppCardSize.large:
        return const EdgeInsets.all(AppDesignSystem.spaceLg);
      case AppCardSize.xl:
        return const EdgeInsets.all(AppDesignSystem.spaceXl);
    }
  }

  Color _getSplashColor() {
    switch (variant) {
      case AppCardVariant.primary:
        return AppDesignSystem.accentColor.withOpacity(0.1);
      default:
        return AppDesignSystem.primaryColor.withOpacity(0.05);
    }
  }

  Color _getHighlightColor() {
    switch (variant) {
      case AppCardVariant.primary:
        return AppDesignSystem.accentColor.withOpacity(0.05);
      default:
        return AppDesignSystem.primaryColor.withOpacity(0.03);
    }
  }
}

/// Variantes visuais do card
enum AppCardVariant {
  /// Card com elevação e sombra (padrão)
  elevated,

  /// Card com cor primária/accent
  primary,

  /// Card com cor secundária/surface
  secondary,

  /// Card apenas com borda
  outlined,

  /// Card minimalista sem background
  minimal,
}

/// Tamanhos disponíveis para o card
enum AppCardSize {
  /// Card pequeno
  small,

  /// Card médio (padrão)
  medium,

  /// Card grande
  large,

  /// Card extra grande
  xl,
}
