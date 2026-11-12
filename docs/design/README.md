# RTM — proposta visual 01

Abra `rtm-visual-v1.html` no navegador. O arquivo é independente, não precisa de servidor nem usa fontes, imagens ou scripts externos.

O seletor **Tema**, no topo, permite alternar entre **Escuro**, **Claro** e **Sistema**. A escolha fica salva neste navegador quando o armazenamento local estiver disponível. O tema claro usa fundo branco quente, superfícies lilás suaves, acento framboesa e dourado mais escuro nas notas para manter a leitura. As capas conservam suas cores. Os temas valem também para os painéis de avaliação, busca, login e compartilhamento.

## Entrega

Três telas com acabamento para revisão: Descobrir, detalhe do filme e review/comentários. O modo Comparar mostra as três telas; Explorar mostra uma de cada vez. Há representações de avaliação com meias estrelas, login, compartilhamento, spoiler e busca. Não há autenticação, envio de credenciais, player, persistência ou integração com a API. Conteúdo, notas, pessoas e capas ilustradas são fictícios.

O Figma MCP bloqueou novas chamadas por limite do plano Starter em 12/11/2026. Por isso esta rodada está no HTML local; ela ainda não foi aplicada ao arquivo Figma. Os wireframes anteriores foram preservados.

## Direção para o Flutter

| Papel | Proposta visual | Correspondência a avaliar na implementação |
| --- | --- | --- |
| Fundo | `#100F14` | Superfície base do ColorScheme |
| Cards | `#1C1A23`, borda `#34303E` | Card e superfícies tonais |
| Ação principal | Coral `#FF6978`, texto `#350A13` | FilledButton, ação principal única por contexto |
| Texto | `#F6F1F4`; secundário `#B5ADBD` | TextTheme e papéis onSurface |
| Avaliações | Dourado `#F3CB81` | Ícones de estrela inteira/meia e valor textual |
| Destaque editorial | Verde `#B8DFC8` | Badge discreto, sem competir com a ação principal |
| Navegação | Ícone + rótulo + indicador tonal | NavigationBar |
| Filtros | Pills com estado selecionado | FilterChip ou SegmentedButton, conforme comportamento |
| Ações secundárias | Ícones tonais com rótulo acessível | IconButton e FilledTonalIconButton |
| Contêineres | Cantos de 12–24, espaçamento de 4–24 | Tokens a consolidar após revisão |

Ícones deste estudo são SVG editáveis incorporados ao HTML. Na implementação, mapear para ícones Material do Flutter, sem tratá-los como uma biblioteca já integrada. Tipografia local: Segoe UI/Arial; a versão Flutter deve revisar a Poppins existente e sua hierarquia antes de fechar o TextTheme.

## Texto de interface

Preferir frases diretas ligadas à tarefa. A Home passa a usar “O que você vai assistir?”, substituindo “O que vale a conversa?”. Evitar slogans abstratos para identificar busca, compartilhar, entrar ou avaliar.

## Verificação e limites

Sintaxe JavaScript verificada com `node --check`. As três telas foram observadas no Chrome. A revisão automatizada de cliques foi interrompida ao detectar uso do navegador pelo usuário; não declarar os fluxos interativos, teclado ou breakpoints como completamente validados. O HTML inclui media queries e foco visível; isso não comprova acessibilidade completa.

Tema claro: alternância pelo seletor observada no Chrome, com revisão visual das três telas. Persistência e opção Sistema são implementadas com localStorage e prefers-color-scheme; não houve auditoria completa de acessibilidade ou dispositivos.

Próxima etapa: revisar esta direção, completar estados e telas restantes, transferir os desenhos para o Figma quando houver acesso às ferramentas e só depois implementar no Flutter.
