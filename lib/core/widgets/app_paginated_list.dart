import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';
import 'app_empty_state.dart';
import 'app_loading_indicator.dart';

/// Widget genérico para listas paginadas.
///
/// Fornece funcionalidade de scroll infinito, pull-to-refresh,
/// estados de loading, error e empty.
class AppPaginatedList<T> extends StatefulWidget {
  /// Lista de itens a serem exibidos
  final List<T> items;

  /// Builder para cada item da lista
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Se a lista chegou ao máximo de itens
  final bool hasReachedMax;

  /// Se está carregando mais itens
  final bool isLoadingMore;

  /// Se está carregando inicial
  final bool isLoading;

  /// Se houve erro
  final bool hasError;

  /// Mensagem de erro
  final String? errorMessage;

  /// Callback para carregar mais itens
  final VoidCallback? onLoadMore;

  /// Callback para refresh
  final Future<void> Function()? onRefresh;

  /// Callback para retry após erro
  final VoidCallback? onRetry;

  /// Configurações de empty state
  final AppEmptyStateConfig? emptyStateConfig;

  /// Configurações de scroll
  final AppScrollConfig? scrollConfig;

  /// Configurações de layout
  final AppListLayoutConfig? layoutConfig;

  /// Se deve usar separadores entre itens
  final bool useSeparator;

  /// Builder personalizado para separador
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Configurações de animação
  final AppListAnimationConfig? animationConfig;

  const AppPaginatedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onLoadMore,
    this.onRefresh,
    this.onRetry,
    this.emptyStateConfig,
    this.scrollConfig,
    this.layoutConfig,
    this.useSeparator = true,
    this.separatorBuilder,
    this.animationConfig,
  });

  @override
  State<AppPaginatedList<T>> createState() => _AppPaginatedListState<T>();
}

class _AppPaginatedListState<T> extends State<AppPaginatedList<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final scrollConfig = widget.scrollConfig ?? const AppScrollConfig();
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // Trigger load more quando chegar no threshold
    if (currentScroll >= (maxScroll * scrollConfig.loadMoreThreshold) &&
        !widget.isLoadingMore &&
        !widget.hasReachedMax &&
        !widget.hasError) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estado de loading inicial
    if (widget.isLoading && widget.items.isEmpty) {
      return _buildInitialLoading();
    }

    // Estado de erro inicial
    if (widget.hasError && widget.items.isEmpty) {
      return _buildError();
    }

    // Estado vazio
    if (widget.items.isEmpty) {
      return _buildEmptyState();
    }

    return _buildList();
  }

  Widget _buildInitialLoading() {
    final layoutConfig = widget.layoutConfig ?? const AppListLayoutConfig();

    return Container(
      decoration: layoutConfig.decoration,
      child: const AppLoadingIndicator.page(
        message: 'Carregando itens...',
      ),
    );
  }

  Widget _buildError() {
    final emptyConfig = widget.emptyStateConfig ?? const AppEmptyStateConfig();

    return AppEmptyState.connection(
      title: emptyConfig.errorTitle ?? 'Ops! Algo deu errado',
      subtitle: widget.errorMessage ?? emptyConfig.errorMessage,
      actionLabel: emptyConfig.retryButtonText ?? 'Tentar novamente',
      onAction: widget.onRetry,
    );
  }

  Widget _buildEmptyState() {
    final emptyConfig = widget.emptyStateConfig ?? const AppEmptyStateConfig();

    return AppEmptyState(
      icon: emptyConfig.icon,
      title: emptyConfig.title,
      subtitle: emptyConfig.subtitle,
      actionLabel: emptyConfig.actionLabel,
      onAction: emptyConfig.onAction,
      variant: emptyConfig.variant,
    );
  }

  Widget _buildList() {
    final layoutConfig = widget.layoutConfig ?? const AppListLayoutConfig();
    final scrollConfig = widget.scrollConfig ?? const AppScrollConfig();

    Widget listWidget;

    if (widget.useSeparator) {
      listWidget = ListView.separated(
        controller: _scrollController,
        padding: layoutConfig.padding,
        physics: _getScrollPhysics(),
        itemCount: _getItemCount(),
        itemBuilder: _buildListItem,
        separatorBuilder: widget.separatorBuilder ?? _buildDefaultSeparator,
        clipBehavior: layoutConfig.clipBehavior,
        shrinkWrap: layoutConfig.shrinkWrap,
        addAutomaticKeepAlives: layoutConfig.addAutomaticKeepAlives,
        addRepaintBoundaries: layoutConfig.addRepaintBoundaries,
        addSemanticIndexes: layoutConfig.addSemanticIndexes,
        cacheExtent: layoutConfig.cacheExtent,
      );
    } else {
      listWidget = ListView.builder(
        controller: _scrollController,
        padding: layoutConfig.padding,
        physics: _getScrollPhysics(),
        itemCount: _getItemCount(),
        itemBuilder: _buildListItem,
        clipBehavior: layoutConfig.clipBehavior,
        shrinkWrap: layoutConfig.shrinkWrap,
        addAutomaticKeepAlives: layoutConfig.addAutomaticKeepAlives,
        addRepaintBoundaries: layoutConfig.addRepaintBoundaries,
        addSemanticIndexes: layoutConfig.addSemanticIndexes,
        cacheExtent: layoutConfig.cacheExtent,
      );
    }

    // Adiciona decoração se especificada
    if (layoutConfig.decoration != null) {
      listWidget = Container(
        decoration: layoutConfig.decoration,
        child: listWidget,
      );
    }

    // Adiciona refresh indicator se callback fornecido
    if (widget.onRefresh != null) {
      listWidget = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        color:
            scrollConfig.refreshIndicatorColor ?? AppDesignSystem.accentColor,
        backgroundColor:
            scrollConfig.refreshBackgroundColor ?? AppDesignSystem.cardColor,
        strokeWidth: scrollConfig.refreshStrokeWidth ?? 3.0,
        displacement: scrollConfig.refreshDisplacement ?? 50.0,
        child: listWidget,
      );
    }

    // Retorna o widget da lista diretamente
    return listWidget;
  }

  ScrollPhysics _getScrollPhysics() {
    final scrollConfig = widget.scrollConfig ?? const AppScrollConfig();

    switch (scrollConfig.scrollPhysics) {
      case AppScrollPhysicsType.bouncing:
        return const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        );
      case AppScrollPhysicsType.clamping:
        return const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        );
      case AppScrollPhysicsType.never:
        return const NeverScrollableScrollPhysics();
      case AppScrollPhysicsType.platform:
        return const AlwaysScrollableScrollPhysics();
    }
  }

  int _getItemCount() {
    if (widget.hasReachedMax) {
      return widget.items.length;
    }
    return widget.items.length + (widget.isLoadingMore ? 1 : 0);
  }

  Widget _buildListItem(BuildContext context, int index) {
    // Se é o último item e está carregando mais
    if (index >= widget.items.length) {
      return _buildLoadingMoreIndicator();
    }

    final item = widget.items[index];
    final animationConfig =
        widget.animationConfig ?? const AppListAnimationConfig();

    if (animationConfig.enableItemAnimation) {
      return AnimatedContainer(
        duration: Duration(
          milliseconds: animationConfig.animationDuration +
              (index * animationConfig.staggerDelay),
        ),
        curve: animationConfig.animationCurve,
        child: widget.itemBuilder(context, item, index),
      );
    }

    return widget.itemBuilder(context, item, index);
  }

  Widget _buildDefaultSeparator(BuildContext context, int index) {
    final layoutConfig = widget.layoutConfig ?? const AppListLayoutConfig();

    return SizedBox(
      height: layoutConfig.separatorHeight,
      width: layoutConfig.separatorWidth,
    );
  }

  Widget _buildLoadingMoreIndicator() {
    final scrollConfig = widget.scrollConfig ?? const AppScrollConfig();

    return Padding(
      padding: scrollConfig.loadingMorePadding,
      child: AppLoadingIndicator.inline(
        message: scrollConfig.loadingMoreMessage ?? 'Carregando mais itens...',
      ),
    );
  }
}

/// Configurações para o estado vazio
class AppEmptyStateConfig {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppEmptyStateVariant variant;
  final String? errorTitle;
  final String? errorMessage;
  final String? retryButtonText;

  const AppEmptyStateConfig({
    this.icon = Icons.inbox_outlined,
    this.title = 'Nenhum item encontrado',
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.variant = AppEmptyStateVariant.list,
    this.errorTitle,
    this.errorMessage,
    this.retryButtonText,
  });
}

/// Configurações de scroll
class AppScrollConfig {
  final double loadMoreThreshold;
  final AppScrollPhysicsType scrollPhysics;
  final Color? refreshIndicatorColor;
  final Color? refreshBackgroundColor;
  final double? refreshStrokeWidth;
  final double? refreshDisplacement;
  final EdgeInsets loadingMorePadding;
  final String? loadingMoreMessage;

  const AppScrollConfig({
    this.loadMoreThreshold = 0.9,
    this.scrollPhysics = AppScrollPhysicsType.bouncing,
    this.refreshIndicatorColor,
    this.refreshBackgroundColor,
    this.refreshStrokeWidth,
    this.refreshDisplacement,
    this.loadingMorePadding = const EdgeInsets.symmetric(
      vertical: AppDesignSystem.spaceXl,
    ),
    this.loadingMoreMessage,
  });
}

/// Configurações de layout da lista
class AppListLayoutConfig {
  final EdgeInsets padding;
  final Clip clipBehavior;
  final bool shrinkWrap;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final Decoration? decoration;
  final double separatorHeight;
  final double separatorWidth;

  const AppListLayoutConfig({
    this.padding = const EdgeInsets.only(
      top: AppDesignSystem.spaceMd,
      bottom: AppDesignSystem.spaceXl,
      left: AppDesignSystem.spaceSm,
      right: AppDesignSystem.spaceSm,
    ),
    this.clipBehavior = Clip.antiAlias,
    this.shrinkWrap = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent = 500.0,
    this.decoration,
    this.separatorHeight = AppDesignSystem.spaceSm,
    this.separatorWidth = 0.0,
  });
}

/// Configurações de animação
class AppListAnimationConfig {
  final bool enableItemAnimation;
  final int animationDuration;
  final int staggerDelay;
  final Curve animationCurve;

  const AppListAnimationConfig({
    this.enableItemAnimation = true,
    this.animationDuration = 300,
    this.staggerDelay = 50,
    this.animationCurve = Curves.easeOutBack,
  });
}

/// Tipos de física de scroll
enum AppScrollPhysicsType {
  bouncing,
  clamping,
  never,
  platform,
}
