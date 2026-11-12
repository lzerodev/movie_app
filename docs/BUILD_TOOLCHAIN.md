# Cadeia de build — atualização de 11/11/2026

## Versões escolhidas

| Componente | Base anterior | Base atual |
| --- | --- | --- |
| Flutter | 3.24.2 | 3.50.0, release estável fixada em `.flutter-version` |
| Dart | 3.5.2 | 3.14.0, incluído no Flutter |
| Gradle wrapper | 7.6.3 | 9.5.0, distribuição `bin` com SHA-256 verificado |
| Android Gradle Plugin | 7.3.0 | 9.3.1, padrão do Flutter 3.50.0 |
| Kotlin Android | Plugin externo 1.7.10 | Kotlin integrado ao AGP; plugin externo removido |
| JVM que executa Gradle | Java 26, incompatível com Gradle 7.6.3 | Java 26, suportado por Gradle 9.5.0 |
| Bytecode Java/Kotlin | Java 8 | Java 17 |
| compileSdk / targetSdk | Defaults do Flutter anterior | API 36 |
| minSdk | Default do Flutter anterior | API 24 — Android 7.0 |

Não confundir a JVM que executa o Gradle com o alvo de compilação. Gradle pode rodar com Java 26 e gerar bytecode Java/Kotlin 17. O Android processa esse bytecode durante o build; isso não exige Java 26 instalado no aparelho.

As versões foram escolhidas a partir das constantes e templates da tag oficial Flutter `3.50.0`, commit `ab2912035e160d9cad6306df307576da6128ebdb`, e da matriz oficial de compatibilidade do Gradle. O `Kotlin` exibido por `gradlew --version` pertence ao Gradle; não é a versão do compilador Kotlin Android controlado pelo AGP.

## Configuração local no Windows

Foi instalado um SDK separado em `C:\Frameworks\flutter-3.50.0`. O SDK antigo em `C:\Frameworks\flutter` foi preservado. A tag fixa pode aparecer como canal `[user-branch]` no comando de versão; o código é o da release estável selecionada.

O arquivo local `.vscode/settings.json` seleciona o novo SDK, aponta a importação Gradle para `C:\Program Files\Java\jdk-26.0.1` e define o ambiente de novos terminais integrados. Esse arquivo é ignorado pelo Git porque contém caminhos específicos da máquina. A configuração de build server do usuário foi preservada.

No VS Code, execute **Developer: Reload Window** e abra um **novo terminal**. Um terminal que já estava aberto pode continuar usando o PATH antigo.

Na pasta `frontend/`, confira:

```powershell
flutter --version
flutter doctor -v
```

Se o PowerShell fora do VS Code ainda resolver o SDK antigo, use o caminho explícito ou configure seu ambiente para o SDK fixado:

```powershell
& 'C:\Frameworks\flutter-3.50.0\bin\flutter.bat' --version
```

O `frontend/android/local.properties` local aponta para o novo SDK Flutter. Esse arquivo é gerado e não versionado. Em outro computador, instale Flutter 3.50.0, JDK 26, Android SDK Platform 36 e Build Tools 36.0.0; execute os comandos abaixo para gerar a configuração local. O NDK usado é o padrão do SDK Flutter, atualmente `28.2.13676358`.

O JDK 17 portátil baixado durante o diagnóstico inicial continua em `work/toolchains/jdk-17`, mas não é selecionado por esta configuração e não é necessário para o build escolhido.

## Executar e verificar

Na raiz do repositório, selecione o Java para a sessão se necessário. Não é preciso alterar o Java global do Windows:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-26.0.1'
cd frontend
& 'C:\Frameworks\flutter-3.50.0\bin\flutter.bat' pub get
& 'C:\Frameworks\flutter-3.50.0\bin\flutter.bat' analyze --no-pub
& 'C:\Frameworks\flutter-3.50.0\bin\flutter.bat' test --no-pub
& 'C:\Frameworks\flutter-3.50.0\bin\flutter.bat' build apk --debug --no-pub
```

Para conferir apenas a combinação Gradle/JVM:

```powershell
cd frontend/android
./gradlew.bat --version
```

## Adaptações do projeto

- Gradle e AGP foram atualizados em conjunto. `android.builtInKotlin=true` e `android.newDsl=true` habilitam as APIs atuais; o plugin Kotlin Android externo foi removido.
- Diretórios de build usam `layout.buildDirectory`. Versão e código do app são lidos pela extensão Flutter.
- O Dart exige agora 3.14 e o Flutter exige 3.50. O pacote `intl` foi atualizado para atender ao SDK de localização.
- Imports de Material e Cupertino foram migrados para os pacotes oficiais separados `material_ui` e `cupertino_ui`.
- Temas usam `CardThemeData` e `DialogThemeData`; opacidade usa `withValues(alpha: ...)`; cache de scroll usa `ScrollCacheExtent.pixels`.
- Foram aplicadas adaptações indicadas pelo analisador e a formatação do Dart atual. Não foram adicionadas funcionalidades de produto.
- O pacote Dart continua `movie_app`; namespace e application ID Android continuam `com.example.movie_app`.
- Os seis jobs Flutter do CI selecionam Flutter 3.50.0 e Java 26. Não houve execução remota do workflow.

## Resultados e limites

- Gradle 9.5.0 iniciou com Java 26.0.1 no Windows.
- Dependências resolvidas e lockfile atualizado.
- Análise estática: sem apontamentos após as adaptações.
- Testes Flutter: 67 passaram, 13 falharam em `test/widgets/home_responsive_test.dart`. A contagem corresponde à verificação anterior da reorganização; essas falhas não foram ocultadas ou desabilitadas no CI.
- `dart format --output=none --set-exit-if-changed .`: 74 arquivos verificados, nenhuma alteração pendente.
- `flutter build apk --debug --no-pub`: aprovado. Gerado `frontend/build/app/outputs/flutter-apk/app-debug.apk`.
- Manifesto do APK inspecionado com `aapt`: application ID `com.example.movie_app`, versão `1.1.0+2`, minSdk 24 e target/compileSdk 36.
- SHA-256 do APK de debug desta execução: `1B742C9DFE46DC99FF515CE9A382A7A625BD98B3CAC561C2B8D0F2560370F5F7`.
- `flutter build web --no-pub`: aprovado; saída em `frontend/build/web/`. A compilação incluiu a verificação de compatibilidade Wasm do SDK, sem execução em navegador.
- `flutter doctor -v` confirmou SDK Android 36 e Java 26.0.1. Ainda reporta algumas licenças Android não aceitas; para revisar os termos, executar `flutter doctor --android-licenses` usando o novo SDK. As licenças disponíveis permitiram a compilação do APK realizada aqui.

O APK foi compilado localmente, não instalado ou executado em aparelho/emulador. O build de release e a execução dos workflows no GitHub não foram validados nesta entrega. A configuração local de credenciais não foi exposta em logs; o formatador Dart também processou arquivos Dart ignorados, sem alterar seus valores.

O aumento de `minSdk` para 24 reduz a faixa de aparelhos suportados. Revisão visual e execução em emulador/aparelho continuam necessárias. Assinatura de release e application ID definitivos ainda precisam ser preparados antes de publicar nas lojas. A configuração de release existente usa a chave de debug e não caracteriza um aplicativo pronto para distribuição pública.

Não houve commit, push, deploy AWS ou publicação nas lojas nesta atualização.

## Referências

- [Flutter 3.50: versões padrão e migração de UI](https://flutter.dev/blog/whats-new-in-flutter-3-50)
- [Migração de aplicativos para Kotlin integrado](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers)
- [Matriz Java/Gradle](https://docs.gradle.org/current/userguide/compatibility.html)
