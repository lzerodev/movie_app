# Arquitetura — I Rate That Movie

## Separação de responsabilidades

O repositório contém três partes. `frontend/` é o cliente Flutter existente; `backend/` é a API NestJS; `infra/` define como executar os serviços. A API é parte do backend, não um quarto projeto.

O frontend mantém apresentação/BLoC, domínio e implementações de acesso a dados. Nesta reorganização não houve alteração de comportamento no código Dart. O backend começa com um único processo organizado por módulos; autenticação, usuários e favoritos ainda são estruturas vazias.

## Fluxo alvo

```text
Flutter → HTTPS → Caddy → API NestJS → PostgreSQL
                                     │
                                     └→ provedor de filmes, quando integrado
```

Esse fluxo é o destino arquitetural. Atualmente o Flutter ainda chama o provedor de filmes pela integração anterior e o NestJS só responde ao endpoint de saúde.

## Desenvolvimento

Flutter roda pelo SDK local. O Compose local constrói a imagem da API e inicia PostgreSQL 17 com volume nomeado. As portas publicadas ficam em loopback. A API pode rodar fora do Docker para desenvolvimento com recompilação automática.

## Produção inicial

Destino escolhido: uma instância Linux no AWS Lightsail. O Compose de produção é independente do local e publica somente 80/443 pelo Caddy. API e PostgreSQL não têm portas publicadas no host; PostgreSQL está na rede interna `data`.

A API será distribuída como imagem versionada. O arquivo aceita `API_IMAGE` para uma tag baseada no commit ou digest. Ainda não há pipeline de publicação da imagem, credenciais de registry, provisionamento ou deploy remoto.

API e banco na mesma instância compartilham um ponto de falha. A configuração inicial precisa de backup externo e restauração validada antes de armazenar dados reais. A separação futura do banco exige migração operacional e configuração de conexão, sem mudar o contrato HTTP do Flutter.

## Dados e identidade

Modelo proposto, ainda não implementado: usuários e favoritos com unicidade em `(user_id, movie_id)`. A API deverá obter o usuário da sessão/token validado e restringir cada operação ao proprietário. Receber um `user_id` do aplicativo não comprova identidade.

O mecanismo de autenticação e a biblioteca de acesso ao banco serão definidos na próxima entrega. Notas, resenhas e lista para assistir são entregas posteriores.

## Configuração

Arquivos reais de ambiente não são versionados. O `.env` existente do Flutter foi movido sem leitura de seu conteúdo. Configuração distribuída no cliente não é um cofre de segredos; credenciais do banco e segredos de autenticação pertencem ao servidor.

Os arquivos de exemplo de infraestrutura exigem uma senha explícita para iniciar o PostgreSQL. Alterar a variável depois de inicializar um volume existente não troca a senha do usuário já criado; a rotação precisa ser realizada no banco.
