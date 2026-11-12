# Flutter/Dart no Codex — 11/11/2026

## Instalação realizada

Seguido o procedimento oficial do Flutter:

```powershell
codex plugin marketplace add flutter/agent-plugins
codex plugin add dart-flutter@dart-flutter
codex plugin list --marketplace dart-flutter --json
```

Plugin confirmado instalado e habilitado: **`dart-flutter@dart-flutter` 1.0.7**, mantido pela equipe Flutter/Google. O pacote instalado contém **25 skills**: 10 Flutter e 15 Dart. A instalação é do usuário do Codex; o conteúdo do plugin não foi copiado para o código da aplicação.

## Configuração do projeto

O comando `dart` encontrado no PATH do processo Codex ainda apontava para `C:\Frameworks\flutter\bin\dart.bat`, do SDK antigo. Para este projeto, `.codex/config.toml` usa o executável Dart 3.14 do SDK Flutter 3.50.0 explicitamente e inicia o servidor com diretório de trabalho em `frontend/`.

O servidor genérico `dart-mcp-server` empacotado pelo plugin está desabilitado **somente neste projeto**. Ele é substituído pelo servidor local `dart_flutter`, para evitar duas instâncias e o uso acidental do SDK antigo. As skills e o plugin continuam habilitados.

O recurso `run_tests` foi habilitado explicitamente por argumento do Dart MCP. A configuração real contém caminhos específicos da máquina e é ignorada pelo Git. O exemplo versionável está em [.codex/config.example.toml](../.codex/config.example.toml).

Em outro computador: instalar o plugin, copiar o exemplo para `.codex/config.toml` e ajustar os caminhos para o SDK fixado em `.flutter-version` e a pasta `frontend/`.

## Regra oficial

A regra oficial foi copiada sem alterações para [.agent/rules/flutter-hot-reload.md](../.agent/rules/flutter-hot-reload.md), junto com a licença original. O arquivo [AGENTS.md](../AGENTS.md) referencia a regra e limita sua aplicação ao frontend.

Ela orienta conectar ao app de desenvolvimento e usar hot reload ou hot restart conforme a mudança. Não se aplica a alterações apenas de comentários/formatação nem ao backend. Sem app em execução ou MCP conectado, não afirmar que houve recarga ou validação visual.

## Verificação realizada

- CLI confirmou o plugin instalado e habilitado.
- Conferidos os 25 diretórios com `SKILL.md`.
- TOML local validado e servidor `dart_flutter` listado como habilitado.
- Servidor iniciado em teste independente com o Dart 3.14 e a pasta de trabalho correta.
- Handshake MCP e `tools/list` concluídos com sucesso: servidor **dart and flutter tooling 1.2.2**, 15 ferramentas, incluindo `analyze_files`, `run_tests`, `hot_reload` e `hot_restart`.
- A regra local foi comparada por hash com a original instalada.

Isso valida a instalação e a inicialização do servidor. Não houve conexão a uma aplicação em execução, hot reload, hot restart ou nova execução de testes do app nesta instalação.

## Carregar na sessão

As novas skills podem ser descobertas a partir da próxima interação. Para garantir o carregamento do plugin e do MCP, reiniciar o Codex e reabrir este projeto; uma sessão nova também deve carregar os componentes instalados. O teste de protocolo independente não confirma que o catálogo de ferramentas desta conversa já foi recarregado.

Ao usar o MCP, registrar `H:\lm-repos\movie_app\frontend` como raiz Dart/Flutter, respeitando os caminhos da máquina em uso.

## Referências

- [Instalação oficial Flutter para agentes](https://docs.flutter.dev/ai/get-started)
- [Repositório oficial do plugin](https://github.com/flutter/agent-plugins)
- [Configuração MCP no Codex](https://learn.chatgpt.com/docs/extend/mcp)
