# Guia de contribuição — I Rate That Movie

Gitflow e Conventional Commits são as convenções deste monorepositório: Flutter em `frontend/`, API NestJS em `backend/` e infraestrutura em `infra/`. Consultar [AGENTS.md](AGENTS.md), [arquitetura](docs/ARCHITECTURE.md), [toolchain](docs/BUILD_TOOLCHAIN.md), [roadmap](docs/ROADMAP.md) e [revisão atual](docs/PROJECT_STATUS.md).

## Gitflow

| Branch | Origem | Destino e propósito |
| --- | --- | --- |
| `main` | Releases aprovadas | Histórico das versões liberadas; base dos hotfixes |
| `develop` | PRs integrados | Integração da próxima versão; base das features/releases |
| `feature/<nome>` | `develop` | PR para `develop`: funcionalidade, correção de desenvolvimento, teste ou documentação |
| `release/vX.Y.Z` | `develop` | Estabilização; PR para `main` e reintegração em `develop` |
| `hotfix/<nome>` | `main` | Correção urgente de versão liberada; PR para `main` e reintegração em `develop` ou release aberta |

Não desenvolver ou commitar diretamente em `main` ou `develop`. Correções de desenvolvimento podem usar `feature/corrigir-testes-responsivos`; hotfix é reservado a urgência de produção. Usar nomes descritivos em minúsculas e separados por hífen. A existência de `main` não comprova ambiente publicado.

Com árvore limpa:

```sh
git status --short
git switch develop
git pull --ff-only origin develop
git switch -c feature/nome-da-entrega
```

Com alterações locais, revisar e preservar antes de mudar a base. Não executar reset, limpeza, stash ou rebase automaticamente. Uma branch no mesmo commit pode manter o trabalho pendente, desde que comunicado; não isola alterações já presentes no diretório.

Selecionar arquivos/hunks e revisar o staged:

```sh
git add caminho/do/arquivo
git diff --cached --check
git diff --cached
git commit -m "docs: atualizar o fluxo de contribuição"
```

Não usar `git add .` indiscriminadamente. Revisar também arquivos novos e exclusões da reorganização; o diff unstaged sozinho não mostra todo conteúdo não rastreado.

### Integração e publicação

- Integrar features em `develop` por PR. Preferir merge commit para preservar fronteiras do Gitflow; commits autorais continuam convencionais.
- Atualizar feature compartilhada sem reescrever seu histórico. Rebase é aceitável em trabalho local não compartilhado; não rebasear branches compartilhadas automaticamente nem usar force push nelas.
- Abrir release de `develop` quando o conjunto estiver pronto para estabilização. Novas funcionalidades continuam em features.
- Após revisão e checks, integrar release em `main`, criar tag anotada `vX.Y.Z` no commit correto e reintegrar as correções em `develop`.
- Hotfix sai de `main`. Levar a correção também a `develop`; se houver release aberta, integrá-la nela e acompanhar a chegada a `develop`.
- Resolver conflitos com revisão e repetir verificações afetadas.

Este guia define o fluxo; não autoriza merge, push, tag ou publicação fora do escopo da tarefa. Merge não equivale a deploy AWS nem à publicação nas lojas.

## Conventional Commits

Commits autorais e títulos de PR usam:

```text
tipo(escopo): descrição curta

Corpo opcional: problema, decisão e impacto.

Refs: #123
```

Tipos adotados: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore` e `revert`. Escopo é opcional, mas recomendado: parte ou capacidade alterada, como `frontend`, `backend`, `infra`, `auth`, `favorites`, `docs` ou `ci`.

```text
feat(backend): adicionar consulta de favoritos do usuário
fix(frontend): corrigir overflow na tela inicial
test(frontend): inicializar dependências dos testes de widgets
ci: validar o build da API
```

Os exemplos não representam funcionalidades já implementadas. `style` significa formatação sem alteração de comportamento; mudança visual funcional usa `feat` ou `fix`. Evitar tipos improvisados como `optimize:` ou capitalização `Fix:` em novos commits. Não inventar issues para preencher rodapés.

Quebras de compatibilidade usam `!` e explicação da migração:

```text
feat(backend)!: alterar contrato de autenticação

BREAKING CHANGE: o cliente deve enviar o novo formato documentado do token.
```

Merges automáticos podem manter a mensagem do Git. Preservar o histórico antigo; não reescrever commits publicados para padronizá-los.

## Releases e versões

Tags novas usam SemVer `vX.Y.Z`; candidatos podem usar `vX.Y.Z-rc.N` quando houver validação de pré-release concreta. Reservar tags a conjuntos e artefatos verificáveis; não criar tags por feature nem apagar tags históricas.

Registrar incompatibilidades, funcionalidades e correções na documentação da versão. Flutter e backend têm versões próprias hoje; alinhar identificação dos artefatos e da release antes da primeira publicação conjunta, sem assumir números coincidentes. Planejar compatibilidade de migrations e rollback: voltar uma imagem não desfaz dados ou esquema.

## Qualidade e validação

| Área | Verificação |
| --- | --- |
| Flutter | SDK fixado, análise, formatação e testes afetados; suíte antes da integração |
| Backend | Dependências pelo lockfile, `npm run typecheck` e `npm test` em `backend/` |
| Infraestrutura | Validação Compose; build e execução quando Docker estiver disponível |
| Documentação | Revisar conteúdo, links e `git diff --check` |
| Entrega | Conferir staged, novos arquivos, segredos e execução remota do CI |

Executar Flutter em `frontend/`. Usar essa raiz no MCP e seguir SDK/hot reload do `AGENTS.md`. Preservar BLoC e o cliente HTTP existente.

Manter PRs pequenos e explicar decisões com validação proporcional. Testar comportamento útil; não adicionar ferramentas, abstrações ou testes apenas por formalidade. Preservar lockfiles e manter segredos, builds e dependências geradas fora do Git.

Falhas existentes devem constar no PR. Não remover, pular ou afrouxar testes para obter verde. PR com falhas conhecidas pode ser draft para revisão; não está pronto para merge por este guia. Distinguir configuração, testes locais, execução real e publicação.

## Proteções e automações pendentes

Proteções de `main`/`develop`, bloqueio de push direto/force push, checks obrigatórios e revisão devem ser configurados no GitHub conforme os recursos disponíveis. Não foram inspecionados nem alterados nesta revisão. Em trabalho individual, explicitar a revisão possível sem alegar aprovação independente inexistente.

Não foi encontrado commitlint, hook de commit ou check específico de título/roteamento de PR na configuração local examinada. Essas regras são documentais e operacionais por enquanto. Avaliar automação em entrega própria; não instalar hooks globais automaticamente. Workflows existentes não comprovam execução nem proteção remota.

## Referências

- [Modelo original de Gitflow](https://nvie.com/posts/a-successful-git-branching-model/).
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

As regras de PR, escopos e validação acima são decisões deste projeto, complementares às convenções.
