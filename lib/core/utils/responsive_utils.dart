import 'package:flutter/material.dart';

/// Utilitários para responsividade
class ResponsiveUtils {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Verifica se é mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Verifica se é tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Verifica se é desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Verifica se é desktop grande
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Retorna o tipo de dispositivo
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    if (width < desktopBreakpoint) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Retorna valor baseado no tipo de dispositivo
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Retorna padding responsivo
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(responsive<double>(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
      largeDesktop: 40,
    ));
  }

  /// Retorna espaçamento responsivo
  static double responsiveSpacing(BuildContext context) {
    return responsive<double>(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
      largeDesktop: 32,
    );
  }

  /// Retorna largura máxima do conteúdo
  static double getMaxContentWidth(BuildContext context) {
    return responsive<double>(
      context,
      mobile: double.infinity,
      tablet: 600,
      desktop: 800,
      largeDesktop: 1200,
    );
  }

  /// Verifica se está em orientação landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Retorna número de colunas para grid responsivo
  static int getGridColumns(BuildContext context) {
    return responsive<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }
}

/// Tipos de dispositivo
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Widget helper para construção responsiva
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    return builder(context, deviceType);
  }
}
