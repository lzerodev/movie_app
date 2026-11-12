# Revisão do estado do projeto — 12/11/2026

Revisão local antes de implementar novas funcionalidades. Consultar também [ARCHITECTURE.md](ARCHITECTURE.md), [ROADMAP.md](ROADMAP.md) e [BUILD_TOOLCHAIN.md](BUILD_TOOLCHAIN.md).

## Estado funcional

| Parte | Confirmado no código/configuração | Pendências |
| --- | --- | --- |
| Flutter | Features, BLoC, cliente HTTP com base TMDB e suíte local com 80 testes aprovados após a correção abaixo | API própria e validação visual em execução |
| NestJS | `GET /api/v1/health`, prefixo versionado, teste HTTP; auth/users/favorites reservados | Driver/conexão PostgreSQL, migrations, identidade e favoritos |
| Infraestrutura | Dockerfile, Compose com PostgreSQL e modelo de produção com Caddy | Execução dos containers, persistência real, HTTPS e recuperação |
| Entrega | Workflows locais de Flutter e backend/infra | Conferir CI remoto, publicar imagem e provisionar/deploy AWS |

O healthcheck confirma o processo HTTP, não o banco. PostgreSQL no Compose não comprova que a API já o utiliza.

## Verificações da revisão inicial

- Dart/Flutter MCP: `frontend/` registrada como raiz; configuração local seleciona o Dart do Flutter fixado em 3.50.0.
- Análise estática pelo MCP: `No errors`.
- Suíte Flutter pelo MCP: **67 testes passaram e 13 falharam**, em `test/widgets/home_responsive_test.dart`, mesma contagem do registro anterior. O log inclui DI não inicializada e falhas de tooltip/tickers; é necessário diagnosticar as causas isoladamente antes de atribuí-las à aplicação ou ao teste.
- Backend: tipos, build TypeScript e teste HTTP aprovados, executados diretamente com Node e compilador local. **1 teste HTTP passou**.
- O comando padrão `npm` falhou nesta sessão procurando `npm-cli.js` no prefixo do usuário. Nenhuma instalação global foi alterada. Os scripts usuais precisam de revalidação depois do diagnóstico; as verificações diretas acima passaram.
- Docker CLI não conseguiu acessar o daemon. Sem build/execução de containers ou teste real de PostgreSQL nesta revisão.
- Builds APK/web não foram repetidos. Resultados anteriores permanecem em `BUILD_TOOLCHAIN.md`.
- Sem teste em aparelho, inspeção visual do app, hot reload, execução remota de CI ou deploy nesta revisão.

## Git e governança

O trabalho foi encontrado em `develop`, com reorganização e toolchain ainda locais. Criada **`feature/monorepo-foundation`** no mesmo commit para seguir o Gitflow. Todas as alterações locais acompanham a branch; isso não isola o trabalho em outro diretório nem prepara a divisão dos commits.

O guia de contribuição e o template de PR já existiam, mas continham tags por feature e integração direta. Foram alinhados ao monorepositório e ao `AGENTS.md`. Há mensagens antigas fora da convenção; o histórico foi preservado.

Sem staging, commit, push, merge ou tag. Proteções remotas não foram verificadas. Nenhum lint automático de commits/PR foi instalado.

## Próxima sequência sugerida

1. Revisar a reorganização pendente e preparar conjuntos coerentes antes de qualquer commit; incluir arquivos novos e exclusões na revisão sem expor segredos.
2. Corrigir os testes de widgets, começando pelas dependências e isolando as demais falhas de layout/animação.
3. Diagnosticar npm e disponibilizar Docker para validar containers.
4. Seguir o roadmap: persistência/migrations em banco descartável, depois identidade e favoritos.
5. Conferir checks/proteções remotas e CI antes da integração. AWS e lojas são etapas posteriores.

A sequência foi a recomendação da revisão inicial. A correção dos testes descrita abaixo foi realizada em seguida; persistência, autenticação e favoritos continuam pendentes.

## Correção dos testes de widgets — 12/11/2026

Os 13 testes da Home foram corrigidos mantendo todos os cenários. Agora usam o `MovieApp` real (tema, localização e navegação), inicialização de datas em português, DI preparada e um caso de uso simulado com um filme sem imagens remotas. Não carregam `.env` nem fazem chamadas ao TMDB. A view do teste tem dimensões e densidade coerentes; não se limita a informar um tamanho artificial ao `MediaQuery` mantendo constraints de outro dispositivo.

Os widgets são desmontados e as dimensões da view restauradas entre testes. A validação de menu deixou de ser condicional à existência do botão: sua ausência agora falha. Navegar de volta para Home também verifica que o carregamento não é repetido. O teste de tela pequena percorre notificações e perfil, incluindo acesso ao último cartão das notificações.

A execução com viewport real expôs e motivou três correções no aplicativo:

- `app_page_layout.dart`: título da AppBar limitado à largura disponível, em uma linha com ellipsis.
- `movie_list_item.dart`: nota e data usam `Wrap` para acomodar a largura estreita, preservando seus conteúdos.
- `home.dart`: notificações permitem rolagem vertical em telas baixas.

### Resultado posterior à correção

- Testes direcionados da Home pelo MCP: **13 passaram**.
- Suíte completa pelo MCP, depois do último ajuste no teste: **80 passaram, zero falhas**.
- Análise estática pelo MCP: **sem apontamentos**.
- Os quatro arquivos Dart alterados foram formatados com o Dart do Flutter 3.50.0.
- Nenhum teste foi desativado, pulado ou teve exceções de renderização ignoradas.
- DTD conectado ao workspace do VS Code com Dart 3.14.0; nenhum aplicativo em execução foi encontrado. **Sem hot reload/hot restart, teste em aparelho ou inspeção visual do app.**
- Não houve nova validação de backend, Docker, builds APK/web ou CI remoto nesta correção. Os resultados da revisão inicial continuam identificados acima.

As falhas históricas em `BUILD_TOOLCHAIN.md` e `REORGANIZATION.md` descrevem suas respectivas execuções anteriores; este registro documenta a resolução local posterior. Trabalho mantido em `feature/monorepo-foundation`, sem staging, commit, push, merge ou tag.

O próximo passo sugerido é diagnosticar npm/Docker e validar containers antes de implementar persistência e migrations. CI remoto e revisão visual ainda precisam de execução própria.

## Consolidação local do Git — 12/11/2026

A pedido do usuário, as alterações acumuladas foram organizadas em commits locais na branch `feature/monorepo-foundation`: movimentações do monorepositório, atualização/correções do frontend, API/infraestrutura e documentação das regras. As afirmações anteriores de ausência de commits descrevem os momentos anteriores desta revisão.

As 220 movimentações foram registradas com os blobs originais antes das edições posteriores, preservando a leitura do histórico como renomeações. A atualização do frontend inclui a toolchain, as adaptações de Dart e os quatro arquivos envolvidos na correção validada pelos 80 testes. O conteúdo funcional desses arquivos não foi alterado nesta consolidação.

O exemplo `frontend/lib/core/utils/secrets.dart.example` tinha um valor sensível não apropriado para versionamento: foi substituído por `YOUR_TMDB_API_KEY`. Sua cópia original permanece em `work/git-review/`, ignorada pelo Git; `.env` e `secrets.dart` reais foram preservados e continuam ignorados. A revisão automatizada do conteúdo preparado não encontrou os padrões de credenciais pesquisados; isso não constitui auditoria exaustiva de segredos ou do histórico anterior.

Foram removidos espaços ao final de linhas do script PowerShell de screenshots e do exemplo sanitizado; a sintaxe do script foi validada sem executá-lo. Quebras Markdown históricas do README do frontend foram preservadas na movimentação. Nenhuma configuração do VS Code foi incluída: atalhos e caminhos específicos da máquina permanecem locais.

Não houve push, PR, merge, tag, deploy ou publicação. Esta organização de commits não comprova execução de containers, CI remoto ou disponibilidade em produção.

## Marca RTM — 12/11/2026

Nome curto: **RTM**. Nome completo: **RTM (Rate That Movie)**. A marca foi centralizada em `AppConstants` e aplicada à Home, ao título Flutter e ao diálogo Sobre. Os metadados visíveis de Android, iOS, macOS, Windows, Linux e web foram atualizados; o produto macOS inclui referências do bundle e do host de testes coerentes com `RTM.app`.

A API usa o nome de pacote e identificador de serviço `rtm-api`; o teste HTTP acompanha essa mudança. O pacote Dart `movie_app`, IDs de aplicação/bundle, caminho do repositório e namespaces de infraestrutura são identificadores técnicos preservados. Nomes em documentação histórica continuam representando sua época.

- Hot restart aplicado com sucesso ao app Windows conectado ao MCP; o usuário confirmou a marca RTM na captura posterior. O título nativo da janela exige recompilar e executar novamente.
- Testes direcionados da Home: 13 aprovados, incluindo título RTM e diálogo Sobre. A abertura do diálogo expôs overflow em suas linhas de informações; rótulo e valor agora respeitam a largura disponível.
- Backend: checagem de tipos, build e 1 teste HTTP aprovados após a mudança.
- JSON, XML, plist e scheme alterados foram validados localmente. Nenhuma execução em Android/iOS/macOS/Linux foi afirmada.
- Redesign do cabeçalho e remoção da busca duplicada são uma entrega separada, solicitada em seguida.
