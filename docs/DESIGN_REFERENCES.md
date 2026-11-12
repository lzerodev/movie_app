# RTM — referências e direção visual

Pesquisa de 12/11/2026. Este documento é uma proposta para revisão, não uma decisão de produto aprovada nem uma implementação de novas funcionalidades. Capturas públicas representam versões específicas dos aplicativos; não comprovam todos os estados ou fluxos atuais.

**Posicionamento esclarecido pelo usuário:** o foco é review, comentários e dicas sobre filmes e séries, com trailers. Usar as referências cinematográficas para valorizar opiniões e descoberta. O inventário de telas, fluxos e design system está em [PRODUCT_AND_DESIGN_PLAN.md](PRODUCT_AND_DESIGN_PLAN.md); organizar e desenhar antes da implementação.

## Diagnóstico da interface atual

Leitura de design baseada nas capturas do RTM desta conversa:

- A lista dá destaque semelhante a todos os filmes, sem uma hierarquia entre descoberta, coleção e detalhe.
- Pôsteres pequenos competem com títulos grandes e sinopses truncadas repetidas.
- Contornos de cards, superfícies azuis e sombras do botão disputam atenção com o conteúdo cinematográfico.
- Espaços grandes entre cards reduzem a densidade útil sem criar uma composição editorial clara.
- A marca e a navegação ficaram mais organizadas no cabeçalho recente, mas os elementos da Home ainda precisam de uma linguagem comum.

## Referências selecionadas

As interpretações e aplicações abaixo são autorais; os links permitem conferir as telas e o contexto dos produtos.

### Letterboxd — catálogo e relação com os filmes

Fonte: [aplicativo e capturas publicadas na App Store](https://apps.apple.com/us/app/letterboxd/id1054271011). [Apresentação do produto](https://letterboxd.com/).

O produto inclui avaliações, listas e registro de filmes. Como referência para o RTM, estudar a identificação rápida pelo pôster, metadados compactos, notas e organização da coleção. A contribuição principal é a hierarquia de informação de um catálogo, não copiar o feed social ou incorporar funções que o backend ainda não oferece.

Captura pública de exemplo: [detalhe de filme](https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/91/8a/21/918a21b7-d185-d9be-64d6-91022945237f/Store_1e.png/1290x2796bb.png). A imagem está hospedada no CDN da App Store e foi localizada por busca de imagens; não foi produzida pelo RTM.

### MUBI — composição editorial

Fonte: [aplicativo e capturas publicadas na App Store](https://apps.apple.com/us/app/mubi-stream-great-cinema/id626148774).

Estudar o uso de imagens como conteúdo principal, blocos editoriais e contraste entre títulos e informações secundárias. Aplicação proposta: destacar uma descoberta, organizar seções e reduzir o aspecto de formulário ou painel administrativo. Curadoria específica não deve ser apresentada como funcionalidade já implementada no RTM.

Captura pública complementar: [composição de telas Android publicada em artigo](https://cdn.mos.cms.futurecdn.net/RxzyRpK88iVtmfWJeZvbyb.png), localizada neste [artigo de referência](https://www.techzlab.com/6-best-streaming-apps-for-android-phones-our-picks-for-tv-anime-film-and-more/). É material de terceiros, útil como referência visual e não como confirmação da versão atual.

### Apple TV — imagens e hierarquia entre seções

Fontes: [apresentação oficial do aplicativo](https://www.apple.com/apple-tv-app/), [guia oficial da Home](https://support.apple.com/guide/iphone/personalize-the-home-tab-iphbf1137ac0/ios).

Estudar a relação entre destaque visual e fileiras de conteúdo, legibilidade sobre imagens e separação de seções. Aplicação proposta: um destaque com informações essenciais e pôsteres com proporções consistentes. O RTM é um aplicativo de descoberta e avaliação; não herdar controles de reprodução que não correspondem ao produto.

Captura pública oficial: [Home do aplicativo no guia da Apple](https://help.apple.com/assets/678AF3BDAED93ED9D1042F84/678AF3C89EC3C835220A70FE/en_US/95ef124de0ca285295e4c5f60def3e03.png). Tratar como exemplo de composição, não como reprodução garantida da versão mais recente.

### Material 3 — comportamento e acessibilidade

Fontes: [App bars](https://m3.material.io/components/app-bars/), [componentes Material no Flutter](https://docs.flutter.dev/ui/widgets/material).

Usar como referência de comportamento de componentes, foco, estados e adaptação. A linguagem de marca do RTM precisa ser definida pelo produto, mesmo quando a implementação utiliza componentes Material.

## Três direções possíveis

| Direção | Elementos centrais | Trade-off |
| --- | --- | --- |
| Catálogo para cinéfilos | Grade de pôsteres, notas compactas, listas e alta densidade | Menos espaço para imagem de destaque e texto editorial |
| Cinema editorial | Destaque visual, seções com títulos claros, pôsteres e texto seletivo | Exige selecionar bem o que recebe destaque |
| Diário pessoal | Progresso, registros, avaliações e coleções do usuário | Depende de identidade e persistência que ainda não estão implementadas |

**Recomendação para comparar primeiro:** cinema editorial, combinado com a organização de catálogo do Letterboxd. É uma proposta; não obriga a substituir a arquitetura atual ou criar recursos de streaming.

## Proposta concreta para os elementos do RTM

| Elemento | Direção proposta |
| --- | --- |
| Fundo e superfícies | Base carvão, superfícies próximas entre si e vermelho reservado ao acento |
| Tipografia | Título de seção, título de filme e metadados com tamanhos/pesos distintos; reduzir excesso de negrito |
| Imagens | Pôsteres 2:3 com maior presença; backdrop apenas quando a imagem e o contexto justificarem |
| Home | Apresentação clara de “Em cartaz”, com destaque e coleção de filmes; outras seções só com fonte de dados definida |
| Card de catálogo | Pôster, título curto, ano e nota; sinopse concentrada no detalhe |
| Card editorial | Imagem maior e uma justificativa breve do destaque, sem competir com todos os itens da lista |
| Nota | Indicador compacto; identificar a nota do catálogo e futuramente a nota pessoal sem confundi-las |
| Botões | Uma ação principal por contexto; estados de hover, foco, pressionado e indisponível consistentes |
| Busca | Uma entrada principal no layout compacto, preservando a decisão de retirar a duplicação no topo |
| Navegação | Rótulos úteis; revisar destinos demonstrativos antes de priorizá-los frente a busca e coleção |
| Estados | Carregamento, vazio, erro e imagens indisponíveis desenhados com o mesmo cuidado da lista carregada |
| Desktop | Mais colunas e largura de leitura controlada; evitar apenas esticar o layout do celular |

Tokens iniciais para explorar, não valores finais aprovados: escala de espaçamento 4/8/12/16/24/32, poucos raios de canto, textos secundários legíveis e alvos de interação com pelo menos 48 pontos lógicos no layout Flutter. Validar contraste, escala de texto e navegação por teclado durante a implementação; não alegar acessibilidade apenas por aplicar esses números.

## Próxima entrega de design

Comparar uma proposta de Home e de detalhe em larguras compacta e ampla, usando conteúdo de filmes representativo e exibindo claramente os estados. Avaliar hierarquia, legibilidade, densidade, clareza das ações e identidade RTM. Só depois consolidar os tokens e refatorar componentes.

Separar funcionalidades disponíveis, dados simulados de uma proposta e recursos futuros. Favoritar, avaliar e manter coleções não devem aparentar persistência real antes da integração correspondente. Manter Flutter/BLoC, cliente HTTP existente e regras de hot reload do projeto.

Screenshots e marcas dos produtos de referência pertencem aos seus titulares; os links servem à análise. Não incorporar seus arquivos visuais ou copiar sua identidade para o aplicativo.
