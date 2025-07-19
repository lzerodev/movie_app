# Sistema de Dependency Injection Atualizado

## 📋 Visão Geral

O sistema de Dependency Injection foi atualizado para suportar a nova arquitetura Clean Architecture com UseCases e Result Pattern.

## 🔧 Dependências Registradas

### Core
- `SecureConfig`: Configurações seguras da aplicação
- `Dio`: Cliente HTTP
- `ApiClient`: Cliente da API personalizado

### Movie Feature - Data Layer
- `IMovieRepository`: Interface moderna implementada pelo `MovieRepositoryAdapter`

### Movie Feature - Domain Layer (UseCases)
- `SearchMoviesUseCase`: Caso de uso para pesquisa de filmes
- `GetNowPlayingMoviesUseCase`: Caso de uso para filmes em cartaz

## 🚀 Como Usar

### 1. Inicialização (já configurada no main.dart)

```dart
void main() async {
  // ... outras inicializações
  
  await DependencyInjection.setup();
  
  // ... resto do código
}
```

### 2. Acessando Dependências Diretamente

```dart
// Acessar UseCases
final searchUseCase = DependencyInjection.get<SearchMoviesUseCase>();
final nowPlayingUseCase = DependencyInjection.get<GetNowPlayingMoviesUseCase>();

// Acessar repositórios
final repository = DependencyInjection.get<IMovieRepository>();
```

### 3. Factory Methods para BLoCs

#### BLoC Moderno (Recomendado)
```dart
// Criar MovieModernBloc com UseCases
final modernBloc = DependencyInjection.createMovieModernBloc();
```

### 4. Uso em Widgets com Extensões

```dart
import 'package:movie_app/core/di/di_extensions.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieModernBloc>(
      create: context.createMovieModernBloc,
      child: BlocBuilder<MovieModernBloc, MovieModernState>(
        builder: (context, state) {
          // UI logic here
        },
      ),
    );
  }
}
```

### 5. Acessar Dependências em Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Acessar diretamente uma dependência
    final repository = context.get<IMovieRepository>();
    final searchUseCase = context.get<SearchMoviesUseCase>();
    
    // Use as dependências conforme necessário
    return Container();
  }
}
```

## 🏗️ Arquitetura

```
DependencyInjection
├── Core Dependencies
│   ├── SecureConfig
│   ├── Dio
│   └── ApiClient
├── Data Layer
│   └── IMovieRepository -> MovieRepositoryAdapter
└── Domain Layer
    ├── SearchMoviesUseCase
    └── GetNowPlayingMoviesUseCase
```

## 🔄 Fluxo de Dependências

1. **Core** → **Data** → **Domain** → **Presentation**
2. **Dio** → **MovieRepositoryAdapter** → **UseCases** → **BLoCs**

## ✅ Benefícios

- **Type Safety**: Dependências fortemente tipadas
- **Testabilidade**: Fácil mock de dependências para testes
- **Desacoplamento**: Layers isoladas e independentes
- **Flexibilidade**: Fácil troca de implementações
- **Clean Architecture**: Seguindo princípios SOLID

## 📝 Próximos Passos

1. Migrar UIs para usar `MovieModernBloc`
2. Criar testes unitários para UseCases
3. Adicionar mais features seguindo o mesmo padrão
4. Considerar migração completa do repositório legado

## 🐛 Debugging

Para verificar se uma dependência está registrada:

```dart
bool isRegistered = DependencyInjection.isRegistered<SearchMoviesUseCase>();
```

Para resetar o DI (útil em testes):

```dart
DependencyInjection.reset();
```
