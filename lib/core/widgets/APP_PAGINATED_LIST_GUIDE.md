# AppPaginatedList<T> - Widget Genérico para Listas Paginadas

## 📋 Visão Geral

O `AppPaginatedList<T>` é um widget genérico altamente configurável que fornece funcionalidade completa de scroll infinito, pull-to-refresh, estados de loading/error/empty e scroll-to-top automático. É a evolução natural das implementações específicas de lista, proporcionando reutilização máxima.

## 🎯 Principais Características

### ✨ **Funcionalidades Core**
- **Genérico**: Funciona com qualquer tipo de dados `<T>`
- **Scroll Infinito**: Carregamento automático ao chegar no final
- **Pull-to-Refresh**: Gesto padrão para recarregar
- **Estados Automáticos**: Loading, Error, Empty state integrados
- **Scroll-to-Top**: Botão flutuante automático com animações
- **Separadores**: Opção de separadores customizáveis entre itens

### 🛠️ **Configurações Avançadas**
- **AppEmptyStateConfig**: Configuração completa do estado vazio
- **AppScrollConfig**: Controle total do comportamento de scroll
- **AppListLayoutConfig**: Layout, padding, performance e decorações
- **AppListAnimationConfig**: Animações de entrada dos itens

## 🚀 Uso Básico

```dart
AppPaginatedList<Movie>(
  items: movies,
  hasReachedMax: hasReachedMax,
  isLoadingMore: isLoadingMore,
  itemBuilder: (context, movie, index) {
    return MovieListItem(movie: movie);
  },
  onLoadMore: () => loadMoreMovies(),
  onRefresh: () => refreshMovies(),
)
```

## 🎨 Configurações Detalhadas

### 1. **Empty State Configuration**
```dart
emptyStateConfig: AppEmptyStateConfig(
  icon: Icons.movie_outlined,
  title: 'Nenhum filme encontrado',
  subtitle: 'Não encontramos filmes para exibir.',
  actionLabel: 'Recarregar',
  onAction: () => reload(),
  variant: AppEmptyStateVariant.movies,
  errorTitle: 'Erro de Conexão',
  errorMessage: 'Verifique sua internet e tente novamente.',
  retryButtonText: 'Tentar Novamente',
)
```

### 2. **Scroll Configuration**
```dart
scrollConfig: AppScrollConfig(
  showScrollToTop: true,
  scrollToTopPosition: EdgeInsets.only(bottom: 20, right: 20),
  scrollToTopVariant: AppScrollButtonVariant.elevated,
  scrollToTopThreshold: 500.0,
  loadMoreThreshold: 0.9, // Carrega aos 90%
  scrollPhysics: AppScrollPhysicsType.bouncing,
  refreshIndicatorColor: Colors.blue,
  loadingMoreMessage: 'Carregando mais itens...',
)
```

### 3. **Layout Configuration**
```dart
layoutConfig: AppListLayoutConfig(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(/* ... */),
  ),
  cacheExtent: 500.0,
  separatorHeight: 8.0,
  clipBehavior: Clip.antiAlias,
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
)
```

### 4. **Animation Configuration**
```dart
animationConfig: AppListAnimationConfig(
  enableItemAnimation: true,
  animationDuration: 300,
  staggerDelay: 50, // Delay entre animações dos itens
  animationCurve: Curves.easeOutBack,
)
```

## 📝 Exemplos Práticos

### 1. **Lista de Filmes (MovieListView)**
```dart
class MovieListViewNew extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieModernBloc, MovieModernState>(
      builder: (context, state) {
        return AppPaginatedList<Movie>(
          items: state.movies,
          hasReachedMax: state.hasReachedMax,
          isLoadingMore: state.status == MovieModernStatus.loading && state.movies.isNotEmpty,
          isLoading: state.status == MovieModernStatus.loading && state.movies.isEmpty,
          hasError: state.status == MovieModernStatus.failure,
          errorMessage: state.errorMessage,
          
          itemBuilder: (context, movie, index) => MovieListItem(movie: movie),
          onLoadMore: () => _handleLoadMore(state),
          onRefresh: () => _handleRefresh(),
          onRetry: () => _handleRetry(),
          
          emptyStateConfig: AppEmptyStateConfig(
            icon: Icons.movie_outlined,
            title: 'Nenhum filme encontrado',
            variant: AppEmptyStateVariant.movies,
          ),
          
          scrollConfig: AppScrollConfig(
            scrollToTopPosition: EdgeInsets.only(
              bottom: 100, // Acima da navigation bar
              left: 16,
            ),
            scrollToTopVariant: AppScrollButtonVariant.elevated,
          ),
        );
      },
    );
  }
}
```

### 2. **Lista Genérica de Usuários**
```dart
class GenericUserList extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AppPaginatedList<User>(
      items: _users,
      hasReachedMax: _hasReachedMax,
      isLoadingMore: _isLoading && _users.isNotEmpty,
      
      itemBuilder: (context, user, index) {
        return UserListItem(user: user, index: index);
      },
      
      onLoadMore: _loadMoreUsers,
      onRefresh: _handleRefresh,
      onRetry: _retryLoad,
      
      emptyStateConfig: AppEmptyStateConfig(
        icon: Icons.people_outline,
        title: 'Nenhum usuário encontrado',
        variant: AppEmptyStateVariant.list,
      ),
      
      scrollConfig: AppScrollConfig(
        scrollToTopVariant: AppScrollButtonVariant.filled,
        loadMoreThreshold: 0.8, // Carrega aos 80%
      ),
    );
  }
}
```

## 🔧 Tipos e Enums

### AppScrollPhysicsType
```dart
enum AppScrollPhysicsType {
  bouncing,   // iOS style (padrão)
  clamping,   // Android style
  never,      // Não permite scroll
  platform,   // Baseado na plataforma
}
```

### Configurações de Performance
- **cacheExtent**: 500.0 (pixels de cache extra)
- **addAutomaticKeepAlives**: true (mantém widgets na memória)
- **addRepaintBoundaries**: true (otimiza repaint)
- **addSemanticIndexes**: true (acessibilidade)

## 📈 Benefícios vs. Implementação Manual

| Aspecto | Manual | AppPaginatedList |
|---------|---------|------------------|
| **Linhas de Código** | ~180 linhas | ~30 linhas |
| **Estados de Loading** | Implementação manual | Automático |
| **Scroll-to-Top** | Código duplicado | Integrado |
| **Configurabilidade** | Limitada | Extensiva |
| **Reutilização** | Baixa | Alta |
| **Manutenção** | Complexa | Simples |
| **Consistency** | Variável | Padronizada |

## 🎯 Casos de Uso Ideais

1. **Listas de Conteúdo**: Filmes, usuários, produtos, artigos
2. **Feeds Sociais**: Posts, comentários, notificações
3. **Resultados de Busca**: Qualquer tipo de busca paginada
4. **Listas de Configuração**: Settings, opções, preferências
5. **Dashboards**: Qualquer lista com dados dinâmicos

## 🚀 Próximos Passos

Com a `AppPaginatedList<T>` implementada, ganhamos:

1. **Consistência**: Todas as listas terão comportamento uniforme
2. **Produtividade**: Desenvolvimento muito mais rápido
3. **Manutenção**: Correções e melhorias em um só lugar
4. **Escalabilidade**: Facilita adição de novas funcionalidades
5. **Performance**: Otimizações centralizadas

A próxima melhoria será o **Sistema de Navegação Padronizado** com `AppRouter` e `AppRoute` para navegação type-safe e consistente.
