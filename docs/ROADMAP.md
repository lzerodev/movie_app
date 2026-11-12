# Estudos e entregas

O estudo acompanha pequenas entregas verificáveis no aplicativo existente.

## Prioridade de produto e design — 12/11/2026

Primeiros [fluxos e wireframes editáveis no Figma](https://www.figma.com/design/sN2K94VEzLqBs7bq1BkW6g?node-id=4-1394) criados: 14 telas-base, variantes de séries, painéis auxiliares e leitura pública desktop. O protótipo HTML claro/escuro foi aprovado, e o usuário autorizou iniciar o desenvolvimento preservando BLoC e Hero. A [primeira entrega Flutter](UI_IMPLEMENTATION.md) aplica os temas e atualiza catálogo/detalhe. Telas e contratos das novas capacidades continuam no backlog.

O usuário definiu o foco em reviews, comentários e dicas de filmes e séries, com trailers e links compartilháveis. Seguir o [plano de produto e design](PRODUCT_AND_DESIGN_PLAN.md) e continuar as entregas pequenas após a aprovação visual. A sequência técnica abaixo é anterior a essa ampliação e deverá ser refinada para os contratos de séries, comentários e leitura pública web.

## Sequência técnica de referência

Decisões posteriores confirmadas: leitura de links compartilhados é pública (sinopse, notas e comentários), com login apenas para participar; notas RTM usam cinco estrelas com meias estrelas; séries, temporadas e episódios são avaliáveis desde o primeiro escopo. A leitura pública substitui a resposta anterior que exigia login para ler. O backlog deverá contemplar a identidade de cada nível e o retorno ao destino e à ação após autenticação.

1. **Base do monorepositório:** frontend separado, API mínima, Docker e CI. Validar Flutter no novo caminho e os containers com Docker Linux em execução.
2. **Persistência do backend:** escolher acesso ao PostgreSQL, criar migrations e testar escrita/leitura em banco descartável. Definir os contratos HTTP.
3. **Identidade:** cadastro/login, armazenamento adequado de credenciais, validação de tokens e autorização por usuário. Testar isolamento entre duas contas.
4. **Favoritos:** endpoints autenticados, restrição contra duplicatas e integração do repositório Flutter com a API. Fechar/reabrir o app deve recuperar os dados do servidor.
5. **Primeiro ambiente AWS:** provisionar Lightsail, domínio/HTTPS, publicação de imagem por commit, deploy controlado e monitoramento. Configurar backup fora da instância e testar restauração antes de dados reais.
6. **Avaliações e resenhas:** regras, validação, persistência e experiência do app.
7. **Publicação:** identidade visual, identificadores, assinatura das versões mobile, privacidade e validação em aparelhos reais. Publicação do backend não publica o app nas lojas.

Cada etapa deve registrar o que foi implementado, como verificar e o que continua pendente. O uso de Docker ou a aprovação de testes locais não confirma disponibilidade em produção.
