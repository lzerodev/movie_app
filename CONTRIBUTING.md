# 🚀 Movie App - Guia de Contribuição

## 📋 GitFlow Workflow

Este projeto segue o **GitFlow** para organização de branches e releases.

### 🌳 Estrutura de Branches

```
main (produção)
├── develop (desenvolvimento)
    ├── feature/nome-da-feature
    ├── release/vX.Y.Z
    └── hotfix/nome-do-hotfix
```

### 🔄 Fluxo de Trabalho

#### **Features (Novas funcionalidades)**

```bash
# Criar feature branch a partir de develop
git checkout develop
git pull origin develop
git checkout -b feature/nome-da-feature

# Desenvolvimento...
git add .
git commit -m "feat: descrição da feature"

# Finalizar feature
git checkout develop
git merge feature/nome-da-feature
git tag -a v1.x.x-feature.nome -m "Feature: Nome da Feature"
git push origin develop --tags
```

#### **Releases (Preparação para produção)**

```bash
# Criar release branch a partir de develop
git checkout -b release/v1.x.x

# Ajustes finais, testes, documentação...
git commit -m "chore: preparar release v1.x.x"

# Finalizar release
git checkout main
git merge release/v1.x.x
git tag -a v1.x.x -m "Release v1.x.x"
git checkout develop
git merge release/v1.x.x
git push origin main develop --tags
```

#### **Hotfixes (Correções urgentes)**

```bash
# Criar hotfix branch a partir de main
git checkout main
git checkout -b hotfix/nome-do-fix

# Correção...
git commit -m "fix: descrição da correção"

# Finalizar hotfix
git checkout main
git merge hotfix/nome-do-fix
git tag -a v1.x.y -m "Hotfix v1.x.y"
git checkout develop
git merge hotfix/nome-do-fix
git push origin main develop --tags
```

## 📝 Padrões de Commit

Seguimos o **Conventional Commits** para mensagens padronizadas:

### **Tipos de Commit**

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação (não afeta lógica)
- `refactor:` Refatoração de código
- `perf:` Melhoria de performance
- `test:` Adição/correção de testes
- `chore:` Tarefas de manutenção
- `ci:` Integração contínua
- `build:` Sistema de build

### **Formato da Mensagem**

```
tipo(escopo): descrição curta

Descrição mais detalhada do que foi feito e por quê.

- Lista de mudanças principais
- Impacto nos usuários
- Breaking changes (se houver)

Closes #123
```

### **Exemplos**

```bash
feat(widgets): implementar sistema de cards reutilizáveis

Adiciona AppCard com múltiplas variantes (primary, secondary, outlined, elevated)
e tamanhos configuráveis (small, medium, large, xl).

- 4 variantes visuais diferentes
- 4 tamanhos responsivos
- Configuração automática de estilos
- Factories convenientes para casos comuns
- Totalmente compatível com design system

Melhora significativamente a reutilização de código e consistência visual.
```

## 🏷️ Sistema de Tags

### **Formato de Tags**

- **Releases:** `v1.2.3` (semver)
- **Features:** `v1.2.3-feature.nome`
- **Release Candidates:** `v1.2.3-rc.1`
- **Hotfixes:** `v1.2.3-hotfix.nome`

### **Versionamento Semântico (SemVer)**

- **MAJOR** (v**X**.0.0): Breaking changes
- **MINOR** (v1.**X**.0): Novas funcionalidades (backward compatible)
- **PATCH** (v1.2.**X**): Bug fixes (backward compatible)

## 📋 Checklist de Pull Request

### **Antes de Abrir o PR**

- [ ] Branch atualizada com develop
- [ ] Testes passando
- [ ] Documentação atualizada
- [ ] Commit messages seguindo padrão
- [ ] Tag criada (se aplicável)

### **Template do PR**

```markdown
## 🎯 Tipo de Mudança

- [ ] ✨ Nova funcionalidade
- [ ] 🐛 Correção de bug
- [ ] 📚 Documentação
- [ ] 🔄 Refatoração
- [ ] ⚡ Performance
- [ ] 🧪 Testes

## 📋 Descrição

Descrição clara e concisa das mudanças implementadas.

## 🎨 Screenshots (se aplicável)

Adicione imagens mostrando as mudanças visuais.

## ✅ Checklist

- [ ] Testes unitários passando
- [ ] Documentação atualizada
- [ ] Sem breaking changes (ou documentados)
- [ ] Revisão de código feita
- [ ] Análise estática limpa
```

## 🔧 Comandos Úteis

### **Setup Inicial**

```bash
# Clonar repositório
git clone https://github.com/lzerodev/movie_app.git
cd movie_app

# Configurar branches
git checkout -b develop origin/develop
```

### **Sincronização**

```bash
# Atualizar develop
git checkout develop
git pull origin develop

# Rebase feature branch
git checkout feature/minha-feature
git rebase develop
```

### **Tags e Releases**

```bash
# Listar tags
git tag --list

# Ver detalhes de uma tag
git show v1.2.3

# Deletar tag local
git tag -d v1.2.3

# Deletar tag remota
git push origin --delete v1.2.3
```

## 🎯 Fluxo de Feature Atual

Estamos implementando melhorias de **escalabilidade e manutenibilidade**:

1. ✅ **Widgets Reutilizáveis** (v1.1.1-feature.reusable-widgets)
2. 🔄 **Sistema de Cards Avançado** (em desenvolvimento)
3. 📋 **Lista Genérica Paginada** (planejado)
4. 🧭 **Sistema de Navegação** (planejado)
5. 🔧 **Extensões de Context** (planejado)

---

**👨‍💻 Desenvolvido por LZeroDev | 🤖 Com assistência do GitHub Copilot**
