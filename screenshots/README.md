# 📷 Screenshots do Movie App

Esta pasta contém as capturas de tela e demonstrações visuais do aplicativo.

## 📋 Screenshots Necessários

### 📱 Telas Principais

- [ ] `home_screen.png` - Tela principal com navegação por abas
- [ ] `movie_list.png` - Lista de filmes com design moderno
- [ ] `search_screen.png` - Interface de pesquisa com resultados
- [ ] `movie_detail.png` - Tela de detalhes com SliverAppBar
- [ ] `profile_screen.png` - Seção de perfil do usuário
- [ ] `notifications_screen.png` - Centro de notificações

### 🎬 Animações e Demonstrações

- [ ] `animations_demo.gif` - Demonstração das animações e transições
- [ ] `hero_animation.gif` - Hero animations entre telas
- [ ] `hover_effects.gif` - Efeitos de hover nos cards
- [ ] `search_demo.gif` - Demonstração da busca em tempo real

## 📐 Especificações Técnicas

### **Dimensões Recomendadas**

- **Mobile Portrait**: 400x800px ou similar (9:16)
- **Mobile Landscape**: 800x400px ou similar (16:9)
- **Tablet**: 768x1024px ou similar (3:4)

### **Formatos de Arquivo**

- **Screenshots**: PNG (melhor qualidade para UI)
- **Animações**: GIF (máximo 10MB)
- **Demonstrações longas**: MP4 convertido para GIF

### **Qualidade e Otimização**

- **Resolução**: Mínimo 2x (Retina/DPI alto)
- **Compressão**: Use ferramentas como TinyPNG
- **Tamanho máximo**: 1MB por screenshot, 10MB por GIF

## 🛠️ Ferramentas Recomendadas

### **Para Screenshots**

- **Android**: `adb shell screencap` ou Android Studio
- **iOS**: Simulator → Device → Screenshot
- **Desktop**: Print Screen ou Snipping Tool
- **Web**: DevTools → Device Mode → Screenshot

### **Para GIFs/Animações**

- **LICEcap** (cross-platform)
- **ScreenToGif** (Windows)
- **Kap** (macOS)
- **Peek** (Linux)

### **Para Edição**

- **GIMP** (gratuito, cross-platform)
- **Figma** (web-based)
- **Canva** (templates prontos)

## 📱 Guia de Captura

### **1. Preparação**

```bash
# Execute o app em modo release para melhor performance
flutter run --release

# Para web, use modo release também
flutter run -d chrome --release
```

### **2. Configurações de Captura**

- **Dispositivo**: Use simuladores/emuladores para consistência
- **Tema**: Capture nos modos claro e escuro (se houver)
- **Dados**: Use dados de exemplo realistas
- **Estado**: Capture diferentes estados (loading, erro, vazio, sucesso)

### **3. Composição Visual**

- **Enquadramento**: Mostre a tela completa sem cortes
- **Foco**: Destaque as funcionalidades principais
- **Contexto**: Inclua elementos que ajudem a entender a funcionalidade
- **Consistência**: Mantenha o mesmo dispositivo/tema nas capturas

## 🎨 Diretrizes de Design

### **Elementos a Destacar**

- ✨ **Animações fluidas** - Transições e hover effects
- 🎭 **Design System** - Cores, tipografia e espaçamentos
- 🎬 **Hero animations** - Transições entre telas
- 🔍 **Funcionalidades** - Pesquisa, scroll infinito, detalhes
- 📱 **Responsividade** - Diferentes tamanhos de tela

### **Estados a Capturar**

- **Loading**: Indicadores de carregamento
- **Sucesso**: Dados carregados corretamente
- **Erro**: Tratamento de erros
- **Vazio**: Estados sem dados
- **Interação**: Hover, focus, seleção

## 📝 Nomeação de Arquivos

### **Padrão de Nomenclatura**

```
[categoria]_[descrição]_[estado?].[extensão]

Exemplos:
- home_screen.png
- movie_list_loading.png
- search_results_empty.png
- detail_hero_animation.gif
- profile_dark_theme.png
```

### **Organização**

```
screenshots/
├── mobile/          # Screenshots mobile
├── tablet/          # Screenshots tablet
├── desktop/         # Screenshots desktop
├── animations/      # GIFs e demonstrações
└── themes/          # Diferentes temas
```

## 🚀 Automação (Opcional)

### **Script de Screenshot Automático**

```bash
#!/bin/bash
# Exemplo de script para captura automática

# Mobile screenshots
flutter run --release -d ios
sleep 5
xcrun simctl io booted screenshot home_screen.png

# Android screenshots
flutter run --release -d android
sleep 5
adb shell screencap -p /sdcard/movie_list.png
adb pull /sdcard/movie_list.png
```

### **Integration Tests com Screenshots**

```dart
// Exemplo usando flutter_driver para capturas automáticas
testWidgets('Home screen screenshot', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  // Capture screenshot
  await binding.convertFlutterSurfaceToImage();
});
```

---

**💡 Dica**: Mantenha este README atualizado conforme você adiciona novos screenshots!
