# Diagnóstico do editor e revisão de pendências — 12/11/2026

## Dependências e avisos de assets

O log do VS Code vinha de `work/buildchain-baseline/frontend`, uma cópia histórica com `intl ^0.19.0` e sem os assets/arquivo de ambiente do app. Ela estava sendo descoberta como outro projeto Flutter no workspace. O app atual, em `frontend/`, já usa `intl ^0.20.3`, compatível com o SDK fixado, e seus assets existem.

Foi adicionada a exclusão `dart.analysisExcludedFolders: ["work"]` à configuração local do VS Code, preservando os ajustes de SDK e Java existentes. A extensão Dart instalada confirma que essa opção também exclui pastas da descoberta de projetos. Os arquivos da cópia histórica não foram alterados.

Para compartilhar a configuração sem caminhos absolutos de SDK, foi criado `rtm.code-workspace`. Abra esse arquivo no VS Code ao trabalhar com este monorepositório. A configuração de máquina em `.vscode/settings.json` continua ignorada pelo Git. A exclusão se restringe aos artefatos de trabalho; os diagnósticos do frontend permanecem ativos.

## Revisão dos três TODOs do código atual

| Pendência | Resultado |
| --- | --- |
| Navegação das opções do perfil | Cada opção tem callback próprio; Favoritos abre a aba existente, Configurações permite selecionar o tema, Ajuda explica as funções disponíveis e Sobre abre os dados do app. Removido o snackbar que simulava navegação. |
| Histórico e Sair demonstrativos | Retirados da interface atual. Histórico depende de definir o registro de visualizações; Sair pertence à entrega futura de autenticação. Não há sessão autenticada para encerrar hoje. |
| getMovieDetails dependia de um repositório legado inexistente | Implementado diretamente no adaptador Dio usando `/movie/{id}`, com validação de ID, conversão de resposta e tratamento de falhas. A chave pode ser fornecida por uma função injetada nos testes, sem ler credenciais reais. |

## Backlog preservado

Login/cadastro/saída autenticada, favoritos persistentes, reviews/comentários, trailers, compartilhamento público e séries/temporadas/episódios continuam no plano de produto. Não foram removidos do roadmap por terem saído de comentários TODO. Histórico de visualizações continua uma proposta futura, fora das telas funcionais atuais.

O método de detalhes foi implementado no contrato de repositório e testado com HTTP simulado. A tela existente continua recebendo o modelo pela navegação Hero; esta manutenção não adiciona uma requisição extra ao tocar no pôster nem valida o endpoint em produção.

## Verificação

- `pub get` executado no frontend atual com sucesso.
- Painel Problemas do VS Code observado com a mensagem “Não foi detectado nenhum problema no workspace”.
- 92 testes passaram, incluindo seis novos casos do repositório e a interação real com configurações/ajuda do perfil.
- SDK fixado preservado, sem atualização indiscriminada de dependências.
- Hot restart confirmado no Windows. Sem publicação ou validação em aparelho móvel.
