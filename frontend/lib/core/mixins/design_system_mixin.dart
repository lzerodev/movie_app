import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';

/// Mixin que fornece acesso centralizado aos valores do Design System
///
/// Evita duplicação de código e garante consistência visual.
/// Use este mixin em widgets que precisam de acesso frequente
/// aos valores padronizados do design system.
mixin DesignSystemMixin {
  // === ESPAÇAMENTOS PADRONIZADOS ===

  /// Padding padrão para cards e containers
  EdgeInsets get defaultPadding =>
      const EdgeInsets.all(AppDesignSystem.spaceMd);

  /// Padding para seções principais
  EdgeInsets get sectionPadding =>
      const EdgeInsets.all(AppDesignSystem.spaceLg);

  /// Padding compacto para elementos pequenos
  EdgeInsets get compactPadding =>
      const EdgeInsets.all(AppDesignSystem.spaceSm);

  /// Margin entre elementos relacionados
  EdgeInsets get elementMargin => const EdgeInsets.all(AppDesignSystem.spaceMd);

  /// Padding horizontal para listas
  EdgeInsets get listPadding => const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spaceMd,
        vertical: AppDesignSystem.spaceSm,
      );

  // === BORDAS E DECORAÇÕES ===

  /// Decoração padrão para cards
  BoxDecoration get cardDecoration => BoxDecoration(
        color: AppDesignSystem.cardColor,
        borderRadius: AppDesignSystem.borderRadiusMd,
        border: Border.all(
          color: AppDesignSystem.cardBorderColor,
          width: 1,
        ),
        boxShadow: AppDesignSystem.shadowSm,
      );

  /// Decoração para containers principais
  BoxDecoration get containerDecoration => BoxDecoration(
        color: AppDesignSystem.surfaceColor,
        borderRadius: AppDesignSystem.borderRadiusLg,
        border: Border.all(
          color: AppDesignSystem.borderColor,
          width: 1,
        ),
      );

  /// Decoração para elementos de destaque
  BoxDecoration get accentDecoration => BoxDecoration(
        gradient: AppDesignSystem.accentGradient,
        borderRadius: AppDesignSystem.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: AppDesignSystem.accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Decoração para botões circulares
  BoxDecoration circularDecoration({
    required double size,
    Color? color,
    List<BoxShadow>? boxShadow,
  }) =>
      BoxDecoration(
        color: color ?? AppDesignSystem.cardColor,
        shape: BoxShape.circle,
        boxShadow: boxShadow ?? AppDesignSystem.shadowSm,
      );

  /// Decoração para badges e chips
  BoxDecoration get badgeDecoration => BoxDecoration(
        color: AppDesignSystem.accentColor.withOpacity(0.1),
        borderRadius: AppDesignSystem.borderRadiusSm,
        border: Border.all(
          color: AppDesignSystem.accentColor.withOpacity(0.3),
          width: 1,
        ),
      );

  // === ESTILOS DE TEXTO ===

  /// Estilo para títulos de seção
  TextStyle get sectionTitleStyle => AppDesignSystem.titleLarge.copyWith(
        color: AppDesignSystem.textPrimaryColor,
        fontWeight: FontWeight.bold,
      );

  /// Estilo para subtítulos
  TextStyle get subtitleStyle => AppDesignSystem.bodyMedium.copyWith(
        color: AppDesignSystem.textSecondaryColor,
      );

  /// Estilo para texto de destaque
  TextStyle get accentTextStyle => AppDesignSystem.labelLarge.copyWith(
        color: AppDesignSystem.accentColor,
        fontWeight: FontWeight.w600,
      );

  /// Estilo para texto secundário
  TextStyle get secondaryTextStyle => AppDesignSystem.bodySmall.copyWith(
        color: AppDesignSystem.textTertiaryColor,
      );

  // === ANIMAÇÕES ===

  /// Duração padrão para animações rápidas
  Duration get fastAnimation => AppDesignSystem.animationFast;

  /// Duração padrão para animações médias
  Duration get mediumAnimation => AppDesignSystem.animationMedium;

  /// Duração padrão para animações lentas
  Duration get slowAnimation => AppDesignSystem.animationSlow;

  // === UTILITÁRIOS ===

  /// Espaçamento vertical entre elementos
  Widget get verticalSpaceMd => const SizedBox(height: AppDesignSystem.spaceMd);

  /// Espaçamento vertical pequeno
  Widget get verticalSpaceSm => const SizedBox(height: AppDesignSystem.spaceSm);

  /// Espaçamento vertical grande
  Widget get verticalSpaceLg => const SizedBox(height: AppDesignSystem.spaceLg);

  /// Espaçamento horizontal padrão
  Widget get horizontalSpaceMd =>
      const SizedBox(width: AppDesignSystem.spaceMd);

  /// Espaçamento horizontal pequeno
  Widget get horizontalSpaceSm =>
      const SizedBox(width: AppDesignSystem.spaceSm);

  /// Divider padrão
  Widget get defaultDivider => const Divider(
        color: AppDesignSystem.borderColor,
        height: 1,
        thickness: 1,
      );
}
