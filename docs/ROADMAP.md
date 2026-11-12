# Estudos e entregas

O estudo acompanha pequenas entregas verificáveis no aplicativo existente.

1. **Base do monorepositório:** frontend separado, API mínima, Docker e CI. Validar Flutter no novo caminho e os containers com Docker Linux em execução.
2. **Persistência do backend:** escolher acesso ao PostgreSQL, criar migrations e testar escrita/leitura em banco descartável. Definir os contratos HTTP.
3. **Identidade:** cadastro/login, armazenamento adequado de credenciais, validação de tokens e autorização por usuário. Testar isolamento entre duas contas.
4. **Favoritos:** endpoints autenticados, restrição contra duplicatas e integração do repositório Flutter com a API. Fechar/reabrir o app deve recuperar os dados do servidor.
5. **Primeiro ambiente AWS:** provisionar Lightsail, domínio/HTTPS, publicação de imagem por commit, deploy controlado e monitoramento. Configurar backup fora da instância e testar restauração antes de dados reais.
6. **Avaliações e resenhas:** regras, validação, persistência e experiência do app.
7. **Publicação:** identidade visual, identificadores, assinatura das versões mobile, privacidade e validação em aparelhos reais. Publicação do backend não publica o app nas lojas.

Cada etapa deve registrar o que foi implementado, como verificar e o que continua pendente. O uso de Docker ou a aprovação de testes locais não confirma disponibilidade em produção.
