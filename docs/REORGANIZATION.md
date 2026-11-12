# Reorganização do monorepositório — 11/11/2026

> Este registro descreve a etapa inicial de reorganização. Depois dela, a cadeia Flutter/Android e as APIs Dart foram atualizadas; consulte [BUILD_TOOLCHAIN.md](BUILD_TOOLCHAIN.md) para versões e resultados atuais.

## Alterações

- Aplicativo Flutter, plataformas, fontes, assets, testes, screenshots e scripts de captura movidos para `frontend/`.
- O README anterior do app foi preservado em `frontend/README.md`; o README da raiz orienta o monorepositório.
- Documentação histórica do Flutter antes espalhada na raiz foi movida para `docs/flutter-history/`.
- Criados API NestJS mínima em `backend/`, Dockerfile e arquivos de infraestrutura em `infra/`.
- Workflow Flutter ajustado para `frontend/`, configuração fictícia de CI e novos caminhos de coverage/APK. Actions de upload atualizadas para versões suportadas.
- Criado workflow do backend para instalação reproduzível, tipos, teste HTTP, build da imagem e validação Compose. Não publica imagens nem faz deploy.
- Scripts de screenshots agora resolvem o destino a partir da própria localização.

## Preservação

A branch de trabalho foi mantida em `develop`. Nenhum commit ou push foi feito. Os dois arquivos locais inicialmente não rastreados foram movidos junto com `lib/` e mantiveram seu conteúdo.

Foram registrados hashes de 215 arquivos antes da movimentação. Após a reorganização, os únicos conteúdos alterados desse conjunto foram README e os dois scripts de screenshots. Código Dart, testes, fontes, assets, configurações de plataformas e lockfile foram preservados.

O `.env` local foi apenas movido para `frontend/`, sem leitura de seu conteúdo. `.env` e `secrets.dart` continuam ignorados pelo Git. O exemplo local de configuração que já existia não foi sanitizado ou sobrescrito; revisar exemplos antes de versionar.

Caches e arquivos gerados com caminhos anteriores foram preservados em `work/previous-generated/` para permitir regeneração no novo diretório. `work/` é ignorado pelo Git. Essa pasta não é necessária para executar o projeto.

## Verificações locais

| Verificação | Resultado |
| --- | --- |
| Preservação dos arquivos versionados e hashes do Flutter | Aprovada |
| `flutter pub get --offline`, em `frontend/` | Aprovada |
| `flutter analyze --no-pub` | Sem apontamentos |
| `flutter build web --no-pub` | Build concluído |
| `flutter test --no-pub --reporter expanded` | 67 testes passaram; 13 falharam |
| `dart format --output=none --set-exit-if-changed lib test` | 43 dos 74 arquivos requerem formatação; nenhum foi reformatado |
| `npm run typecheck`, em `backend/` | Aprovada |
| `npm test` | Build e teste HTTP aprovados |
| `npm audit --omit=dev` | 0 vulnerabilidades conhecidas reportadas |
| `docker compose ... config --quiet`, local e produção | Configurações válidas com variáveis fictícias |
| YAML dos workflows, diretórios, contextos de build e mounts | Verificados |
| Sintaxe dos scripts de screenshots PowerShell/Bash | Verificada; scripts não executados |
| Regras de ignore para ambientes, dependências e builds | Verificadas |
| `git diff --check`, considerando CRLF dos arquivos existentes | Aprovada |

Os testes de widgets existentes apresentaram falhas de layout e animação, incluindo erros relacionados a `TooltipState` e tickers. O código Dart e os testes foram preservados por hash, mas não foi executada uma segunda suíte em um checkout da estrutura antiga. As falhas e a formatação exigem uma entrega própria; não foram ocultadas ou desabilitadas no CI.

## Limites

- Docker CLI instalado, porém o motor Linux do Docker Desktop estava indisponível. Build e execução dos containers, persistência real do PostgreSQL e HTTPS não foram validados localmente.
- Workflows foram inspecionados localmente; não houve execução no GitHub Actions.
- Não foram compilados APK, iOS ou aplicativos desktop, nem realizados testes em dispositivos reais.
- Não houve provisionamento AWS, configuração de domínio, publicação em registry, deploy ou alteração nas lojas.
- API possui somente liveness HTTP. Autenticação, favoritos, banco/migrations, integração Flutter/API, backups e restauração permanecem no roteiro.

Versões locais utilizadas: Flutter 3.24.2, Dart 3.5.2, Node.js 24.21.0 e npm 11.2.0.
