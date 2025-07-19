import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';

/// Configuração de tema da aplicação usando o Design System.
/// 
/// Define o tema principal da aplicação com cores, tipografia,
/// componentes e outros elementos visuais consistentes.
class AppTheme {
  /// Tema principal da aplicação
  static ThemeData get theme {
    return ThemeData(
      // === CONFIGURAÇÕES BÁSICAS ===
      useMaterial3: true,
      fontFamily: AppDesignSystem.fontFamily,
      
      // === CORES ===
      colorScheme: const ColorScheme.dark(
        primary: AppDesignSystem.accentColor,
        onPrimary: AppDesignSystem.textPrimaryColor,
        secondary: AppDesignSystem.accentLightColor,
        onSecondary: AppDesignSystem.textPrimaryColor,
        surface: AppDesignSystem.surfaceColor,
        onSurface: AppDesignSystem.textPrimaryColor,
        error: AppDesignSystem.errorColor,
        onError: AppDesignSystem.textPrimaryColor,
      ),
      
      // === SCAFFOLD ===
      scaffoldBackgroundColor: const Color.fromARGB(124, 2, 2, 39),
      
      // === APP BAR ===
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppDesignSystem.primaryColor,
        foregroundColor: AppDesignSystem.textPrimaryColor,
        titleTextStyle: AppDesignSystem.headlineSmall,
        iconTheme: IconThemeData(
          color: AppDesignSystem.textPrimaryColor,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppDesignSystem.textPrimaryColor,
          size: 24,
        ),
      ),
      
      // === CARDS ===
      cardTheme: CardTheme(
        color: AppDesignSystem.cardColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      // === ELEVATED BUTTON ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesignSystem.accentColor,
          foregroundColor: AppDesignSystem.textPrimaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceLg,
            vertical: AppDesignSystem.spaceMd,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
          textStyle: AppDesignSystem.labelLarge,
          elevation: 2,
        ),
      ),
      
      // === TEXT BUTTON ===
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppDesignSystem.accentColor,
          textStyle: AppDesignSystem.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceMd,
            vertical: AppDesignSystem.spaceSm,
          ),
        ),
      ),
      
      // === OUTLINED BUTTON ===
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesignSystem.accentColor,
          side: const BorderSide(color: AppDesignSystem.accentColor),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDesignSystem.borderRadiusMd,
          ),
          textStyle: AppDesignSystem.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spaceLg,
            vertical: AppDesignSystem.spaceMd,
          ),
        ),
      ),
      
      // === INPUT DECORATION ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesignSystem.surfaceColor,
        border: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide(
            color: AppDesignSystem.accentColor,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide(
            color: AppDesignSystem.errorColor,
            width: 2,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
          borderSide: BorderSide(
            color: AppDesignSystem.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMd,
          vertical: AppDesignSystem.spaceMd,
        ),
        hintStyle: AppDesignSystem.bodyMedium.copyWith(
          color: AppDesignSystem.textTertiaryColor,
        ),
        labelStyle: AppDesignSystem.bodyMedium,
      ),
      
      // === BOTTOM NAVIGATION BAR ===
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppDesignSystem.primaryColor,
        selectedItemColor: AppDesignSystem.accentColor,
        unselectedItemColor: AppDesignSystem.textTertiaryColor,
        selectedLabelStyle: AppDesignSystem.labelSmall,
        unselectedLabelStyle: AppDesignSystem.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // === CHIP ===
      chipTheme: const ChipThemeData(
        backgroundColor: AppDesignSystem.surfaceColor,
        selectedColor: AppDesignSystem.accentColor,
        disabledColor: AppDesignSystem.textTertiaryColor,
        labelStyle: AppDesignSystem.labelMedium,
        secondaryLabelStyle: AppDesignSystem.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceSm,
          vertical: AppDesignSystem.spaceXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusSm,
        ),
      ),
      
      // === DIALOG ===
      dialogTheme: const DialogTheme(
        backgroundColor: AppDesignSystem.surfaceColor,
        titleTextStyle: AppDesignSystem.headlineSmall,
        contentTextStyle: AppDesignSystem.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusLg,
        ),
      ),
      
      // === DIVIDER ===
      dividerTheme: const DividerThemeData(
        color: AppDesignSystem.textTertiaryColor,
        thickness: 1,
        space: AppDesignSystem.spaceMd,
      ),
      
      // === FLOATING ACTION BUTTON ===
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppDesignSystem.accentColor,
        foregroundColor: AppDesignSystem.textPrimaryColor,
        elevation: 4,
        shape: CircleBorder(),
      ),
      
      // === ICON ===
      iconTheme: const IconThemeData(
        color: AppDesignSystem.textSecondaryColor,
        size: 24,
      ),
      
      // === LIST TILE ===
      listTileTheme: const ListTileThemeData(
        textColor: AppDesignSystem.textPrimaryColor,
        iconColor: AppDesignSystem.textSecondaryColor,
        tileColor: AppDesignSystem.surfaceColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceMd,
          vertical: AppDesignSystem.spaceSm,
        ),
      ),
      
      // === PROGRESS INDICATOR ===
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppDesignSystem.accentColor,
        linearTrackColor: AppDesignSystem.textTertiaryColor,
        circularTrackColor: AppDesignSystem.textTertiaryColor,
      ),
      
      // === SNACK BAR ===
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppDesignSystem.surfaceColor,
        contentTextStyle: AppDesignSystem.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignSystem.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      // === TEXT THEME ===
      textTheme: const TextTheme(
        displayLarge: AppDesignSystem.headlineLarge,
        displayMedium: AppDesignSystem.headlineMedium,
        displaySmall: AppDesignSystem.headlineSmall,
        headlineLarge: AppDesignSystem.headlineLarge,
        headlineMedium: AppDesignSystem.headlineMedium,
        headlineSmall: AppDesignSystem.headlineSmall,
        titleLarge: AppDesignSystem.titleLarge,
        titleMedium: AppDesignSystem.titleMedium,
        titleSmall: AppDesignSystem.titleSmall,
        bodyLarge: AppDesignSystem.bodyLarge,
        bodyMedium: AppDesignSystem.bodyMedium,
        bodySmall: AppDesignSystem.bodySmall,
        labelLarge: AppDesignSystem.labelLarge,
        labelMedium: AppDesignSystem.labelMedium,
        labelSmall: AppDesignSystem.labelSmall,
      ),
      
      // === TOOLTIP ===
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: AppDesignSystem.surfaceColor,
          borderRadius: AppDesignSystem.borderRadiusSm,
        ),
        textStyle: AppDesignSystem.bodySmall,
        padding: EdgeInsets.all(AppDesignSystem.spaceSm),
      ),
    );
  }
}
