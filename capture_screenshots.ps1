# 📷 Script de Captura de Screenshots - Movie App (Windows PowerShell)
# 
# Este script automatiza a captura de screenshots das principais telas do app
# Certifique-se de ter o app rodando antes de executar

Write-Host "🎬 Iniciando captura de screenshots do Movie App..." -ForegroundColor Green

# Diretório de screenshots
$ScreenshotsDir = "screenshots"
if (!(Test-Path $ScreenshotsDir)) {
    New-Item -ItemType Directory -Path $ScreenshotsDir | Out-Null
}

# Função para capturar screenshot no Android
function Capture-Android {
    param(
        [string]$Filename,
        [string]$Description
    )
    
    Write-Host "📱 Capturando: $Description" -ForegroundColor Yellow
    
    # Capturar screenshot
    adb shell screencap -p "/sdcard/$Filename"
    adb pull "/sdcard/$Filename" "$ScreenshotsDir/$Filename"
    adb shell rm "/sdcard/$Filename"
    
    Write-Host "✅ Salvo: $ScreenshotsDir/$Filename" -ForegroundColor Green
}

# Função para mostrar instruções Web
function Show-WebInstructions {
    param(
        [string]$Filename,
        [string]$Description
    )
    
    Write-Host "🌐 $Description" -ForegroundColor Cyan
    Write-Host "   💡 Salve como: $ScreenshotsDir/$Filename" -ForegroundColor Gray
}

# Detectar plataforma
Write-Host "🔍 Detectando dispositivos disponíveis..." -ForegroundColor Blue

# Verificar se há dispositivo Android conectado
$AndroidDevices = adb devices 2>$null | Select-String "device$"

if ($AndroidDevices) {
    Write-Host "📱 Android detectado - Iniciando capturas..." -ForegroundColor Green
    Write-Host "⏳ Pressione Enter para capturar cada tela quando estiver pronta..." -ForegroundColor Yellow
    
    Write-Host "`n1️⃣ Navegue para a tela principal (Home)"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "home_screen.png" "Tela Principal com navegação"
    
    Write-Host "`n2️⃣ Navegue para a lista de filmes"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "movie_list.png" "Lista de filmes com design moderno"
    
    Write-Host "`n3️⃣ Abra a pesquisa e digite algo"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "search_screen.png" "Interface de pesquisa"
    
    Write-Host "`n4️⃣ Abra os detalhes de um filme"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "movie_detail.png" "Tela de detalhes com SliverAppBar"
    
    Write-Host "`n5️⃣ Navegue para o perfil"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "profile_screen.png" "Seção de perfil do usuário"
    
    Write-Host "`n6️⃣ Navegue para notificações"
    Read-Host "Pressione Enter quando estiver pronto"
    Capture-Android "notifications_screen.png" "Centro de notificações"
    
} else {
    Write-Host "🌐 Nenhum dispositivo Android detectado - Instruções para Web:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Execute: flutter run -d chrome --release" -ForegroundColor White
    Write-Host "2. Abra DevTools (F12)" -ForegroundColor White
    Write-Host "3. Ative Device Mode (Ctrl+Shift+M)" -ForegroundColor White
    Write-Host "4. Selecione 'iPhone 12 Pro' ou similar" -ForegroundColor White
    Write-Host "5. Para cada tela, use Ctrl+Shift+P > 'Capture screenshot'" -ForegroundColor White
    Write-Host ""
    
    Show-WebInstructions "home_screen.png" "Tela Principal"
    Show-WebInstructions "movie_list.png" "Lista de filmes"
    Show-WebInstructions "search_screen.png" "Interface de pesquisa"
    Show-WebInstructions "movie_detail.png" "Tela de detalhes"
    Show-WebInstructions "profile_screen.png" "Seção de perfil"
    Show-WebInstructions "notifications_screen.png" "Centro de notificações"
}

Write-Host ""
Write-Host "🎉 Instruções de captura concluídas!" -ForegroundColor Green
Write-Host "📁 Arquivos devem ser salvos em: $ScreenshotsDir/" -ForegroundColor Blue
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. 🔍 Verifique a qualidade das imagens" -ForegroundColor White
Write-Host "2. 🎬 Capture GIFs das animações:" -ForegroundColor White
Write-Host "   - Windows: ScreenToGif (https://www.screentogif.com/)" -ForegroundColor Gray
Write-Host "   - Cross-platform: LICEcap (https://www.cockos.com/licecap/)" -ForegroundColor Gray
Write-Host "3. 🗜️ Otimize com TinyPNG (https://tinypng.com/)" -ForegroundColor White
Write-Host "4. 🗑️ Remova o arquivo .gitkeep" -ForegroundColor White
Write-Host "5. 📤 Faça commit das novas imagens" -ForegroundColor White
Write-Host ""
Write-Host "✨ Screenshots do Movie App prontos para impressionar!" -ForegroundColor Magenta
