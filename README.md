# 🎬 Movie App - Flutter

Um aplicativo de filmes desenvolvido em Flutter seguindo Clean Architecture e padrão BLoC para gerenciamento de estado.

## 📱 Funcionalidades

- ✅ **Lista de filmes em cartaz** - Exibe filmes atualmente nos cinemas
- ✅ **Pesquisa de filmes** - Busca em tempo real com debounce
- ✅ **Scroll infinito** - Carregamento automático de mais conteúdo
- ✅ **Detalhes do filme** - Informações completas de cada filme
- ✅ **Interface responsiva** - Otimizada para diferentes tamanhos de tela
- ✅ **Configuração segura** - API keys protegidas

## 🏗️ Arquitetura

### Clean Architecture + BLoC Pattern

```
lib/
├── core/
│   ├── error/           # Tratamento de erros
│   ├── usecases/        # Casos de uso abstratos
│   └── utils/           # Utilitários e configurações
├── features/
│   ├── home/            # Tela principal
│   ├── movie/           # Feature de filmes
│   │   ├── data/        # Fontes de dados e repositórios
│   │   ├── domain/      # Entidades e casos de uso
│   │   └── presentation/ # UI e gerenciamento de estado
│   └── profile/         # Perfil do usuário
```

### Camadas Implementadas

#### Core ✅
- **Error**: Exceptions e Failures customizados
- **Utils**: Constantes, configuração segura de API
- **Security**: Sistema de proteção de API keys

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
- **equatable** 2.0.3 - Comparação de objetos

### Rede & APIs
- **dio** 5.5.0+1 - Cliente HTTP
- **flutter_dotenv** 5.1.0 - Variáveis de ambiente

### UI & UX
- **flutter_svg** 2.0.10+1 - Suporte a SVG
- **intl** 0.19.0 - Internacionalização

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
- **Material Design 3**
- **Fonte Poppins** customizada
- **Cores consistentes** em todo o app
- **Animações fluidas**

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

### Próximas Funcionalidades
- [ ] **Cache offline** de filmes favoritos
- [ ] **Modo escuro** automático
- [ ] **Compartilhamento** de filmes
- [ ] **Notificações** de novos lançamentos
- [ ] **Filtros avançados** (gênero, ano, avaliação)
- [ ] **Histórico de pesquisas**
- [ ] **Perfil de usuário** com preferências

### Melhorias Técnicas
- [ ] **Testes de integração**
- [ ] **CI/CD pipeline**
- [ ] **Analytics** de uso
- [ ] **Crash reporting**
- [ ] **Performance monitoring**

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- **The Movie Database (TMDB)** - API de dados de filmes
- **Flutter Team** - Framework incrível
- **BLoC Library** - Gerenciamento de estado reativo

---

**Desenvolvido com ❤️ usando Flutter**








## APP Screens:

//TODO 

- [X] Movie List Screen
![Movie List Screen](https://picsum.photos/seed/picsum/200/300)


## Known issues:

 - [ ] *Fix Clean Architecture*
 - [ ] *Fix Search feature*


This Android app was built using [Flutter](https://flutter.dev/).
