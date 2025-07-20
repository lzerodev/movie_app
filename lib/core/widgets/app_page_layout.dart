import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';

/// Layout base para páginas da aplicação.
///
/// Fornece uma estrutura consistente com AppBar, corpo da página
/// e opções de personalização comuns.
class AppPageLayout extends StatelessWidget {
  /// Título da página
  final String? title;

  /// Widget personalizado para o título (substitui o title)
  final Widget? titleWidget;

  /// Corpo da página
  final Widget body;

  /// Ações da AppBar
  final List<Widget>? actions;

  /// Widget de leading da AppBar
  final Widget? leading;

  /// Se deve mostrar o botão de voltar automaticamente
  final bool automaticallyImplyLeading;

  /// Floating Action Button
  final Widget? floatingActionButton;

  /// Posição do FAB
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom Navigation Bar
  final Widget? bottomNavigationBar;

  /// Drawer lateral
  final Widget? drawer;

  /// End Drawer
  final Widget? endDrawer;

  /// Bottom Sheet persistente
  final Widget? bottomSheet;

  /// Se deve usar SafeArea
  final bool useSafeArea;

  /// Se deve usar SingleChildScrollView
  final bool scrollable;

  /// Padding do corpo da página
  final EdgeInsetsGeometry? padding;

  /// Cor de fundo personalizada
  final Color? backgroundColor;

  /// Se deve mostrar a AppBar
  final bool showAppBar;

  /// Altura personalizada da AppBar
  final double? appBarHeight;

  /// Se a AppBar deve ser transparente
  final bool transparentAppBar;

  const AppPageLayout({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.useSafeArea = true,
    this.scrollable = false,
    this.padding,
    this.backgroundColor,
    this.showAppBar = true,
    this.appBarHeight,
    this.transparentAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget pageBody = body;

    // Aplica padding se especificado
    if (padding != null) {
      pageBody = Padding(
        padding: padding!,
        child: pageBody,
      );
    }

    // Aplica scroll se especificado
    if (scrollable) {
      pageBody = SingleChildScrollView(
        child: pageBody,
      );
    }

    // Aplica SafeArea se especificado
    if (useSafeArea) {
      pageBody = SafeArea(
        child: pageBody,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppDesignSystem.backgroundColor,
      appBar: showAppBar ? _buildAppBar(context) : null,
      body: pageBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? _buildAppBarTitle() : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor:
          transparentAppBar ? Colors.transparent : AppDesignSystem.surfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: AppDesignSystem.primaryColor.withOpacity(0.3),
      centerTitle: true,
      toolbarHeight: appBarHeight ?? 64,
      titleTextStyle: AppDesignSystem.headlineSmall.copyWith(
        color: AppDesignSystem.textPrimaryColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(
        color: AppDesignSystem.iconPrimaryColor,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppDesignSystem.iconPrimaryColor,
        size: 24,
      ),
      shape: const Border(
        bottom: BorderSide(
          color: AppDesignSystem.cardBorderColor,
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuart, // Curva mais suave que não extrapola
      builder: (context, value, child) {
        // Múltiplas camadas de proteção para garantir valores válidos
        final safeValue = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);
        final safeOpacity = safeValue.clamp(0.0, 1.0);
        final safeScale = (0.85 + (0.15 * safeValue)).clamp(0.7, 1.0);

        // Proteção adicional para opacidade das sombras
        final shadowOpacity1 = (0.3 * safeOpacity).clamp(0.0, 1.0);
        final shadowOpacity2 = (0.15 * safeOpacity).clamp(0.0, 1.0);

        return Transform.scale(
          scale: safeScale,
          child: Opacity(
            opacity: safeOpacity,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spaceMd,
                vertical: AppDesignSystem.spaceSm,
              ),
              decoration: BoxDecoration(
                gradient: AppDesignSystem.accentGradient,
                borderRadius: AppDesignSystem.borderRadiusMd,
                boxShadow: safeOpacity > 0
                    ? [
                        BoxShadow(
                          color: AppDesignSystem.accentColor
                              .withOpacity(shadowOpacity1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: AppDesignSystem.accentColor
                              .withOpacity(shadowOpacity2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.movie_creation_outlined,
                    color: AppDesignSystem.textPrimaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppDesignSystem.spaceSm),
                  Text(
                    title!,
                    style: AppDesignSystem.headlineSmall.copyWith(
                      color: AppDesignSystem.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Layout para páginas com carregamento
class AppLoadingPageLayout extends StatelessWidget {
  /// Título da página
  final String? title;

  /// Mensagem de carregamento
  final String? loadingMessage;

  /// Se deve mostrar a AppBar
  final bool showAppBar;

  const AppLoadingPageLayout({
    super.key,
    this.title,
    this.loadingMessage,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: title,
      showAppBar: showAppBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppDesignSystem.accentColor,
            ),
            if (loadingMessage != null) ...[
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                loadingMessage!,
                style: AppDesignSystem.bodyLarge.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Layout para páginas de erro
class AppErrorPageLayout extends StatelessWidget {
  /// Título da página
  final String? title;

  /// Título do erro
  final String errorTitle;

  /// Mensagem de erro
  final String errorMessage;

  /// Ícone do erro
  final IconData? errorIcon;

  /// Texto do botão de retry
  final String? retryButtonText;

  /// Função chamada quando o botão de retry é pressionado
  final VoidCallback? onRetry;

  /// Se deve mostrar a AppBar
  final bool showAppBar;

  const AppErrorPageLayout({
    super.key,
    this.title,
    required this.errorTitle,
    required this.errorMessage,
    this.errorIcon,
    this.retryButtonText,
    this.onRetry,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: title,
      showAppBar: showAppBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                errorIcon ?? Icons.error_outline,
                size: 64,
                color: AppDesignSystem.errorColor,
              ),
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                errorTitle,
                style: AppDesignSystem.headlineSmall.copyWith(
                  color: AppDesignSystem.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              Text(
                errorMessage,
                style: AppDesignSystem.bodyLarge.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppDesignSystem.spaceXl),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryButtonText ?? 'Tentar novamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppDesignSystem.accentColor,
                    foregroundColor: AppDesignSystem.textPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spaceLg,
                      vertical: AppDesignSystem.spaceMd,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Layout para páginas vazias (empty state)
class AppEmptyPageLayout extends StatelessWidget {
  /// Título da página
  final String? title;

  /// Título do estado vazio
  final String emptyTitle;

  /// Mensagem do estado vazio
  final String emptyMessage;

  /// Ícone do estado vazio
  final IconData? emptyIcon;

  /// Widget de ilustração personalizada
  final Widget? illustration;

  /// Texto do botão de ação
  final String? actionButtonText;

  /// Função chamada quando o botão de ação é pressionado
  final VoidCallback? onAction;

  /// Se deve mostrar a AppBar
  final bool showAppBar;

  const AppEmptyPageLayout({
    super.key,
    this.title,
    required this.emptyTitle,
    required this.emptyMessage,
    this.emptyIcon,
    this.illustration,
    this.actionButtonText,
    this.onAction,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      title: title,
      showAppBar: showAppBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (illustration != null)
                illustration!
              else
                Icon(
                  emptyIcon ?? Icons.movie_outlined,
                  size: 80,
                  color: AppDesignSystem.iconSecondaryColor,
                ),
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                emptyTitle,
                style: AppDesignSystem.headlineSmall.copyWith(
                  color: AppDesignSystem.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              Text(
                emptyMessage,
                style: AppDesignSystem.bodyLarge.copyWith(
                  color: AppDesignSystem.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (onAction != null) ...[
                const SizedBox(height: AppDesignSystem.spaceXl),
                ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add),
                  label: Text(actionButtonText ?? 'Começar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppDesignSystem.accentColor,
                    foregroundColor: AppDesignSystem.textPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesignSystem.spaceLg,
                      vertical: AppDesignSystem.spaceMd,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
