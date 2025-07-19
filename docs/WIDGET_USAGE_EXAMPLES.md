# 🧩 Widget Usage Examples

Este documento demonstra como usar os widgets reutilizáveis implementados no Movie App v1.2.0.

## 📋 Sistema de Cards (AppCard)

### Variantes Disponíveis

```dart
// Card elevado com sombra (padrão)
AppCard.elevated(
  child: Text('Conteúdo do card'),
)

// Card primário com cor accent
AppCard.primary(
  child: Text('Card em destaque'),
)

// Card secundário com cor surface
AppCard.secondary(
  child: Text('Card suave'),
)

// Card apenas com borda
AppCard.outlined(
  child: Text('Card minimalista'),
)

// Card transparente
AppCard.minimal(
  child: Text('Card clean'),
)
```

### Tamanhos de Card

```dart
// Tamanhos pré-definidos
AppCard.small(child: widget)     // Compacto
AppCard.large(child: widget)     // Espaçoso

// Ou especificando o tamanho
AppCard(
  size: AppCardSize.xl,          // Extra grande
  child: widget,
)
```

### Cards com Interação

```dart
AppCard.elevated(
  onTap: () => print('Card tocado'),
  onLongPress: () => print('Pressão longa'),
  enableAnimation: true,
  heroTag: 'card_hero_1',
  child: widget,
)
```

### Cards Customizados

```dart
AppCard(
  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
  borderColor: Colors.blue,
  borderWidth: 2.0,
  elevation: 8.0,
  child: widget,
)
```

## 🔄 Scroll to Top Button (AppScrollToTopButton)

### Uso Básico

```dart
Stack(
  children: [
    ListView(...), // Sua lista
    AppScrollToTopButton(
      scrollController: _scrollController,
    ),
  ],
)
```

### Configurações Avançadas

```dart
AppScrollToTopButton(
  scrollController: _scrollController,
  variant: AppScrollButtonVariant.filled,    // filled, elevated, outlined, minimal
  threshold: 500.0,                          // Pixels para mostrar
  positioning: EdgeInsets.only(bottom: 100, right: 16),
  icon: Icons.keyboard_arrow_up_rounded,
  size: 48.0,
  tooltip: 'Voltar ao topo',
)
```

## 🗂️ Empty States (AppEmptyState)

### Estados Pré-configurados

```dart
// Para listas de filmes vazias
AppEmptyState.movies()

// Para resultados de busca vazios
AppEmptyState.search()

// Para listas genéricas vazias
AppEmptyState.list()

// Para favoritos vazios
AppEmptyState.favorites()

// Para erros de conexão
AppEmptyState.connection()
```

### Estados Customizados

```dart
AppEmptyState(
  icon: Icons.movie_outlined,
  title: 'Título customizado',
  subtitle: 'Descrição do estado vazio',
  actionLabel: 'Tentar novamente',
  onAction: () => _reload(),
  secondaryActionLabel: 'Configurações',
  onSecondaryAction: () => _openSettings(),
)
```

## ⏳ Loading Indicators (AppLoadingIndicator)

### Variantes de Loading

```dart
// Loading circular simples
AppLoadingIndicator()

// Loading pequeno inline
AppLoadingIndicator.inline(
  message: 'Carregando...',
)

// Loading de página inteira
AppLoadingIndicator.page(
  message: 'Preparando conteúdo...',
)

// Loading estilizado em card
AppLoadingIndicator.card(
  message: 'Carregando filmes...',
)

// Loading linear (barra)
AppLoadingIndicator(
  variant: AppLoadingVariant.linear,
  showMessage: true,
  message: 'Progresso...',
)
```

### Loading Customizado

```dart
AppLoadingIndicator(
  size: AppLoadingSize.large,
  color: Colors.blue,
  strokeWidth: 4.0,
  message: 'Processando...',
  messageStyle: TextStyle(color: Colors.grey),
)
```

## 🎨 Shimmer Effects (AppShimmerBox)

### Uso em Cards de Loading

```dart
// Placeholder para imagem
AppShimmerBox(
  width: 150,
  height: 200,
  borderRadius: BorderRadius.circular(8),
)

// Lista de placeholders
ListView.builder(
  itemCount: 5,
  itemBuilder: (context, index) => AppShimmerBox(
    height: 120,
    borderRadius: AppDesignSystem.borderRadiusMd,
  ),
)
```

## 🏗️ Exemplos de Implementação Completa

### Card de Filme Modernizado

```dart
class ModernMovieCard extends StatelessWidget {
  final Movie movie;
  
  @override
  Widget build(BuildContext context) {
    return AppCard.elevated(
      onTap: () => _navigateToDetails(movie),
      heroTag: 'movie_${movie.id}',
      child: Column(
        children: [
          Image.network(movie.posterUrl),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(movie.title),
          ),
        ],
      ),
    );
  }
}
```

### Lista com Scroll to Top

```dart
class MovieListPage extends StatefulWidget {
  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lista principal
          BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state.movies.isEmpty && state.isLoading) {
                return AppLoadingIndicator.page();
              }
              
              if (state.movies.isEmpty) {
                return AppEmptyState.movies(
                  actionLabel: 'Recarregar',
                  onAction: () => _reload(),
                );
              }
              
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.movies.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.movies.length) {
                    return AppLoadingIndicator.inline();
                  }
                  return ModernMovieCard(movie: state.movies[index]);
                },
              );
            },
          ),
          
          // Botão scroll to top
          AppScrollToTopButton(
            scrollController: _scrollController,
            variant: AppScrollButtonVariant.elevated,
          ),
        ],
      ),
    );
  }
}
```

## 🎯 Melhores Práticas

### 1. Consistência de Design
- Use sempre os widgets do sistema em vez de implementações customizadas
- Mantenha a variante de card consistente por contexto (ex: AppCard.elevated para listas)
- Use AppEmptyState.movies() especificamente para listas de filmes

### 2. Performance
- Configure cacheExtent adequadamente em listas grandes
- Use AppShimmerBox para loading states suaves
- Implemente AppScrollToTopButton em listas longas

### 3. Acessibilidade
- Forneça tooltips descritivos para botões
- Use mensagens claras em estados vazios
- Configure semantics adequadamente

### 4. Animações
- Use enableAnimation: true para interações fluidas
- Configure durações consistentes (200-300ms)
- Implemente hero animations para navegação

## 📊 Matriz de Uso por Contexto

| Contexto | Widget Recomendado | Variante | Observações |
|----------|-------------------|----------|-------------|
| Lista de filmes | AppCard.elevated | - | Com hero animation |
| Cards de notificação | AppCard.primary | - | Para destaque |
| Headers de perfil | AppCard.elevated | large | Com gradiente |
| Estatísticas | AppCard.elevated | small | Compacto |
| Lista vazia (filmes) | AppEmptyState.movies | - | Com ação reload |
| Busca sem resultado | AppEmptyState.search | - | Com dicas |
| Loading de lista | AppLoadingIndicator.inline | - | No final da lista |
| Loading de página | AppLoadingIndicator.page | - | Centro da tela |
| Scroll to top | AppScrollToTopButton | elevated | Threshold 500px |

---

**📱 App:** Movie App v1.2.0  
**📚 Docs:** Widget Usage Examples  
**📅 Atualizado:** 19 de julho de 2025