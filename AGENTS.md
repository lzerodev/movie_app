# RTM (Rate That Movie)

## Estrutura e ferramentas

- `frontend/`: aplicativo Flutter com BLoC; executar comandos Flutter nessa pasta.
- `backend/`: API NestJS/TypeScript. API e backend são a mesma aplicação.
- `infra/`: Docker Compose, Caddy e preparação AWS Lightsail.
- Consultar `docs/BUILD_TOOLCHAIN.md` para as versões fixadas e `docs/ARCHITECTURE.md` para os limites atuais.
- O objetivo é estudar enquanto o projeto evolui: explicar brevemente as decisões e validar pequenas entregas.

## Flutter e Dart

- Usar o plugin oficial `dart-flutter@dart-flutter` e suas skills pertinentes quando estiverem disponíveis.
- O Dart MCP deste projeto deve usar o Dart incluído no Flutter fixado em `.flutter-version`; não usar automaticamente um SDK antigo encontrado no PATH.
- Registrar `frontend/` como raiz ao usar as ferramentas Dart/Flutter MCP.
- Para alterações funcionais em `frontend/lib/**/*.dart`, ler e aplicar a regra oficial em `.agent/rules/flutter-hot-reload.md` quando houver app de desenvolvimento em execução e MCP disponível.
- Se não houver instância em execução ou conexão MCP, informar o limite sem afirmar que houve hot reload, hot restart ou teste em aparelho.
- A regra de hot reload é do frontend; não se aplica a `backend/` ou `infra/`.
- Skills são orientação de tarefa; preservar a arquitetura e as decisões do projeto, como BLoC e o cliente HTTP existente, salvo solicitação de mudança.
- Preservar a transição Hero existente entre pôster e detalhe (`movie_<id>`) e as animações de entrada. Com abas preservadas em IndexedStack, habilitar Heroes somente na aba ativa para evitar tags duplicadas entre catálogo e busca.

## Validação

- O foco de produto é reviews, comentários e dicas sobre filmes e séries, com trailers, favoritos e links compartilháveis. Consultar `docs/PRODUCT_AND_DESIGN_PLAN.md`.
- Decisões confirmadas: leitura pública de links compartilhados (sinopse, notas e comentários), com login apenas para avaliar/comentar/favoritar; avaliações RTM em cinco estrelas com meias estrelas; avaliar séries, temporadas e episódios já no primeiro escopo. A leitura pública substitui a escolha anterior de exigir login para ler. Preservar o destino completo e a ação após login; não expor dados da conta ou rascunhos na prévia compartilhada. Separar notas de catálogo e RTM e as avaliações de cada nível da série.
- Seguir a ordem solicitada pelo usuário: organizar escopo e fluxos → desenhar design system e telas → revisar protótipo → implementar. Não tratar propostas e dados simulados de design como funcionalidades existentes ou decisões já aprovadas.
- Enquanto a etapa atual for planejamento/design, preservar as alterações funcionais anteriores e não continuar o desenvolvimento sem a transição de etapa solicitada pelo usuário.

- Diferenciar instalação/configuração, teste local, execução real no app e publicação.
- Consultar `docs/REORGANIZATION.md` e `docs/BUILD_TOOLCHAIN.md` para as falhas de testes já registradas.

## Gitflow, commits e revisão

- Seguir `CONTRIBUTING.md`: Gitflow com `main`, `develop`, `feature/*`, `release/*` e `hotfix/*`. Esses prefixos são a convenção explícita deste projeto.
- Features saem de `develop` e voltam por PR; releases saem de `develop` para `main`, com reintegração em `develop`; hotfixes de produção saem de `main` e chegam também a `develop` ou à release aberta, conforme o guia. Não desenvolver ou commitar diretamente em `main` ou `develop`.
- Antes de trocar branch, revisar `git status` e preservar trabalho local. Não descartar, fazer stash, rebasear ou incluir alterações alheias automaticamente. Não reescrever histórico ou usar force push em branches compartilhadas.
- Usar Conventional Commits nos commits autorais e títulos de PR: `tipo(escopo): descrição`. Escopos sugeridos: `frontend`, `backend`, `infra`, `docs`, `ci` ou a capacidade alterada. Indicar incompatibilidades com `!` e explicar a migração.
- Preparar commits pequenos e coerentes, selecionar arquivos/hunks explicitamente e revisar o diff staged. Não usar `git add .` indiscriminadamente, especialmente na reorganização ainda não commitada.
- Tags SemVer identificam releases verificadas; não criar tag por feature nem alterar tags publicadas para padronizar o passado.
- Não executar merge, push, tag ou publicação apenas por concluir trabalho local; seguir o escopo autorizado na tarefa.
- Documentar comportamento, decisão, verificações e limites. Não ocultar testes falhos nem declarar CI verde sem observar execução remota.
- Preservar arquitetura, contratos, segredos fora do Git e lockfiles; validar proporcionalmente à mudança. Novas ferramentas e dependências devem resolver uma necessidade concreta.
- Proteções de branch, checks obrigatórios e lint automático de commits/PR são configurações adicionais. Não afirmar que estão ativos apenas por constarem no guia; não reescrever commits antigos para adequá-los à convenção.
