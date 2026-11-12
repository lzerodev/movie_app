# 🎬 Movie App - Flutter

Um aplicativo de filmes desenvolvido em Flutter seguindo **Clean Architecture** com padrão **BLoC** para gerenciamento de estado e **Result Pattern** para tratamento de erros.

## 📱 Funcionalidades

- ✅ **Lista de filmes em cartaz** - Exibe filmes atualmente nos cinemas
- ✅ **Pesquisa de filmes** - Busca em tempo real com throttling
- ✅ **Scroll infinito** - Carregamento automático de mais conteúdo
- ✅ **Detalhes do filme** - Informações completas de cada filme
- ✅ **Interface responsiva** - Otimizada para diferentes tamanhos de tela
- ✅ **Configuração segura** - API keys protegidas
- ✅ **Arquitetura escalável** - Preparada para novas features
- ✅ **Testes abrangentes** - Cobertura completa com testes unitários
- ✨ **Interface moderna** - Design System consistente com animações

## 📱 Screenshots

### **🏠 Tela Principal**

<div align="center">
  <img src="screenshots/home_screen.png" alt="Tela Principal" width="300"/>
  <p><em>Navegação principal com abas e lista de filmes em cartaz</em></p>
</div>

### **🎬 Lista de Filmes**

<div align="center">
  <img src="screenshots/movie_list.png" alt="Lista de Filmes" width="300"/>
  <p><em>Interface moderna com gradientes e animações fluidas</em></p>
</div>

### **🔍 Pesquisa de Filmes**

<div align="center">
  <img src="screenshots/search_screen.png" alt="Pesquisa de Filmes" width="300"/>
  <p><em>Busca em tempo real com throttling e resultados instantâneos</em></p>
</div>

### **📄 Detalhes do Filme**

<div align="center">
  <img src="screenshots/movie_detail.png" alt="Detalhes do Filme" width="300"/>
  <p><em>SliverAppBar expansível com informações completas e animações</em></p>
</div>

### **👤 Perfil do Usuário**

<div align="center">
  <img src="screenshots/profile_screen.png" alt="Perfil do Usuário" width="300"/>
  <p><em>Seção de perfil com opções personalizadas e cards estilizados</em></p>
</div>

### **🔔 Notificações**

<div align="center">
  <img src="screenshots/notifications_screen.png" alt="Notificações" width="300"/>
  <p><em>Centro de notificações com cards informativos e badges coloridos</em></p>
</div>

### **🎭 Animações e Transições**

<div align="center">
  <img src="screenshots/animations_demo.gif" alt="Demonstração de Animações" width="300"/>
  <p><em>Hero animations, hover effects e transições suaves entre telas</em></p>
</div>

> **📷 Como adicionar screenshots:**
>
> 1. Crie uma pasta `screenshots/` na raiz do projeto
> 2. Capture as telas do app em diferentes dispositivos
> 3. Salve as imagens com nomes descritivos
> 4. Para GIFs de animação, use ferramentas como LICEcap ou ScreenToGif
> 5. Mantenha as imagens otimizadas (máximo 1MB cada)

## 🎨 Design System & Interface

### **Redesign da Lista de Filmes**

A interface foi completamente redesenhada com foco na experiência do usuário:

#### **🎭 Visual Enhancements**

- **Gradientes suaves** - Background com transições de cor elegantes
- **Sombras dinâmicas** - Elevação visual que responde ao hover
- **Bordas consistentes** - Sistema unificado de bordas e raios
- **Animações fluidas** - Transições suaves entre estados

#### **🌟 Animações e Interações**

- **Hover effects** - Escala e brilho no hover dos cards
- **Hero animations** - Transições cinematográficas entre telas
- **Entrada escalonada** - Items aparecem progressivamente
- **Feedback tátil** - Resposta visual a todas as interações

#### **🏷️ Sistema de Badges**

- **Avaliações com gradiente** - Badges coloridos para notas dos filmes
- **Labels de qualidade** - "Excelente", "Muito Bom", "Bom", etc.
- **Ícones contextuais** - Estrelas, calendário e informações visuais
- **Container estilizado** - Para sinopses e informações extras

#### **📐 Layout Moderno**

```dart
// Exemplo do novo MovieListItem
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [cardColor, cardColor.withOpacity(0.8)],
    ),
    boxShadow: isHovered ? accentShadow : defaultShadow,
  ),
  child: AnimatedBuilder(
    animation: scaleAnimation,
    builder: (context, child) => Transform.scale(
      scale: scaleAnimation.value,
      child: MovieContent(),
    ),
  ),
)
```

#### **🎯 Design System Expandido**

```dart
class AppDesignSystem {
  // Cores de borda para cards
  static const Color cardBorderColor = Color(0xFF3A3A4E);
  static const Color cardBorderHoverColor = Color(0xFF4A4A5E);
  static const Color noBorderColor = Colors.transparent;

  // Gradientes
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, cardColor],
  );
}
```

## 🏗️ Arquitetura

### Clean Architecture + BLoC Pattern + Result Pattern + Dependency Injection

```
lib/
├── core/                    # 🧱 Fundação da aplicação
│   ├── error/              # ⚠️ Sistema de erros unificado
│   │   ├── failure.dart         # 💥 Classes de falha
│   │   └── result.dart          # 🎯 Result Pattern
│   ├── usecases/           # 🎯 Abstrações de casos de uso
│   ├── utils/              # 🛠️ Utilitários e configurações
│   │   ├── secure_config.dart    # 🔐 Configuração segura
│   │   ├── app_constants.dart    # 📋 Constantes da app
│   │   └── theme.dart           # 🎨 Sistema de temas
│   ├── network/            # 🌐 Cliente HTTP centralizado
│   ├── widgets/            # 🧩 Widgets reutilizáveis
│   ├── extensions/         # 🔧 Extensões utilitárias
│   ├── routing/            # 🗺️ Sistema de navegação
│   └── di/                 # 💉 Injeção de dependências
│       ├── dependency_injection.dart  # 🏭 Container DI
│       └── di_extensions.dart         # 🔌 Extensões BLoC
├── features/
│   ├── home/               # 🏠 Tela principal
│   ├── movie/              # 🎬 Feature de filmes
│   │   ├── data/           # 📊 Fontes de dados e repositórios
│   │   │   ├── models/          # 🏷️ Modelos de dados
│   │   │   ├── datasources/     # 🌐 APIs e fontes remotas
│   │   │   └── repositories/    # 📦 Implementação de repositórios
│   │   ├── domain/         # 🧠 Entidades e casos de uso
│   │   │   ├── entities/        # 📝 Entidades de negócio
│   │   │   ├── repositories/    # 🔗 Contratos de repositórios
│   │   │   └── usecases/        # ⚙️ Casos de uso específicos
│   │   └── presentation/   # 🖼️ UI e gerenciamento de estado
│   │       ├── bloc/            # 🏛️ BLoCs modernos
│   │       ├── pages/           # 📄 Telas da aplicação
│   │       └── widgets/         # 🧩 Widgets específicos
│   └── profile/            # 👤 Perfil do usuário
└── test/                   # 🧪 Testes unitários
    ├── features/
    │   └── movie/
    │       ├── domain/usecases/     # 🧪 Testes de UseCases
    │       └── presentation/bloc/  # 🧪 Testes de BLoCs
```

## 🎯 Padrões Arquiteturais Implementados

### **Result Pattern**

Sistema type-safe para tratamento de erros sem exceptions:

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

// Uso com pattern matching
switch (result) {
  case Success(:final data):
    // Sucesso - use os dados
  case Error(:final failure):
    // Erro - trate a falha
}
```

### **Clean Architecture - Camadas**

#### **Domain Layer** 🧠

```dart
// UseCase Pattern
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

// Exemplo: SearchMoviesUseCase
class SearchMoviesUseCase implements UseCase<List<Movie>, SearchMoviesParams> {
  final IMovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(SearchMoviesParams params) async {
    // Validações de negócio
    if (params.query.trim().isEmpty) {
      return const Error(ValidationFailure(message: 'Query de pesquisa não pode estar vazia'));
    }

    // Delegação para repositório
    return await repository.searchMovies(params.query, params.page);
  }
}
```

#### **Data Layer** 📊

```dart
// Repository Pattern
class MovieRepository implements IMovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Movie>>> searchMovies(String query, int page) async {
    try {
      final movies = await remoteDataSource.searchMovies(query, page);
      return Success(movies);
    } catch (e) {
      return Error(NetworkFailure(message: e.toString()));
    }
  }
}
```

#### **Presentation Layer** 🖼️

```dart
// BLoC com Clean Architecture
class MovieModernBloc extends Bloc<MovieModernEvent, MovieModernState> {
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final SearchMoviesUseCase _searchMoviesUseCase;

  @override
  Future<void> _onSearchRequested(
    MovieModernSearchRequested event,
    Emitter<MovieModernState> emit,
  ) async {
    emit(state.copyWith(status: MovieModernStatus.loading));

    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: event.query, page: 1),
    );

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          status: MovieModernStatus.success,
          movies: data,
        ));
      case Error(:final failure):
        emit(state.copyWith(
          status: MovieModernStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
```

### **Dependency Injection** 💉

Sistema centralizado para gerenciamento de dependências:

```dart
class DependencyInjection {
  static GetIt get sl => GetIt.instance;

  static Future<void> setup() async {
    // Network
    sl.registerLazySingleton<Dio>(() => createDio());

    // DataSources
    sl.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSource(sl()),
    );

    // Repositories
    sl.registerLazySingleton<IMovieRepository>(
      () => MovieRepository(sl()),
    );

    // UseCases
    sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetNowPlayingMoviesUseCase(sl()));
  }

  // Factory methods para BLoCs
  static MovieModernBloc createMovieModernBloc() {
    return MovieModernBloc(
      searchMoviesUseCase: sl(),
      getNowPlayingMoviesUseCase: sl(),
    );
  }
}
```

## 🧪 Testes Unitários

### Estratégia de Testes

- **27 testes implementados** com cobertura completa
- **Frameworks**: `flutter_test`, `bloc_test`, `mocktail`
- **Padrões**: Arrange-Act-Assert, Given-When-Then
- **Mocking**: Isolamento completo das dependências

### **Testes de UseCases** (19 testes)

#### SearchMoviesUseCase (9 testes)

```dart
group('SearchMoviesUseCase', () {
  blocTest<SearchMoviesUseCase, Result<List<Movie>>>(
    'deve retornar lista de filmes quando a busca for bem-sucedida',
    // Testa integração com repositório
    // Valida transformação de dados
    // Verifica Result Pattern
  );

  test('deve retornar ValidationFailure quando query estiver vazia', () {
    // Testa validações de negócio
    // Verifica mensagens de erro específicas
  });

  test('deve retornar NetworkFailure quando repositório falhar', () {
    // Testa cenários de falha
    // Valida propagação de erros
  });
});
```

#### GetNowPlayingMoviesUseCase (10 testes)

```dart
group('GetNowPlayingMoviesUseCase', () {
  test('deve retornar lista de filmes em cartaz quando bem-sucedida', () {
    // Testa busca padrão
    // Valida paginação
  });

  test('deve retornar ValidationFailure quando page for menor que 1', () {
    // Testa validação de página
    // Verifica limites de entrada
  });
});
```

### **Testes de BLoC** (8 testes)

#### MovieModernBloc

```dart
group('MovieModernBloc', () {
  blocTest<MovieModernBloc, MovieModernState>(
    'deve buscar filmes com sucesso',
    build: () {
      when(() => mockGetNowPlayingMoviesUseCase(any()))
          .thenAnswer((_) async => Success(movieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const MovieModernNowPlayingFetched()),
    expect: () => [
      const MovieModernState(status: MovieModernStatus.loading),
      isA<MovieModernState>()
          .having((s) => s.status, 'status', MovieModernStatus.success)
          .having((s) => s.movies.length, 'movies length', 2),
    ],
  );

  blocTest<MovieModernBloc, MovieModernState>(
    'deve buscar filmes por query',
    // Testa mode de busca
    // Valida throttling
    // Verifica estados intermediários
  );
});
```

### **Ferramentas de Teste**

#### Mocking com Mocktail

```dart
// Mocks dos UseCases
class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}
class MockGetNowPlayingMoviesUseCase extends Mock implements GetNowPlayingMoviesUseCase {}

// Fakes para registerFallbackValue
class FakeSearchMoviesParams extends Fake implements SearchMoviesParams {}

setUpAll(() {
  registerFallbackValue(FakeSearchMoviesParams());
});
```

#### BLoC Testing

```dart
blocTest<MovieModernBloc, MovieModernState>(
  'descrição do teste',
  build: () => bloc,
  seed: () => estadoInicial,
  act: (bloc) => bloc.add(evento),
  expect: () => [estadosEsperados],
  verify: (_) => verificaçõesAdicionais,
);
```

### **Executar Testes**

```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/features/movie/domain/
flutter test test/features/movie/presentation/bloc/

# Com coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### **Métricas de Qualidade**

- ✅ **27/27 testes passando** (100%)
- ✅ **Cobertura de UseCases**: Completa
- ✅ **Cobertura de BLoC**: Estados e eventos
- ✅ **Mocking**: Dependências isoladas
- ✅ **Result Pattern**: Cenários de sucesso e falha
- ✅ **Validações**: Regras de negócio testadas

````

#### **UseCase Pattern**
```dart
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

abstract class NoParamsUseCase<Type> {
  Future<Result<Type>> call();
}
````

#### **Dependency Injection**

```dart
class DependencyInjection {
  static Future<void> setup() async { /* ... */ }
  static T get<T extends Object>() { /* ... */ }
}
```

### 🧱 Camadas Implementadas

#### Core ✅

- **Exceptions**: `ServerException`, `NetworkException`, `ValidationException`
- **Failures**: `ServerFailure`, `NetworkFailure`, `ValidationFailure`
- **UseCases**: Abstrações para casos de uso com Result Pattern
- **Utils**: Configuração segura, constantes, temas
- **Network**: Cliente HTTP com interceptadores
- **Widgets**: Componentes reutilizáveis (`AppLoadingWidget`, `AppErrorWidget`)
- **Extensions**: Extensões para String, double, BuildContext
- **Routing**: Sistema de navegação centralizado
- **DI**: Injeção de dependências simplificada

#### Features

##### Home ✅

- Navegação principal
- Interface com abas (Home, Notificações, Perfil)
- Carrosséis promocionais

##### Movie ✅

- **Data Layer**:
  - ✅ Modelos de dados
  - ✅ Repositório da API TMDB
  - ✅ Tratamento de requisições HTTP
- **Domain Layer**:
  - ✅ Entidades de filme
  - ✅ Casos de uso (busca e listagem)
  - ✅ Observador de BLoC
- **Presentation Layer**:
  - ✅ Movie BLoC (estado reativo)
  - ✅ Tela de filmes em cartaz
  - ✅ Tela de pesquisa com debounce
  - ✅ Widgets reutilizáveis

## 🔧 Tecnologias Utilizadas

### Framework & Linguagem

- **Flutter** 3.24.2
- **Dart** 3.4.4+

### Gerenciamento de Estado

- **flutter_bloc** 8.1.6 - Implementação do padrão BLoC
- **bloc** 8.1.0 - Core do BLoC
- **bloc_concurrency** 0.2.5 - Throttling e concorrência
- **stream_transform** 2.1.0 - Transformações de stream
- **equatable** 2.0.3 - Comparação de objetos

### Rede & APIs

- **dio** 5.5.0+1 - Cliente HTTP robusto
- **flutter_dotenv** 5.1.0 - Variáveis de ambiente

### Dependency Injection

- **get_it** 7.7.0 - Service locator pattern
- **provider** 6.1.2 - Injeção de dependências na UI

### Testes

- **flutter_test** - Framework de testes do Flutter
- **bloc_test** 9.1.7 - Testes específicos para BLoC
- **mocktail** 1.0.4 - Mocking moderno para Dart
- **test** 1.25.8 - Core de testes

### UI & UX

- **flutter_svg** 2.0.10+1 - Suporte a SVG
- **intl** 0.19.0 - Internacionalização

### 🎨 Design & Animações

- **Material Design 3** - Sistema de design moderno
- **AnimationController** - Animações personalizadas e fluidas
- **Hero Widgets** - Transições cinematográficas entre telas
- **Transform.scale** - Animações de escala responsivas ao hover
- **BoxShadow** - Sistema de sombras dinâmicas
- **LinearGradient** - Gradientes suaves para profundidade visual
- **PageRouteBuilder** - Transições customizadas entre páginas
- **AnimatedBuilder** - Reconstrução otimizada de animações
- **BorderRadius** - Sistema unificado de bordas arredondadas
- **InkWell** - Feedback tátil com efeito ripple
- **ClipRRect** - Recortes precisos para imagens e containers

### Desenvolvimento

- **bloc_test** 9.0.0 - Testes de BLoC
- **mockito** 5.4.4 - Mocks para testes
- **flutter_test** - Testes unitários

## 🚀 Como Executar

### Pré-requisitos

- Flutter 3.24.2 ou superior
- Dart 3.4.4 ou superior
- API Key do TMDB

### Configuração

1. **Clone o repositório**

```bash
git clone https://github.com/lzerodev/movie_app.git
cd movie_app
```

2. **Instale as dependências**

```bash
flutter pub get
```

3. **Configure a API Key** (Escolha uma opção):

   **Opção A: Arquivo .env (Recomendado)**

   ```bash
   # Crie o arquivo .env na raiz do projeto
   TMDB_API_KEY=sua_chave_api_aqui
   ```

   **Opção B: Arquivo secrets.dart**

   ```bash
   # Copie o template
   cp lib/core/utils/secrets.dart.example lib/core/utils/secrets.dart
   # Edite o arquivo e adicione sua API key
   ```

4. **Execute o aplicativo**

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Desktop
flutter run -d windows  # ou macos/linux
```

## 🔒 Segurança

### API Key Protection

- ✅ **Ambiente de desenvolvimento**: Arquivo `.env` (ignorado pelo Git)
- ✅ **Fallback seguro**: Arquivo `secrets.dart` (ignorado pelo Git)
- ✅ **Validação**: Verificação automática de configuração
- ✅ **Documentação**: Templates para novos desenvolvedores

### Arquivos Sensíveis (Gitignore)

```
.env
secrets.dart
api_keys.dart
```

## 📋 Funcionalidades Detalhadas

### 🏠 Tela Principal

- **AppBar** customizada com logo e pesquisa
- **Navegação inferior** com 3 abas
- **Carrosséis** promocionais
- **Lista de filmes** em exibição

### 🔍 Sistema de Pesquisa

- **Busca em tempo real** com debounce de 500ms
- **Validação de entrada** (mínimo 2 caracteres)
- **Estados visuais**: loading, erro, vazio, resultados
- **Interface responsiva** para diferentes dispositivos

### 🎭 Lista de Filmes

- **Scroll infinito** com paginação automática
- **Tratamento de erros** de rede
- **Loading states** informativos
- **Transições suaves** entre estados

### 🎨 Interface

- **Material Design 3** com tema customizado
- **Fonte Poppins** em todas as variações
- **Cores consistentes** seguindo design system
- **Animações fluidas** com duração personalizada
- **Widgets reutilizáveis** (`AppLoadingWidget`, `AppErrorWidget`, `AppEmptyWidget`)

### 🛠️ Arquitetura Avançada

- **Result Pattern** para tratamento de erros type-safe
- **UseCase Pattern** para isolamento de regras de negócio
- **Dependency Injection** para inversão de controle
- **Clean Architecture** com separação clara de responsabilidades
- **SOLID Principles** aplicados em toda a base de código
- **Extension Methods** para código mais limpo e reutilizável

### 🔧 Sistema Core

- **ApiClient** centralizado com interceptadores Dio
- **SecureConfig** para proteção de API keys
- **AppConstants** para constantes organizadas
- **Custom Exceptions** tipadas por domínio
- **Failure Pattern** para tratamento consistente de erros
- **Roteamento** centralizado com animações customizadas

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/search_controller_test.dart

# Testes com cobertura
flutter test --coverage
```

### Cobertura de Testes

- ✅ Casos de uso (SearchController)
- ✅ Widgets principais
- ⏳ BLoCs (em desenvolvimento)
- ⏳ Repositórios (em desenvolvimento)

## 📦 Build

### Android

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web
```

### Desktop

```bash
# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## 🐛 Debugging

### Hot Reload

```bash
# Durante execução, pressione:
r  # Hot reload
R  # Hot restart
q  # Quit
```

### DevTools

O Flutter DevTools está disponível em: `http://localhost:9101`

## 📈 Roadmap

### ✅ Arquitetura Implementada (v1.0)

- [x] **Clean Architecture** com separation of concerns
- [x] **Result Pattern** para tratamento de erros
- [x] **UseCase Pattern** para casos de uso
- [x] **Dependency Injection** centralizada
- [x] **Custom Exceptions** e Failures
- [x] **Core Widgets** reutilizáveis
- [x] **Sistema de Temas** completo
- [x] **Roteamento** centralizado
- [x] **API Client** com interceptadores
- [x] **Extensões** utilitárias
- [x] **Testes Unitários** completos (27 testes)
- [x] **MovieModernBloc** com Clean Architecture
- [x] **SearchMoviesUseCase** e **GetNowPlayingMoviesUseCase**
- [x] **Repository Pattern** implementado
- [x] **Mocking Strategy** com mocktail

### 🎯 Status do Projeto

✅ **Clean Architecture** - Implementação completa  
✅ **Testes Unitários** - 27 testes com 100% de sucesso  
✅ **Result Pattern** - Sistema type-safe de erros  
✅ **BLoC Pattern** - Estados reativos modernos  
✅ **Dependency Injection** - Sistema centralizado

### 🚀 Próximas Funcionalidades

- [ ] **Cache offline** de filmes favoritos
- [ ] **Modo escuro** automático
- [ ] **Compartilhamento** de filmes
- [ ] **Notificações** de novos lançamentos
- [ ] **Filtros avançados** (gênero, ano, avaliação)
- [ ] **Histórico de pesquisas**
- [ ] **Perfil de usuário** com preferências
- [ ] **Testes de integração** e widget
- [ ] **CI/CD pipeline** automatizada

### 🔧 Melhorias Técnicas Planejadas

- [ ] **Integration Tests** para fluxos completos
- [ ] **Widget Tests** para componentes UI
- [ ] **Golden Tests** para validação visual
- [ ] **CI/CD pipeline** com GitHub Actions
- [ ] **Analytics** de uso e performance
- [ ] **Crash reporting** automatizado
- [ ] **Performance monitoring** em produção
- [ ] **Code Coverage** 90%+ com lcov

## 🎯 Como Executar

### Pré-requisitos

- Flutter 3.24.2+
- Dart 3.4.4+
- API Key do TMDB

### Instalação

```bash
# Clone o repositório
git clone https://github.com/lzerodev/movie_app.git
cd movie_app

# Instale as dependências
flutter pub get

# Configure as variáveis de ambiente
cp .env.example .env
# Edite .env com sua API key do TMDB

# Execute os testes
flutter test

# Execute o app
flutter run
```

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes específicos da Clean Architecture
flutter test test/features/movie/domain/
flutter test test/features/movie/presentation/bloc/

# Testes com cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📋 Changelog

### v2.1.0 - Documentação Visual (2025-01-19)

#### 📷 Screenshots e Documentação

- **📱 Seção de Screenshots** adicionada ao README

  - Layout organizado para todas as telas principais
  - Orientações detalhadas para captura de imagens
  - Estrutura de pastas preparada para screenshots
  - Guias de dimensões e qualidade de imagem

- **📋 Documentação Expandida**
  - README detalhado para pasta screenshots/
  - Especificações técnicas para capturas
  - Ferramentas recomendadas para criação de GIFs
  - Scripts de automação para screenshots

### v2.0.0 - Design System & Interface Moderna (2025-01-19)

#### ✨ Novas Features

- **🎨 Redesign completo da lista de filmes**

  - Interface moderna com gradientes e animações
  - Hover effects com escala e sombras dinâmicas
  - Badges de avaliação com gradientes coloridos
  - Labels de qualidade automáticas baseadas na nota

- **🎭 Sistema de Animações**

  - Hero animations para transições entre telas
  - Animações de entrada escalonada para items da lista
  - Transform.scale responsivo ao hover
  - PageRouteBuilder com slide transitions

- **🏷️ Design System Expandido**
  - Cores de borda unificadas (cardBorderColor, cardBorderHoverColor)
  - Sistema de cores transparentes (noBorderColor)
  - Gradientes padronizados para consistência visual
  - AppCard component com suporte a bordas customizadas

#### 🐛 Correções

- Eliminação de bordas visuais indesejadas nos movie cards
- Unificação de cores entre seções poster e informações
- Correção de espaçamentos inconsistentes

#### ⚡ Performance

- Otimização de loading para imagens de filmes
- AnimatedBuilder para reconstrução eficiente
- Uso de const constructors onde possível

### v1.0.0 - Arquitetura Base (2025-01-18)

#### ✨ Features Iniciais

- **🏗️ Clean Architecture** com camadas bem definidas
- **🧪 Result Pattern** para tratamento type-safe de erros
- **🏛️ BLoC Pattern** moderno com throttling
- **💉 Dependency Injection** com GetIt
- **🎬 Funcionalidades core**:
  - Lista de filmes em cartaz
  - Pesquisa com debounce
  - Scroll infinito
  - Detalhes do filme
- **🧪 Testes abrangentes** - 27 testes unitários

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Siga os padrões da Clean Architecture implementada
4. Escreva testes unitários para suas funcionalidades
5. Commit suas mudanças (`git commit -m 'feat: adiciona nova feature'`)
6. Push para a branch (`git push origin feature/nova-feature`)
7. Abra um Pull Request

### Padrões de Commit

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `test:` Adição ou modificação de testes
- `refactor:` Refatoração de código
- `docs:` Documentação

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🏆 Conquistas do Projeto

- 🎯 **Clean Architecture** completa implementada
- 🧪 **27 testes unitários** com 100% de sucesso
- � **Result Pattern** para tratamento type-safe de erros
- 🏛️ **BLoC Pattern** moderno com throttling
- 💉 **Dependency Injection** centralizada
- 🎨 **UI responsiva** e componentes reutilizáveis
- 📱 **Funcionalidades core** implementadas e testadas

## �🙏 Agradecimentos

- **The Movie Database (TMDB)** pela API de filmes
- **Flutter Team** pelo framework excepcional
- **BLoC Library** pelos padrões de estado reativo
- **Comunidade Flutter** pelas melhores práticas

---

**Desenvolvido usando Flutter**
