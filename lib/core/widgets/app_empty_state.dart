import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Widget reutilizável para exibir estados vazios.
/// 
/// Fornece uma interface consistente para quando não há dados
/// para exibir, com opções de customização para diferentes contextos.
class AppEmptyState extends StatelessWidget {
  /// Ícone principal
  final IconData icon;
  
  /// Título principal
  final String title;
  
  /// Subtítulo/descrição opcional
  final String? subtitle;
  
  /// Ação principal (botão) opcional
  final String? actionLabel;
  
  /// Callback da ação principal
  final VoidCallback? onAction;
  
  /// Ação secundária opcional
  final String? secondaryActionLabel;
  
  /// Callback da ação secundária
  final VoidCallback? onSecondaryAction;
  
  /// Tamanho do ícone
  final double iconSize;
  
  /// Cor personalizada do ícone
  final Color? iconColor;
  
  /// Estilo personalizado do título
  final TextStyle? titleStyle;
  
  /// Estilo personalizado do subtítulo
  final TextStyle? subtitleStyle;
  
  /// Padding personalizado
  final EdgeInsetsGeometry? padding;
  
  /// Widget customizado para ilustração (substitui o ícone)
  final Widget? illustration;
  
  /// Variante do estado vazio
  final AppEmptyStateVariant variant;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.illustration,
    this.variant = AppEmptyStateVariant.default_,
  });

  /// Factory para estado de lista vazia
  const AppEmptyState.list({
    super.key,
    String? title,
    String? subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.padding,
    this.illustration,
  }) : icon = Icons.inbox_outlined,
       title = title ?? 'Nenhum item encontrado',
       subtitle = subtitle ?? 'Não há itens para exibir no momento.',
       iconColor = null,
       titleStyle = null,
       subtitleStyle = null,
       variant = AppEmptyStateVariant.list;

  /// Factory para estado de busca vazia
  const AppEmptyState.search({
    super.key,
    String? title,
    String? subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.padding,
    this.illustration,
  }) : icon = Icons.search_off_outlined,
       title = title ?? 'Nenhum resultado encontrado',
       subtitle = subtitle ?? 'Tente ajustar sua busca ou filtros.',
       iconColor = null,
       titleStyle = null,
       subtitleStyle = null,
       variant = AppEmptyStateVariant.search;

  /// Factory para estado de filmes vazios
  const AppEmptyState.movies({
    super.key,
    String? title,
    String? subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.padding,
    this.illustration,
  }) : icon = Icons.movie_outlined,
       title = title ?? 'Nenhum filme encontrado',
       subtitle = subtitle ?? 'Não encontramos filmes para exibir.',
       iconColor = null,
       titleStyle = null,
       subtitleStyle = null,
       variant = AppEmptyStateVariant.movies;

  /// Factory para estado de favoritos vazios
  const AppEmptyState.favorites({
    super.key,
    String? title,
    String? subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.padding,
    this.illustration,
  }) : icon = Icons.favorite_border_outlined,
       title = title ?? 'Nenhum favorito ainda',
       subtitle = subtitle ?? 'Adicione filmes aos seus favoritos.',
       iconColor = null,
       titleStyle = null,
       subtitleStyle = null,
       variant = AppEmptyStateVariant.favorites;

  /// Factory para estado de erro de conexão
  const AppEmptyState.connection({
    super.key,
    String? title,
    String? subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 64.0,
    this.padding,
    this.illustration,
  }) : icon = Icons.wifi_off_outlined,
       title = title ?? 'Sem conexão',
       subtitle = subtitle ?? 'Verifique sua conexão com a internet.',
       iconColor = null,
       titleStyle = null,
       subtitleStyle = null,
       variant = AppEmptyStateVariant.connection;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 
        const EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceLg);

    return Center(
      child: Padding(
        padding: effectivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIllustration(),
            const SizedBox(height: AppDesignSystem.spaceLg),
            _buildTitle(),
            if (subtitle != null) ...[
              const SizedBox(height: AppDesignSystem.spaceSm),
              _buildSubtitle(),
            ],
            if (actionLabel != null || secondaryActionLabel != null) ...[
              const SizedBox(height: AppDesignSystem.spaceXl),
              _buildActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    if (illustration != null) {
      return illustration!;
    }

    return Container(
      width: iconSize + 24,
      height: iconSize + 24,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? _getIconColor(),
      ),
    );
  }

  Widget _buildTitle() {
    final effectiveStyle = titleStyle ?? 
        AppDesignSystem.titleMedium.copyWith(
          color: AppDesignSystem.textPrimaryColor,
          fontWeight: FontWeight.w600,
        );

    return Text(
      title,
      style: effectiveStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    final effectiveStyle = subtitleStyle ?? 
        AppDesignSystem.bodyMedium.copyWith(
          color: AppDesignSystem.textSecondaryColor,
        );

    return Text(
      subtitle!,
      style: effectiveStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (actionLabel != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignSystem.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDesignSystem.spaceMd,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppDesignSystem.borderRadiusMd,
                ),
              ),
              child: Text(actionLabel!),
            ),
          ),
        if (secondaryActionLabel != null) ...[
          const SizedBox(height: AppDesignSystem.spaceSm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onSecondaryAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppDesignSystem.accentColor,
                side: const BorderSide(color: AppDesignSystem.accentColor),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDesignSystem.spaceMd,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppDesignSystem.borderRadiusMd,
                ),
              ),
              child: Text(secondaryActionLabel!),
            ),
          ),
        ],
      ],
    );
  }

  Color _getIconColor() {
    switch (variant) {
      case AppEmptyStateVariant.default_:
      case AppEmptyStateVariant.list:
        return AppDesignSystem.textSecondaryColor;
      case AppEmptyStateVariant.search:
        return AppDesignSystem.warningColor;
      case AppEmptyStateVariant.movies:
        return AppDesignSystem.accentColor;
      case AppEmptyStateVariant.favorites:
        return AppDesignSystem.errorColor;
      case AppEmptyStateVariant.connection:
        return AppDesignSystem.infoColor;
    }
  }

  Color _getIconBackgroundColor() {
    switch (variant) {
      case AppEmptyStateVariant.default_:
      case AppEmptyStateVariant.list:
        return AppDesignSystem.textSecondaryColor.withOpacity(0.1);
      case AppEmptyStateVariant.search:
        return AppDesignSystem.warningColor.withOpacity(0.1);
      case AppEmptyStateVariant.movies:
        return AppDesignSystem.accentColor.withOpacity(0.1);
      case AppEmptyStateVariant.favorites:
        return AppDesignSystem.errorColor.withOpacity(0.1);
      case AppEmptyStateVariant.connection:
        return AppDesignSystem.infoColor.withOpacity(0.1);
    }
  }
}

/// Variantes do estado vazio
enum AppEmptyStateVariant {
  /// Estado padrão
  default_,
  
  /// Estado de lista vazia
  list,
  
  /// Estado de busca sem resultados
  search,
  
  /// Estado de filmes vazios
  movies,
  
  /// Estado de favoritos vazios
  favorites,
  
  /// Estado de erro de conexão
  connection,
}
