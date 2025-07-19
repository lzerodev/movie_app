# 📷 Guia Rápido de Captura de Screenshots

## 🚀 Execução Rápida

### **📱 Android (Recomendado)**
```bash
# 1. Conecte um dispositivo Android ou inicie emulador
# 2. Execute o app
flutter run --release -d android

# 3. Execute o script de captura
bash capture_screenshots.sh
```

### **🍎 iOS Simulator**
```bash
# 1. Inicie o iOS Simulator
# 2. Execute o app
flutter run --release -d ios

# 3. Execute o script de captura
bash capture_screenshots.sh
```

### **🌐 Web/Chrome**
```bash
# 1. Execute o app no Chrome
flutter run --release -d chrome

# 2. Siga as instruções do script
bash capture_screenshots.sh
```

### **🪟 Windows PowerShell**
```powershell
# Execute o script PowerShell
.\capture_screenshots.ps1
```

---

## 📋 Lista de Screenshots Necessários

### **📱 Telas Principais**
1. **home_screen.png** - Tela principal com navegação por abas
2. **movie_list.png** - Lista de filmes com design moderno  
3. **search_screen.png** - Interface de pesquisa com resultados
4. **movie_detail.png** - Tela de detalhes com SliverAppBar
5. **profile_screen.png** - Seção de perfil do usuário
6. **notifications_screen.png** - Centro de notificações

### **🎬 GIFs de Animações**
7. **animations_demo.gif** - Demonstração das animações gerais
8. **hero_animation.gif** - Hero animation entre lista e detalhes
9. **hover_effects.gif** - Efeitos de hover nos cards
10. **search_demo.gif** - Demonstração da busca em tempo real

---

## 🛠️ Ferramentas por Plataforma

### **📱 Mobile Screenshots**
- **Android**: `adb shell screencap` (automático via script)
- **iOS**: `xcrun simctl io booted screenshot` (automático via script)

### **🌐 Web Screenshots**
- **Chrome DevTools**: F12 → Device Mode → Screenshot
- **Firefox**: F12 → Responsive Design Mode → Screenshot

### **🎬 GIFs de Animação**

#### **Windows**
- **ScreenToGif** (https://www.screentogif.com/)
  - Gratuito, leve, muitas opções
  - Recomendado para Windows

#### **macOS**
- **Kap** (https://getkap.co/)
  - Gratuito, interface limpa
  - Boa qualidade de compressão

#### **Cross-Platform**
- **LICEcap** (https://www.cockos.com/licecap/)
  - Funciona em Windows/macOS/Linux
  - Interface simples, boa para demos rápidos

---

## 🎨 Configurações Recomendadas

### **📐 Dimensões**
- **Mobile**: 375x812px (iPhone X/11/12 padrão)
- **Tablet**: 768x1024px (iPad padrão)

### **🎯 Qualidade**
- **DPI**: 2x (Retina) mínimo
- **Formato**: PNG para screenshots, GIF para animações
- **Compressão**: Use TinyPNG após captura

### **⏱️ GIFs**
- **Duração**: 3-10 segundos máximo
- **FPS**: 10-15 FPS (suficiente para demos)
- **Tamanho**: Máximo 10MB por GIF

---

## 📝 Processo Passo a Passo

### **Preparação**
1. ✅ Execute `flutter clean && flutter pub get`
2. ✅ Inicie o app em modo release
3. ✅ Navegue pelas telas principais
4. ✅ Teste animações e transições

### **Captura de Screenshots**
1. 📱 Execute um dos scripts de captura
2. 🎯 Siga as instruções na tela
3. ✅ Verifique qualidade de cada imagem
4. 🔄 Refaça se necessário

### **Captura de GIFs**
1. 🎬 Abra ferramenta de GIF (ScreenToGif/Kap/LICEcap)
2. 📍 Posicione área de captura sobre o app
3. 🎭 Execute animações/transições
4. ⏹️ Pare a gravação após 3-10 segundos
5. 🗜️ Otimize antes de salvar

### **Otimização**
1. 🖼️ Comprima PNGs com TinyPNG
2. 🎬 Otimize GIFs (reduzir cores se necessário)
3. 📏 Verifique tamanhos dos arquivos
4. ✅ Confirme qualidade visual

### **Finalização**
1. 🗑️ Remova arquivo `.gitkeep`
2. 📤 Adicione arquivos ao git
3. 💬 Faça commit descritivo
4. 🚀 Push para repositório

---

## 🚨 Solução de Problemas

### **Android**
- **Erro "adb not found"**: Instale Android SDK Platform Tools
- **Erro "no devices"**: Conecte dispositivo ou inicie emulador
- **Erro "unauthorized"**: Aceite depuração USB no dispositivo

### **iOS**
- **Erro "xcrun not found"**: Instale Xcode Command Line Tools
- **Erro "no simulator"**: Inicie iOS Simulator primeiro

### **Web**
- **Tela muito pequena**: Use Device Mode no DevTools
- **Baixa qualidade**: Aumente zoom antes de capturar
- **Elementos cortados**: Ajuste viewport no DevTools

---

## ✅ Checklist Final

### **📁 Arquivos Criados**
- [ ] home_screen.png
- [ ] movie_list.png
- [ ] search_screen.png
- [ ] movie_detail.png
- [ ] profile_screen.png
- [ ] notifications_screen.png
- [ ] animations_demo.gif

### **🔍 Qualidade**
- [ ] Todas as imagens são nítidas
- [ ] Tamanhos adequados (< 1MB PNG, < 10MB GIF)
- [ ] Demonstram funcionalidades principais
- [ ] Consistência visual entre screenshots

### **📤 Versionamento**
- [ ] Arquivo .gitkeep removido
- [ ] Screenshots adicionados ao git
- [ ] Commit feito com mensagem descritiva
- [ ] Push realizado para repositório

---

**🎬 Pronto para criar screenshots incríveis do Movie App!**
