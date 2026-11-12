#!/bin/bash
# 📷 Script de Captura Automática de Screenshots - Movie App
# 
# Este script automatiza a captura de screenshots das principais telas do app
# Certifique-se de ter o app rodando antes de executar

set -e

echo "🎬 Iniciando captura de screenshots do Movie App..."

# Diretório de screenshots
SCREENSHOTS_DIR="screenshots"
mkdir -p "$SCREENSHOTS_DIR"

# Função para capturar screenshot no Android
capture_android() {
    local filename=$1
    local description=$2
    
    echo "📱 Capturando: $description"
    adb shell screencap -p "/sdcard/$filename"
    adb pull "/sdcard/$filename" "$SCREENSHOTS_DIR/$filename"
    adb shell rm "/sdcard/$filename"
    echo "✅ Salvo: $SCREENSHOTS_DIR/$filename"
}

# Função para capturar screenshot no iOS Simulator
capture_ios() {
    local filename=$1
    local description=$2
    
    echo "📱 Capturando: $description"
    xcrun simctl io booted screenshot "$SCREENSHOTS_DIR/$filename"
    echo "✅ Salvo: $SCREENSHOTS_DIR/$filename"
}

# Função para capturar screenshot no Chrome (Web)
capture_web() {
    local filename=$1
    local description=$2
    
    echo "🌐 Capturando: $description"
    echo "💡 Use DevTools -> Device Mode -> Screenshot para capturar manualmente"
    echo "   Salve como: $SCREENSHOTS_DIR/$filename"
}

# Detectar plataforma e capturar screenshots
echo "🔍 Detectando dispositivos disponíveis..."

# Verificar se há dispositivo Android conectado
if adb devices | grep -q "device$"; then
    echo "📱 Android detectado - Iniciando capturas..."
    
    echo "⏳ Aguarde 3 segundos para navegar para cada tela..."
    
    echo "1️⃣ Capture a tela principal (Home) - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "home_screen.png" "Tela Principal com navegação"
    
    echo "2️⃣ Navegue para a lista de filmes - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "movie_list.png" "Lista de filmes com design moderno"
    
    echo "3️⃣ Abra a pesquisa e digite algo - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "search_screen.png" "Interface de pesquisa"
    
    echo "4️⃣ Abra os detalhes de um filme - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "movie_detail.png" "Tela de detalhes com SliverAppBar"
    
    echo "5️⃣ Navegue para o perfil - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "profile_screen.png" "Seção de perfil do usuário"
    
    echo "6️⃣ Navegue para notificações - Pressione Enter quando estiver pronto"
    read -p ""
    capture_android "notifications_screen.png" "Centro de notificações"

elif command -v xcrun >/dev/null 2>&1 && xcrun simctl list devices | grep -q "Booted"; then
    echo "📱 iOS Simulator detectado - Iniciando capturas..."
    
    echo "⏳ Aguarde 3 segundos para navegar para cada tela..."
    
    echo "1️⃣ Capture a tela principal (Home) - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "home_screen.png" "Tela Principal com navegação"
    
    echo "2️⃣ Navegue para a lista de filmes - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "movie_list.png" "Lista de filmes com design moderno"
    
    echo "3️⃣ Abra a pesquisa e digite algo - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "search_screen.png" "Interface de pesquisa"
    
    echo "4️⃣ Abra os detalhes de um filme - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "movie_detail.png" "Tela de detalhes com SliverAppBar"
    
    echo "5️⃣ Navegue para o perfil - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "profile_screen.png" "Seção de perfil do usuário"
    
    echo "6️⃣ Navegue para notificações - Pressione Enter quando estiver pronto"
    read -p ""
    capture_ios "notifications_screen.png" "Centro de notificações"

else
    echo "🌐 Nenhum dispositivo móvel detectado - Instruções para Web:"
    echo ""
    echo "1. Abra o app no Chrome com: flutter run -d chrome --release"
    echo "2. Abra DevTools (F12)"
    echo "3. Ative Device Mode (Ctrl+Shift+M)"
    echo "4. Selecione 'iPhone 12 Pro' ou similar"
    echo "5. Para cada tela, use o botão screenshot no DevTools"
    echo ""
    capture_web "home_screen.png" "Tela Principal"
    capture_web "movie_list.png" "Lista de filmes"
    capture_web "search_screen.png" "Interface de pesquisa"
    capture_web "movie_detail.png" "Tela de detalhes"
    capture_web "profile_screen.png" "Seção de perfil"
    capture_web "notifications_screen.png" "Centro de notificações"
fi

echo ""
echo "🎉 Captura de screenshots concluída!"
echo "📁 Arquivos salvos em: $SCREENSHOTS_DIR/"
echo ""
echo "📋 Próximos passos:"
echo "1. 🔍 Verifique a qualidade das imagens"
echo "2. 🎬 Capture GIFs das animações com LICEcap ou ScreenToGif"
echo "3. 🗜️ Otimize as imagens com TinyPNG se necessário"
echo "4. 🗑️ Remova o arquivo .gitkeep"
echo "5. 📤 Faça commit das novas imagens"
echo ""
echo "✨ Screenshots do Movie App prontos para o mundo!"
