# RTM — organização de produto e plano de design

Data: 12/11/2026. **Etapa atual: desenvolvimento incremental da direção visual aprovada.** Após aprovar o protótipo claro/escuro, o usuário autorizou implementar, preservando BLoC e a transição Hero. O primeiro conjunto editável foi criado no [Figma — RTM / Fluxos e wireframes v1](https://www.figma.com/design/sN2K94VEzLqBs7bq1BkW6g). Consulte a [primeira entrega Flutter e suas validações](UI_IMPLEMENTATION.md).

Rodada visual seguinte: [protótipo HTML local](design/rtm-visual-v1.html) com cor, ícones e acabamento em Descobrir, detalhe e review/comentários. Consulte [direção e limites](design/README.md). A ferramenta Figma atingiu o limite do plano Starter; essa rodada ainda não foi sincronizada ao Figma. Copy de interface deve ser direta: Home com “O que você vai assistir?”, conforme retorno do usuário.

## 1. Posicionamento confirmado

RTM (Rate That Movie) é um produto para descobrir **filmes e séries**, avaliar, escrever reviews, comentar e trocar dicas com amigos. Permite assistir a trailers. A linguagem cinematográfica deve valorizar a opinião e a descoberta, sem apresentar o produto como um serviço para assistir aos filmes ou episódios completos.

Pedidos confirmados: reorganizar as telas existentes, incluir login, reviews/comentários, favoritos e compartilhamento de um link para amigos consultarem sinopse, nota e comentários. Desenhar e revisar a experiência antes de continuar a implementação. O arquivo Figma foi criado após autorização para seguir com os fluxos e wireframes.

## 2. Inventário do que existe

Inspeção local de `frontend/lib/core/navigation/app_routes.dart`, `features/home/widgets/home.dart` e páginas de busca/detalhe:

| Área | Estado observado | Tratamento no design |
| --- | --- | --- |
| Home / filmes em cartaz | Tela e integração de catálogo existentes | Evoluir para descoberta de filmes e séries com reviews em evidência |
| Busca | Busca de filmes existente | Unificar linguagem e prever variantes filmes/séries e estados |
| Detalhe do filme | Sinopse, dados do catálogo e ações | Reorganizar hierarquia para nota, review, comentários e trailer |
| Favoritar no detalhe | Booleano local `_isFavorite` | Desenhar persistência, conta, feedback e tela dedicada; ainda não existe backend funcional |
| Trailer e compartilhar | Callbacks com TODO | Desenhar fluxos e indisponibilidade; não anunciar funcionamento atual |
| Perfil | Conteúdo e opções demonstrativos | Transformar em perfil próprio com avaliações, conta e saída |
| Notificações | Exemplos estáticos | Reavaliar como função futura, sem ocupar destino principal nesta proposta |
| Login, reviews e comentários | Não implementados | Novos fluxos completos, incluindo estados de erro e autoria |
| Séries | Modelo e rotas atuais são centrados em filmes | Nova variante de conteúdo e contratos próprios |
| Link compartilhado | Detalhe atual depende de objeto `Movie` recebido pela navegação | Planejar resolução por tipo/ID, leitura pública web e login para interação |

A API tem apenas healthcheck; auth/users/favorites são módulos reservados. O novo design não comprova backend, persistência, moderação ou links compartilháveis operacionais.

## 3. Decisões confirmadas e propostas restantes

Respostas explícitas do usuário em 12/11/2026:

| Decisão | Escolha confirmada | Impacto |
| --- | --- | --- |
| Leitura por link compartilhado | Pública; login apenas para participar | Amigo lê sinopse, notas e comentários sem conta; avaliar, comentar e favoritar exigem login com retorno à ação iniciada |
| Escala pessoal | Cinco estrelas, com meias estrelas | Controle em incrementos de 0,5; estado sem avaliação separado; explicar escala e valor de forma acessível |
| Séries na primeira versão | Avaliar série, temporadas e episódios | Hierarquia navegável e avaliações próprias para cada nível desde o primeiro desenho |

Propostas ainda abertas à revisão do mapa:

| Decisão | Proposta inicial | Impacto |
| --- | --- | --- |
| Comentários | Respostas vinculadas a uma review | Evita duplicar conversa geral do título e conversa da review inicialmente |
| Favoritos e lista para ver | Favoritos no escopo inicial; “quero ver” fica como expansão a confirmar | São intenções diferentes; não usar um único ícone com dois significados |
| Cadastro | E-mail e senha como fluxo inicial de desenho | Login social pode ser avaliado depois, sem escolher fornecedor nesta etapa |

Comentários, lista para ver e mecanismo inicial de cadastro permanecem propostas. A leitura pública foi confirmada pelo usuário depois da resposta anterior que exigia login para ler; esta decisão mais recente a substitui. Cinco estrelas com meias estrelas e avaliação por série/temporada/episódio permanecem confirmadas.

## 4. Navegação proposta

Quatro destinos principais: **Descobrir · Buscar · Favoritos · Perfil**.

- Descobrir: catálogo e entradas para opiniões/dicas, com rótulos claros de filmes e séries; leitura disponível também a visitantes.
- Buscar: consulta e resultados, com filtro de tipo e estados coerentes.
- Favoritos: coleção pessoal; visitante recebe explicação e entrada de conta, não uma coleção fictícia.
- Perfil: minhas avaliações/reviews, dados próprios e acesso à configuração da conta.

No layout compacto, Buscar ocupa um destino inferior único. Essa é uma evolução proposta da decisão de manter busca embaixo: ao adotá-la, substituir o FAB de busca pela entrada da navegação, preservando uma única entrada principal. Não renderizar ambos. No desktop, adaptar a navegação à largura sem esticar a tela móvel.

Notificações podem voltar quando houver eventos reais de respostas ou outra necessidade validada. Feed de seguidores, mensagens privadas, listas colaborativas e recomendações por IA não entram automaticamente no primeiro escopo.

## 5. Inventário para desenhar

**14 telas-base**, com variantes e overlays associados. Temporada e episódio passam a fazer parte do primeiro escopo. Uma variante não precisa virar uma nova página no código.

| ID | Tela-base | Conteúdo e variantes essenciais |
| --- | --- | --- |
| S01 | Descobrir | Filmes/séries; títulos e opiniões em destaque; carregamento/erro |
| S02 | Buscar | Inicial, digitando, resultados, sem resultado, erro; filtro de tipo |
| S03 | Detalhe do título | Variante filme/série; sinopse, notas por origem, reviews, trailer e compartilhar públicos; login para avaliar/comentar/favoritar |
| S04 | Avaliar e escrever review | Cinco estrelas com meias estrelas, opinião, spoiler e publicar; contexto explícito de filme/série/temporada/episódio; edição e erros |
| S05 | Review e comentários | Leitura pública de review, autor, estrelas, spoiler e respostas; composer exige login |
| S06 | Favoritos | Lista/grade, vazia, visitante, carregamento, erro e remoção |
| S07 | Meu perfil | Identidade pública básica, minhas notas/reviews e acesso à conta; estado vazio |
| S08 | Conta e preferências | Dados da conta, opções disponíveis e saída; confirmação quando pertinente |
| S09 | Login | E-mail/senha, validação, enviando, erro e retorno à ação anterior |
| S10 | Cadastro | Dados mínimos, validação e confirmação/continuação conforme mecanismo futuro |
| S11 | Recuperar senha | Solicitação, validação e confirmação com resposta que não exponha cadastro de terceiros |
| S12 | Redefinir senha | Link válido, inválido/expirado, nova senha, sucesso e retorno |
| S13 | Detalhe da temporada | Série de origem, número/nome, sinopse, avaliações da temporada, lista de episódios, trailer quando disponível e compartilhar |
| S14 | Detalhe do episódio | Série e temporada de origem, número/nome, sinopse, avaliações/comentários do episódio, trailer quando disponível e compartilhar |

Overlays/fluxos complementares:

- **Trailer:** abertura, reprodução, carregamento, indisponível/erro e fechamento; sem reprodução automática ao abrir o título.
- **Compartilhar:** prévia do título sem spoiler, copiar link, confirmação e falha; não incluir dados privados, rascunhos ou informações da conta.
- **Entrar para continuar:** solicitado ao avaliar, comentar ou favoritar; preservar filme/série/temporada/episódio e a ação iniciada durante login, cadastro e recuperação. Não bloquear leitura por link.
- **Comentário:** escrever/responder, editar/remover o próprio, erro e confirmação pertinente; sem apagar texto silenciosamente.
- **Spoiler e conteúdo reportado:** revelação voluntária e estados de conteúdo indisponível/removido; definir o fluxo de denúncia para conteúdo público.
- **Filtros e ordenação:** apenas os critérios definidos para a primeira experiência; não desenhar controles sem fonte de dados ou finalidade.

Perfil público de outras pessoas permanece uma expansão separada. Avaliação de temporada e episódio está confirmada no escopo inicial, não é mais uma expansão futura.

## 6. Fluxos prioritários do protótipo

### A. Descobrir e formar opinião

Visitante ou usuário autenticado → descobrir ou buscar → detalhe de filme/série → ler sinopse e notas → ver trailer, quando disponível → ler reviews → abrir uma conversa de comentários. Nenhum cadastro é necessário para esse percurso de leitura.

Para séries: série → selecionar temporada → selecionar episódio. Permitir voltar aos níveis anteriores e deixar claro se a pessoa está lendo ou publicando uma opinião sobre a série inteira, uma temporada ou um episódio.

### B. Publicar uma avaliação

Detalhe do item → Avaliar e escrever → login/cadastro quando necessário → retorno ao mesmo item com intenção/rascunho preservado → estrelas/opinião/spoiler → publicar → confirmação e acesso à review. Sessão expirada segue o mesmo retorno sem perda silenciosa do texto.

Uma pessoa pode atribuir uma nota sem escrever uma review extensa. A relação entre estrelas e texto será explicitada no wireframe. Proposta de regra: uma avaliação pessoal atual e editável por item avaliado. Filme, série, temporada e episódio são itens distintos; comentários são respostas a reviews.

### C. Comentar

Review pública → ler comentários → escolher comentar → login quando necessário → escrever/enviar → comentário publicado, com tratamento de erro e prevenção de envio repetido. Sessão expirada exige reentrada sem perder texto; as ações sobre o próprio conteúdo são diferentes das ações sobre conteúdo de terceiros.

### D. Salvar e recuperar favoritos

Detalhe → favoritar → login quando necessário → concluir a intenção de favoritar → feedback → Favoritos → abrir o mesmo título. Definir estado em andamento, falha e remoção para não mostrar como persistido algo que o servidor recusou. Favoritar temporada/episódio não foi solicitado; a proposta inicial de favoritos continua centrada em filmes e séries.

### E. Compartilhar com um amigo

Detalhe → Compartilhar → link do item → amigo abre na web → lê sinopse, notas e comentários sem criar conta → entra na conta se quiser avaliar, comentar ou favoritar. Depois do login, retornar ao mesmo filme, série, temporada ou episódio e à ação iniciada.

Links de título, temporada e episódio fazem parte do desenho. Compartilhar uma review específica, destacando a opinião de quem enviou, pode ser acrescentado depois se necessário. Ter o link permite leitura pública, mas não autoriza ações em nome de outra pessoa.

## 7. Informação, notas e conteúdo da comunidade

- Identificar **nota do catálogo**, **nota da comunidade RTM** e **sua nota**. As avaliações RTM usam cinco estrelas com meias estrelas. Se o score do catálogo continuar em 0–10, identificá-lo nessa escala; não convertê-lo silenciosamente nem apresentá-lo como nota RTM.
- Desenhar estrelas vazias, cheias e pela metade, edição, remoção da avaliação e acesso por teclado/leitor de tela. “Sem avaliação” é um estado próprio; não defini-lo como nota zero por acidente. A escolha exata sobre aceitar zero estrelas permanece uma regra de interação a fechar no wireframe.
- Série, temporada e episódio têm notas e contagens próprias. Não calcular a nota da série como média dos episódios ou temporadas sem uma decisão específica; inicialmente, separar as avaliações diretas de cada nível.
- Exibir contexto de temporada/episódio nos cards e no editor e ocultar spoilers antes da revelação voluntária. Episódio ainda não lançado e trailer indisponível são estados a desenhar; a regra sobre permitir avaliação antes da estreia ainda será definida.
- Quando não houver avaliações RTM, mostrar “Ainda sem avaliações”; dados ilustrativos do protótipo ficam identificados como simulados.
- Uma review publicada tem autor, texto, eventual nota, data, item avaliado e estado de spoiler. Explicar sua visibilidade pública antes de publicar; não apresentar reviews/comentários publicados como privados ou restritos aos amigos do autor.
- Comentários respondem a uma review nesta proposta. O detalhe do título apresenta as reviews e entradas para suas conversas, sem misturar respostas sem contexto.
- “Dicas” são recomendações/opiniões humanas e compartilhamento de títulos no primeiro escopo; não pressupõem um recomendador personalizado já existente.
- Favoritos e dados da conta não entram automaticamente no link compartilhado. E-mail, sessão, rascunhos e demais dados privados não aparecem nas prévias; leitura pública abrange somente o conteúdo publicado previsto para esse destino.
- Publicar, editar, remover e reportar conteúdo exigem estados próprios. O mecanismo operacional de moderação precisa ser definido antes de liberar contribuições reais da comunidade.

## 8. Requisitos de experiência para o link

URLs ilustrativas: `https://<dominio-a-definir>/title/movie/<id>`, `/title/tv/<id>`, `/title/tv/<id>/season/<numero>` e `/title/tv/<id>/season/<numero>/episode/<numero>`. Não são endereços provisionados. Tipo e contexto hierárquico fazem parte da identidade: não confundir filmes, séries, temporadas ou episódios com IDs/números coincidentes.

O acesso direto resolve o item por identidade e contexto sem exigir sessão para leitura; não pode depender de um objeto `Movie` já carregado em uma tela anterior. Desenhar abertura por link, refresh, voltar, título inexistente, temporada/episódio indisponível e falha temporária. Ao iniciar uma interação, login e cadastro preservam o destino e a intenção, inclusive temporada e episódio; o link não contém token de login, e-mail ou ID privado para provar identidade.

Prever título, imagem e descrição da prévia social sem spoiler, usando apenas dados públicos. O requisito é leitura web responsiva sem obrigar conta ou instalação; abertura no app pode ser uma evolução associada. O protótipo deve mostrar leitura como visitante e retorno após login ao tentar participar. Na implementação posterior, separar os dados públicos das operações e dados privados protegidos no servidor.

## 9. Design system e organização no Figma

Ferramenta utilizada: **Figma Design**, com texto, frames e hierarquia editáveis. Arquivo: [RTM — Fluxos e wireframes v1](https://www.figma.com/design/sN2K94VEzLqBs7bq1BkW6g?node-id=4-1394). Página criada: `01 — Fluxos e wireframes`.

Primeira entrega: 14 telas-base mobile, variante do detalhe da série, seis painéis auxiliares (trailer, compartilhar, participação/login, comentário, recuperação e contexto de avaliação), leitura pública desktop e variantes de avaliação/review para série, temporada e episódio. Foram conectados percursos ilustrativos; formulários, autenticação, player e compartilhamento não executam ações reais. O retorno após login está especificado, mas o protótipo não simula todas as combinações de ação e sessão.

Biblioteca inspecionada: Material 3 Design Kit. Botões reutilizam instâncias do botão outlined, com ajustes neutros para baixa fidelidade. Tipografia de trabalho: Poppins, encontrada no produto. Isso não constitui um design system RTM publicado ou aprovado. Imagens são placeholders intencionais; títulos, contas e números são demonstrativos.

Revisão visual realizada no detalhe mobile e na página pública desktop, com correção de altura de texto e colunas. Estados de erro/vazio/visitante estão inventariados; ainda precisam de variantes visuais completas. Próximo passo: revisar arquitetura e hierarquia, então construir fundações/componentes e telas de alta fidelidade. As páginas abaixo continuam como organização proposta para as etapas seguintes.

Organização planejada do arquivo:

1. `00 — Brief e decisões`: posicionamento, inventário, referências e decisões pendentes.
2. `01 — Fluxos e wireframes`: navegação, trajetos principais e estados sem acabamento visual prematuro.
3. `02 — Fundamentos`: cores primitivas e semânticas, tipografia, espaçamento, grid, raios, elevação, ícones e foco.
4. `03 — Componentes`: famílias com propriedades, variantes e documentação de uso.
5. `04 — Telas mobile`: telas-base e variantes selecionadas.
6. `05 — Telas amplas`: web/desktop e estados do compartilhamento.
7. `06 — Protótipo e revisão`: pontos de partida e roteiros de validação.

Antes de construir a biblioteca, inspecionar bibliotecas disponíveis e reutilizar assets compatíveis. Não afirmar que já existe uma biblioteca publicada ou ligada ao código. Não transformar o tema Dart atual automaticamente em fonte final: ele é material de inventário, enquanto a direção visual será revisada no design.

Inventário v1 de componentes: botões e icon buttons; campos de conta/busca; header e navegação; chips de filtro e tipo; pôster/card de título; controle de cinco estrelas com meias estrelas e apresentação de notas por origem; seletor de temporada e linha/card de episódio; contexto hierárquico de série/temporada/episódio; avatar/identificação do autor; card de review; comentário/composer; spoiler; ação de favorito; diálogo/sheet; player/placeholder de trailer; feedback, carregamento, vazio, erro e acesso bloqueado.

Estados onde fizerem sentido: padrão, hover, foco, pressionado, selecionado, desabilitado, carregando e erro. Vincular cores e medidas a tokens; usar instâncias dos componentes nas telas para revisar consistência. Tema escuro primeiro, com identidade RTM e acento vermelho; outro tema não é exigido nesta primeira entrega.

Larguras iniciais de desenho: mobile 390 e desktop 1440; verificar a composição também em 320 e 768, escala de texto e conteúdo longo. São dimensões de revisão, não dispositivos obrigatórios nem bloqueio de orientação.

## 10. Sequência e critérios de aceite

| Fase | Entrega | Condição para avançar |
| --- | --- | --- |
| 0 — Agora | Este mapa de produto, inventário e decisões | Revisar escopo e responder decisões que mudam os fluxos |
| 1 | Fluxos e wireframes das 14 telas-base/overlays prioritários | Percorrer descobrir, avaliar, comentar, favoritar e compartilhar, incluindo login e hierarquia de séries |
| 2 | Fundamentos, componentes iniciais e direção visual em Descobrir/Detalhe/Review | Escolher composição e hierarquia antes de expandir todas as telas |
| 3 | Telas completas com componentes e estados | Coerência visual, conteúdo realista, legibilidade e adaptação |
| 4 | Protótipo visitante/autenticado e leitura web compartilhada | Validar os cinco trajetos, meias estrelas e retorno ao episódio/ação após login |
| 5 | Backlog técnico derivado do design aprovado | Definir contratos, persistência e ordem de implementação, preservando Flutter/BLoC e a API única |

Login desenhado não comprova autenticação; protótipo navegável não comprova backend. Os trabalhos de API, banco, séries/temporadas/episódios, publicação web, previews, trailers e conteúdo da comunidade serão entregas técnicas posteriores com suas verificações próprias.

## 11. Controle de escopo desta etapa

Não continuar o redesign funcional ou desenvolver login/reviews/comentários enquanto o usuário estiver organizando e revisando o plano e as telas. Preservar as alterações locais anteriores do cabeçalho e `devtools_options.yaml`; não descartá-las nem incorporá-las automaticamente a um commit de planejamento.

Referências: [DESIGN_REFERENCES.md](DESIGN_REFERENCES.md), [ARCHITECTURE.md](ARCHITECTURE.md), [ROADMAP.md](ROADMAP.md) e [PROJECT_STATUS.md](PROJECT_STATUS.md).
