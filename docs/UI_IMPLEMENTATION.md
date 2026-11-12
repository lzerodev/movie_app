# Primeira entrega visual Flutter — 12/11/2026

O usuário aprovou a direção visual HTML e autorizou iniciar o desenvolvimento, mantendo BLoC e a transição Hero existente.

## Implementado

- Temas Material 3 claro, escuro e sistema. O seletor fica no ícone “Tema” do cabeçalho. ThemeCubit guarda a escolha durante a sessão; ainda não existe persistência da preferência entre execuções.
- MovieModernBloc continua responsável pelo catálogo e pela busca, com os mesmos use cases, repositório e cliente HTTP. ThemeCubit é isolado desse fluxo.
- Catálogo com destaque do primeiro filme, pôsteres em grid responsivo, estados de carregamento/vazio/falha, pull-to-refresh e paginação. Não há reviews fictícias inseridas no app nem filtros de séries sem contrato de API.
- Detalhe com pôster, título, data, sinopse e nota explicitamente identificada como TMDb / 10. Foram retirados a contagem de votos calculada artificialmente e os rótulos que confundiam nota com categoria.
- Hero continua usando `movie_<id>` e a mesma rota `goToMovieDetailWithHero`. As animações fade/slide de entrada do detalhe conservam duração e curvas. Cada filme aparece uma única vez na composição do catálogo para evitar tags duplicadas entre destaque e grid.
- Cabeçalho, busca, campos e cards de apoio usam papéis do tema, em vez de impor superfícies escuras no modo claro.
- Resposta vazia do catálogo agora conclui o estado de loading; evita tela carregando indefinidamente.

## Validação observada

- SDK fixado: Flutter 3.50.0 / Dart 3.14.0.
- Análise estática: sem apontamentos.
- Suíte completa: **84 testes passaram**. Novos casos: troca de tema mantém catálogo carregado sem nova chamada; navegação Hero e retorno no tema claro em largura 320; títulos longos/fonte 150% em larguras 320, 744 e 1280; resposta vazia do BLoC conclui carregamento.
- Build e execução Windows debug concluídos. DTD conectado e hot restart/hot reload confirmados.
- Busca e catálogo no tema claro foram observados no app. Um overflow de quatro pixels foi detectado com dados reais e corrigido no layout dos cards; depois do hot reload, a ferramenta não registrou erros de runtime.
- Não houve execução em aparelho Android/iOS, build de release, CI remoto ou publicação.

## Próximas entregas

Autenticação/persistência, avaliações RTM de cinco estrelas, reviews/comentários, favoritos autenticados, trailers, compartilhamento público e séries/temporadas/episódios dependem dos próximos contratos e integrações. As respectivas ações do detalhe ficam indisponíveis e identificadas como futuras; o antigo booleano local de favorito não representa mais um favorito autenticado.

A navegação inferior anterior foi substituída na rodada seguinte por Descobrir/Buscar/Favoritos/Perfil, conforme o protótipo. Favoritos ainda apresenta uma indicação explícita de disponibilidade futura; autenticação e persistência não foram implementadas.

## Segunda entrega: navegação e busca

- NavigationBar com quatro destinos, indicador tonal em formato de cápsula, ícones e rótulos. Retirados o botão flutuante de busca e as notificações demonstrativas do corpo da Home.
- Busca integrada como aba; mantém texto, resultados e posição ao alternar destinos. Catálogo e busca conservam seus próprios MovieModernBloc. A busca só consulta o use case depois de digitar/submeter; limpar o campo volta à orientação inicial.
- Cabeçalhos simples, sem selo, gradiente ou brilho. A rota de busca independente também usa título “Buscar” e conserva o botão de voltar.
- HeroMode habilita os Heroes somente na aba ativa, permitindo que o mesmo filme apareça no catálogo e na busca sem conflito de tags.
- Suíte completa: **85 testes passaram**. O novo teste pesquisa, alterna abas, verifica preservação sem chamada adicional, abre/fecha o detalhe com o mesmo ID do catálogo e limpa o campo. Os testes de navegação/overflow foram atualizados para os quatro destinos.
- Hot restart/hot reload confirmados no Windows; barra observada no app. Busca e retorno pelo Hero verificados em teste de widget. Sem validação em aparelho móvel ou publicação.

Trabalho mantido na feature existente `feature/monorepo-foundation`, preservando as alterações anteriores de documentação e cabeçalho. O usuário solicitou commit e push das entregas em seguida; `devtools_options.yaml` permanece como configuração local fora dos commits. Merge, tag e publicação não fazem parte desse envio. Futuras features devem seguir o fluxo definido em CONTRIBUTING.md após integrar a base pendente.
