import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Widget reutilizável para indicadores de loading.
/// 
/// Oferece diferentes variantes de loading adaptadas para
/// diferentes contextos da aplicação.
class AppLoadingIndicator extends StatelessWidget {
  /// Tamanho do indicador
  final AppLoadingSize size;
  
  /// Variante visual do loading
  final AppLoadingVariant variant;
  
  /// Cor personalizada (opcional)
  final Color? color;
  
  /// Largura da linha do indicador
  final double? strokeWidth;
  
  /// Texto de loading opcional
  final String? message;
  
  /// Estilo do texto
  final TextStyle? messageStyle;
  
  /// Se deve mostrar o texto abaixo do indicador
  final bool showMessage;

  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.variant = AppLoadingVariant.circular,
    this.color,
    this.strokeWidth,
    this.message,
    this.messageStyle,
    this.showMessage = false,
  });

  /// Factory para loading pequeno
  const AppLoadingIndicator.small({
    super.key,
    this.variant = AppLoadingVariant.circular,
    this.color,
    this.strokeWidth,
    this.message,
    this.messageStyle,
    this.showMessage = false,
  }) : size = AppLoadingSize.small;

  /// Factory para loading inline (em listas)
  const AppLoadingIndicator.inline({
    super.key,
    this.color,
    this.message,
    this.messageStyle,
  }) : size = AppLoadingSize.small,
       variant = AppLoadingVariant.inline,
       strokeWidth = null,
       showMessage = true;

  /// Factory para loading de página inteira
  const AppLoadingIndicator.page({
    super.key,
    this.color,
    this.message,
    this.messageStyle,
  }) : size = AppLoadingSize.large,
       variant = AppLoadingVariant.page,
       strokeWidth = null,
       showMessage = true;

  /// Factory para loading de card personalizado
  const AppLoadingIndicator.card({
    super.key,
    String? message,
    this.color,
    this.messageStyle,
  }) : size = AppLoadingSize.medium,
       variant = AppLoadingVariant.card,
       strokeWidth = null,
       showMessage = true,
       message = message ?? 'Carregando...';

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppLoadingVariant.circular:
        return _buildCircular();
      case AppLoadingVariant.linear:
        return _buildLinear();
      case AppLoadingVariant.inline:
        return _buildInline();
      case AppLoadingVariant.page:
        return _buildPage();
      case AppLoadingVariant.card:
        return _buildCard();
    }
  }

  Widget _buildCircular() {
    final indicator = SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: CircularProgressIndicator(
        color: color ?? AppDesignSystem.accentColor,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
      ),
    );

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: AppDesignSystem.spaceMd),
          _buildMessage(),
        ],
      );
    }

    return indicator;
  }

  Widget _buildLinear() {
    final indicator = LinearProgressIndicator(
      color: color ?? AppDesignSystem.accentColor,
      backgroundColor: AppDesignSystem.surfaceColor,
    );

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMessage(),
          const SizedBox(height: AppDesignSystem.spaceSm),
          indicator,
        ],
      );
    }

    return indicator;
  }

  Widget _buildInline() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDesignSystem.spaceXl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _getSize(),
            height: _getSize(),
            child: CircularProgressIndicator(
              color: color ?? AppDesignSystem.accentColor,
              strokeWidth: _getStrokeWidth(),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(width: AppDesignSystem.spaceMd),
            _buildMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
            decoration: BoxDecoration(
              color: AppDesignSystem.cardColor,
              borderRadius: AppDesignSystem.borderRadiusLg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _getSize(),
                  height: _getSize(),
                  child: CircularProgressIndicator(
                    color: color ?? AppDesignSystem.accentColor,
                    strokeWidth: _getStrokeWidth(),
                  ),
                ),
                if (showMessage && message != null) ...[
                  const SizedBox(height: AppDesignSystem.spaceLg),
                  _buildMessage(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppDesignSystem.cardColor,
                AppDesignSystem.cardColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color ?? AppDesignSystem.accentColor,
                      (color ?? AppDesignSystem.accentColor).withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.movie_creation_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              _buildMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    final effectiveStyle = messageStyle ?? 
        AppDesignSystem.bodyMedium.copyWith(
          color: AppDesignSystem.textSecondaryColor,
          fontWeight: FontWeight.w500,
        );

    return Text(
      message ?? 'Carregando...',
      style: effectiveStyle,
      textAlign: TextAlign.center,
    );
  }

  double _getSize() {
    switch (size) {
      case AppLoadingSize.small:
        return 24.0;
      case AppLoadingSize.medium:
        return 32.0;
      case AppLoadingSize.large:
        return 48.0;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoadingSize.small:
        return 2.0;
      case AppLoadingSize.medium:
        return 3.0;
      case AppLoadingSize.large:
        return 4.0;
    }
  }
}

/// Tamanhos disponíveis para o loading
enum AppLoadingSize {
  small,
  medium,
  large,
}

/// Variantes visuais do loading
enum AppLoadingVariant {
  /// Indicador circular simples
  circular,
  
  /// Indicador linear/barra
  linear,
  
  /// Loading inline para listas
  inline,
  
  /// Loading de página inteira
  page,
  
  /// Loading estilizado em card
  card,
}
