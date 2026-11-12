import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';

/// Card personalizado que segue o Design System da aplicação.
///
/// Fornece um container estilizado com elevação, bordas arredondadas
/// e cores consistentes com o tema da aplicação.
///
/// @deprecated Use AppCard instead
class AppCardLegacy extends StatelessWidget {
  /// Conteúdo do card
  final Widget child;

  /// Padding interno do card
  final EdgeInsetsGeometry? padding;

  /// Margin externo do card
  final EdgeInsetsGeometry? margin;

  /// Função chamada quando o card é tocado
  final VoidCallback? onTap;

  /// Cor de fundo personalizada (opcional)
  final Color? backgroundColor;

  /// Elevação personalizada (opcional)
  final double? elevation;

  /// Raio da borda personalizado (opcional)
  final BorderRadius? borderRadius;

  /// Gradiente de fundo (opcional)
  final Gradient? gradient;

  /// Cor da borda (opcional)
  final Color? borderColor;

  /// Largura da borda (opcional)
  final double? borderWidth;

  const AppCardLegacy({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppDesignSystem.spaceMd),
      decoration: gradient != null
          ? BoxDecoration(
              gradient: gradient,
              borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
              boxShadow: elevation != null
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: elevation! * 2,
                        offset: Offset(0, elevation! / 2),
                      ),
                    ]
                  : AppDesignSystem.shadowMd,
            )
          : null,
      child: child,
    );

    if (gradient != null) {
      return Container(
        margin: margin,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
                child: cardContent,
              )
            : cardContent,
      );
    }

    return Container(
      margin: margin,
      child: Card(
        color: backgroundColor ?? AppDesignSystem.cardColor,
        elevation: borderColor != null
            ? 0
            : (elevation ?? 2), // Remove elevação se há borda custom
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
          side: borderColor != null
              ? BorderSide(
                  color: borderColor!,
                  width: borderWidth ?? 1.0,
                )
              : BorderSide.none,
        ),
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: borderRadius ?? AppDesignSystem.borderRadiusMd,
                child: cardContent,
              )
            : cardContent,
      ),
    );
  }
}

/// Botão primário que segue o Design System da aplicação.
class AppButton extends StatelessWidget {
  /// Texto do botão
  final String text;

  /// Função chamada quando o botão é pressionado
  final VoidCallback? onPressed;

  /// Ícone do botão (opcional)
  final IconData? icon;

  /// Se o botão deve ocupar a largura total
  final bool fullWidth;

  /// Variante do botão
  final AppButtonVariant variant;

  /// Tamanho do botão
  final AppButtonSize size;

  /// Se o botão está carregando
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppDesignSystem.textPrimaryColor,
              ),
            ),
          )
        else if (icon != null)
          Icon(icon, size: _getIconSize()),
        if ((icon != null || isLoading) && text.isNotEmpty)
          const SizedBox(width: AppDesignSystem.spaceSm),
        if (text.isNotEmpty)
          Text(
            text,
            style: _getTextStyle(),
            textAlign: TextAlign.center,
          ),
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(buttonChild),
    );
  }

  Widget _buildButton(Widget child) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppDesignSystem.accentColor,
            foregroundColor: AppDesignSystem.textPrimaryColor,
            padding: _getPadding(),
            shape: const RoundedRectangleBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
            ),
          ),
          child: child,
        );

      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppDesignSystem.accentColor,
            side: const BorderSide(color: AppDesignSystem.accentColor),
            padding: _getPadding(),
            shape: const RoundedRectangleBorder(
              borderRadius: AppDesignSystem.borderRadiusMd,
            ),
          ),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppDesignSystem.accentColor,
            padding: _getPadding(),
          ),
          child: child,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMd,
          vertical: AppDesignSystem.spaceSm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceLg,
          vertical: AppDesignSystem.spaceMd,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceXl,
          vertical: AppDesignSystem.spaceLg,
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppDesignSystem.labelMedium;
      case AppButtonSize.medium:
        return AppDesignSystem.labelLarge;
      case AppButtonSize.large:
        return AppDesignSystem.titleSmall;
    }
  }
}

/// Variantes do AppButton
enum AppButtonVariant {
  primary,
  secondary,
  text,
}

/// Tamanhos do AppButton
enum AppButtonSize {
  small,
  medium,
  large,
}
