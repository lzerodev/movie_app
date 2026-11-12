# 📷 Exemplo Prático de Captura

## 🎯 Método Manual Recomendado

### **1. Execute o App**

```bash
cd "c:\lm-repos\movie_app"
flutter run --release -d chrome
```

### **2. Configure o Chrome DevTools**

1. Pressione **F12** para abrir DevTools
2. Pressione **Ctrl+Shift+M** para Device Mode
3. Selecione **iPhone 12 Pro** (375 x 812)
4. Defina zoom para **100%**

### **3. Capture Screenshots de Cada Tela**

#### **🏠 Home Screen**

1. Navegue para a tela principal
2. Pressione **Ctrl+Shift+P**
3. Digite: "Capture screenshot"
4. Selecione: "Capture full size screenshot"
5. Salve como: `screenshots/home_screen.png`

#### **🎬 Movie List**

1. Certifique-se de que a lista de filmes está visível
2. Capture screenshot conforme acima
3. Salve como: `screenshots/movie_list.png`

#### **🔍 Search Screen**

1. Clique no ícone de pesquisa
2. Digite "batman" ou outro filme
3. Aguarde resultados aparecerem
4. Capture screenshot
5. Salve como: `screenshots/search_screen.png`

#### **📄 Movie Detail**

1. Clique em qualquer filme da lista
2. Aguarde a tela de detalhes carregar
3. Role um pouco para mostrar mais conteúdo
4. Capture screenshot
5. Salve como: `screenshots/movie_detail.png`

#### **👤 Profile Screen**

1. Clique na aba "Perfil" na navegação inferior
2. Capture screenshot
3. Salve como: `screenshots/profile_screen.png`

#### **🔔 Notifications**

1. Clique na aba "Notificações" na navegação inferior
2. Capture screenshot
3. Salve como: `screenshots/notifications_screen.png`

### **4. Remover .gitkeep e Fazer Commit**

```bash
# Remover placeholder
rm screenshots/.gitkeep

# Adicionar screenshots
git add screenshots/

# Commit
git commit -m "📷 feat: Adiciona screenshots das principais telas do Movie App

✨ Screenshots Incluídos:
- home_screen.png - Tela principal com navegação por abas
- movie_list.png - Lista de filmes com design moderno
- search_screen.png - Interface de pesquisa com resultados
- movie_detail.png - Tela de detalhes com SliverAppBar expansível
- profile_screen.png - Seção de perfil com opções do usuário
- notifications_screen.png - Centro de notificações com cards

📐 Especificações:
- Resolução: 375x812px (iPhone 12 Pro padrão)
- Formato: PNG otimizado para web
- Qualidade: Alta resolução para demonstração
- Consistência: Mesmo dispositivo e tema em todas as telas

🎨 Demonstra:
- Design System moderno com gradientes
- Animações e hover effects
- Interface responsiva e clean
- Funcionalidades principais do app
- Navegação intuitiva e fluxos de usuário"

# Push para repositório
git push origin main
```

---

## 🎬 Para GIFs de Animação (Opcional)

### **Ferramentas Recomendadas:**

#### **Windows: ScreenToGif**

1. Download: https://www.screentogif.com/
2. Abra ScreenToGif
3. Clique em "Recorder"
4. Posicione sobre o app
5. Grave animações (3-5 segundos)
6. Edite e otimize
7. Salve como `screenshots/animations_demo.gif`

#### **macOS: Kap**

1. Download: https://getkap.co/
2. Abra Kap
3. Selecione área do app
4. Grave animações
5. Otimize e salve

### **Animações Sugeridas:**

- **Hero Animation**: Clique em filme → detalhes
- **Hover Effects**: Mouse sobre cards na lista
- **Search Animation**: Digite na pesquisa e veja resultados
- **Navigation**: Troca entre abas

---

## ✅ Resultado Final Esperado

```
screenshots/
├── home_screen.png         (✅ Tela principal)
├── movie_list.png          (✅ Lista de filmes)
├── search_screen.png       (✅ Interface de pesquisa)
├── movie_detail.png        (✅ Detalhes do filme)
├── profile_screen.png      (✅ Perfil do usuário)
├── notifications_screen.png (✅ Notificações)
└── animations_demo.gif     (🎬 Opcional)
```

**🎬 Com estes screenshots, o README terá demonstrações visuais incríveis do Movie App!**
