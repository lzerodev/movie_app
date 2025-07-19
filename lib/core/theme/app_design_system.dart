import 'package:flutter/material.dart';

/// Sistema de Design unificado para o Movie App
/// 
/// Centraliza cores, tipografia, espaçamentos e outros elementos
/// de design para manter consistência visual em toda a aplicação.
class AppDesignSystem {
  // === CORES ===
  
  /// Cores primárias do app
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color primaryLightColor = Color(0xFF16213E);
  static const Color primaryDarkColor = Color(0xFF0F0F1E);
  
  /// Cores de acento
  static const Color accentColor = Color(0xFFE94560);
  static const Color accentLightColor = Color(0xFFFF6B7A);
  static const Color accentDarkColor = Color(0xFFBF2C43);
  
  /// Cores de fundo
  static const Color backgroundColor = Color(0xFF0F0F23);
  static const Color surfaceColor = Color(0xFF1A1A2E);
  static const Color cardColor = Color(0xFF16213E);
  
  /// Cores de texto
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB8B8B8);
  static const Color textTertiaryColor = Color(0xFF808080);
  
  /// Cores de estado
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);
  
  /// Cores de ícones
  static const Color iconPrimaryColor = Color(0xFFFFFFFF);
  static const Color iconSecondaryColor = Color(0xFFB8B8B8);
  static const Color iconTertiaryColor = Color(0xFF808080);
  
  /// Cores de inputs
  static const Color inputBackgroundColor = Color(0xFF1A1A2E);
  static const Color inputDisabledColor = Color(0xFF16213E);
  static const Color borderColor = Color(0xFF2A2A3E);
  static const Color borderDisabledColor = Color(0xFF1A1A2E);
  
  // === GRADIENTES ===
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryDarkColor],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentDarkColor],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, cardColor],
  );
  
  // === CORES DO SHIMMER ===
  
  static const Color shimmerBaseColor = Color(0xFF2A2A3E);
  static const Color shimmerHighlightColor = Color(0xFF3A3A4E);
  
  // === TIPOGRAFIA ===
  
  /// Família de fonte principal
  static const String fontFamily = 'Poppins';
  
  /// Estilos de texto
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: -0.25,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiaryColor,
    height: 1.3,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textTertiaryColor,
  );
  
  // === ESPAÇAMENTOS ===
  
  /// Espaçamentos padronizados
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;
  static const double space3xl = 64.0;
  
  // === BORDAS E RAIOS ===
  
  /// Raios de borda padronizados
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  
  /// BorderRadius padronizados
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadius2xl = BorderRadius.all(Radius.circular(radius2xl));
  
  // === SOMBRAS ===
  
  /// Elevações padronizadas
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
  
  // === DURAÇÕES DE ANIMAÇÃO ===
  
  /// Durações de animação padronizadas
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // === BREAKPOINTS RESPONSIVOS ===
  
  /// Breakpoints para design responsivo
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  
  // === MÉTODOS UTILITÁRIOS ===
  
  /// Verifica se a tela é mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  /// Verifica se a tela é tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }
  
  /// Verifica se a tela é desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
  
  /// Retorna espaçamento responsivo
  static double responsiveSpacing(BuildContext context) {
    if (isMobile(context)) return spaceMd;
    if (isTablet(context)) return spaceLg;
    return spaceXl;
  }
  
  /// Retorna padding responsivo
  static EdgeInsets responsivePadding(BuildContext context) {
    final spacing = responsiveSpacing(context);
    return EdgeInsets.all(spacing);
  }
}
