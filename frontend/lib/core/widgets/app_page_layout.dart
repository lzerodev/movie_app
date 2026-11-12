import 'package:material_ui/material_ui.dart';

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
      pageBody = Padding(padding: padding!, child: pageBody);
    }

    // Aplica scroll se especificado
    if (scrollable) {
      pageBody = SingleChildScrollView(child: pageBody);
    }

    // Aplica SafeArea se especificado
    if (useSafeArea) {
      pageBody = SafeArea(child: pageBody);
    }

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
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
      title: titleWidget ?? (title != null ? _buildAppBarTitle(context) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: transparentAppBar
          ? Colors.transparent
          : Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Theme.of(context).colorScheme.surfaceContainer
          .withValues(alpha: 0.3),
      centerTitle: false,
      titleSpacing: 20,
      toolbarHeight: appBarHeight ?? 64,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
      shape: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Text(
      title!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
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
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            if (loadingMessage != null) ...[
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                loadingMessage!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                errorTitle,
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              const SizedBox(height: AppDesignSystem.spaceLg),
              Text(
                emptyTitle,
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDesignSystem.spaceMd),
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
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
