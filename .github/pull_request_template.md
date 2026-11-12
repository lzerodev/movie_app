## Problema e resultado

Descreva o problema concreto e o comportamento após a alteração. Título Conventional Commit, por exemplo `fix(frontend): corrigir overflow da tela inicial`.

## Escopo e decisão

Explique a solução e os motivos relevantes à revisão. Vincule uma issue existente quando houver.

## Validação

Informe comandos executados, resultados e limites. Para UI, inclua evidência visual quando disponível; para dados/contratos, descreva compatibilidade e recuperação.

- [ ] Verificações locais relevantes executadas e resultados descritos.
- [ ] Falhas anteriores/novas e validações bloqueadas explícitas.
- [ ] Execução remota do CI conferida; falhas conhecidas mantêm o PR como draft até resolução.

## Gitflow e revisão

Origem: `feature/...`, `release/...` ou `hotfix/...`.
Destino: `develop` ou `main`, conforme `CONTRIBUTING.md`.

- [ ] Base correta e diff completo revisado, incluindo arquivos novos e exclusões.
- [ ] Commits autorais e título seguem Conventional Commits.
- [ ] Sem segredos, arquivos gerados ou alterações alheias incluídos por engano.
- [ ] Contratos, documentação e incompatibilidades atualizados quando necessário.

## Riscos e próximos passos

Registre limitações, migrations, rollback e ações operacionais pertinentes. Para release/hotfix, descreva versão, artefatos e reintegração em `develop`/release aberta. Features não exigem tags. Diferencie código integrado, deploy do backend e publicação do aplicativo.
