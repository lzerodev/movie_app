# AWS Lightsail — roteiro de publicação

Esta pasta reserva o provisionamento AWS. Nenhum recurso foi criado e não há credenciais AWS no repositório. Scripts Terraform/Ansible entram quando região, domínio, orçamento e estratégia de acesso forem definidos.

## Destino inicial

- Instância Linux, inicialmente com 2 GB de RAM; confirmar capacidade por medição.
- Docker Engine e Compose plugin.
- Endereço público estável e DNS do subdomínio da API.
- Somente HTTP/HTTPS públicos; SSH restrito aos administradores.
- Volume PostgreSQL, backups fora da instância e restauração validada.

A API ainda não tem autenticação, favoritos, migrations ou conexão com PostgreSQL. Este roteiro não caracteriza uma versão pronta para usuários.

## Preparar a imagem

Na raiz, com Docker funcionando:

```sh
docker build -t irate-movie-api:local backend
```

A futura automação deve testar, construir e publicar uma imagem por commit em um registry definido (por exemplo, ECR). Não há publicação automática nesta entrega.

## Configurar o servidor

Copie o diretório `infra/` preservando a estrutura de caminhos. Crie `infra/docker/.env.production` a partir de `.env.production.example` e preencha `API_IMAGE`, `API_DOMAIN`, `ACME_EMAIL` e uma senha própria do PostgreSQL. Configure DNS/firewall antes de solicitar certificados. Proteja o arquivo para acesso somente do administrador/serviço de deploy.

Os comandos abaixo usam **somente** o arquivo de produção. Não o combine com `compose.yaml`, pois o arquivo local publica portas de desenvolvimento.

```sh
docker compose --env-file infra/docker/.env.production -f infra/docker/compose.production.yaml config --quiet
docker compose --env-file infra/docker/.env.production -f infra/docker/compose.production.yaml pull
docker compose --env-file infra/docker/.env.production -f infra/docker/compose.production.yaml up -d
docker compose --env-file infra/docker/.env.production -f infra/docker/compose.production.yaml ps
```

Use uma tag imutável ou digest em `API_IMAGE`. O endpoint `/api/v1/health` verifica apenas liveness. Readiness com banco, monitoramento externo e alertas são pendências da publicação.

## Backup e atualização

Volume e snapshots da máquina não substituem uma estratégia de recuperação do banco. Definir rotina de backup consistente do PostgreSQL, retenção, criptografia, armazenamento fora da instância e teste de restauração. O Compose ainda não automatiza essa rotina.

Antes de atualizar: registrar a imagem anterior, criar backup verificado e planejar a compatibilidade das migrations. Voltar a imagem da API não desfaz automaticamente mudanças de banco. Não executar comandos que removam volumes para realizar atualização.
