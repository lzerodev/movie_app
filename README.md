# I Rate That Movie

Monorepositório do aplicativo de filmes: Flutter no frontend, API TypeScript/NestJS e infraestrutura Docker com destino inicial AWS Lightsail.

## Estrutura

```text
frontend/             Aplicativo Flutter, plataformas, assets, testes e screenshots
backend/              API NestJS, testes HTTP e Dockerfile
infra/docker/         Compose local e modelo de produção
infra/caddy/          Proxy reverso e HTTPS
infra/aws/            Roteiro de provisionamento do Lightsail
docs/                 Arquitetura, roteiro e documentação histórica
.github/workflows/    Verificações de frontend, backend e infraestrutura
```

`backend/` é a API. Não existe uma segunda aplicação `api/`.

## Estado desta entrega

- O frontend existente foi movido para `frontend/`; o pacote Dart continua `movie_app` e os identificadores das plataformas foram preservados.
- A API possui somente `GET /api/v1/health`, um teste HTTP e módulos reservados para `auth`, `users` e `favorites`.
- O Compose define PostgreSQL persistente, mas a API ainda **não possui driver, conexão, entidades ou migrations de banco**.
- O Flutter continua usando a integração de filmes existente; ainda não consome o novo backend.
- O arquivo de produção é uma base para validação. Não há recursos AWS provisionados nem deploy automático configurado.

## Frontend

Versão fixada em `.flutter-version`: **Flutter 3.50.0 / Dart 3.14.0**. Android usa **Gradle 9.5.0 / AGP 9.3.1**, Kotlin integrado ao AGP e Java 26 para executar o build. O bytecode Java/Kotlin é direcionado a Java 17. Confira o [guia da cadeia de build](docs/BUILD_TOOLCHAIN.md) antes de executar com um SDK antigo.

```powershell
cd frontend
flutter pub get
# Se não houver configuração local, copie .env.example para .env e configure o TMDB.
# O código atual também importa lib/core/utils/secrets.dart; siga frontend/README.md.
flutter run
```

As configurações locais existentes foram movidas junto com o app. Arquivos `.env` e `secrets.dart` permanecem ignorados. Configuração incluída no bundle Flutter pode ser extraída; credenciais de banco, tokens de backend e outros segredos não devem ser colocados nele.

Guia detalhado: [frontend/README.md](frontend/README.md).

## Backend sem Docker

Requer Node.js 24 e npm. No Windows, use `npm.cmd` se a política do PowerShell bloquear `npm.ps1`.

```powershell
cd backend
npm ci
npm run build
npm start
```

Acesse `http://localhost:3000/api/v1/health`. A resposta confirma apenas que a API está respondendo. Para carregar um `.env` local, copie `backend/.env.example` para `backend/.env` e execute `node --env-file=.env dist/main.js`.

## API e PostgreSQL com Docker

Comandos a partir da raiz, com Docker Desktop Linux em execução:

```powershell
Copy-Item infra/docker/.env.example infra/docker/.env
# Edite infra/docker/.env e defina POSTGRES_PASSWORD.
docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml up --build -d
docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml ps
```

API em `127.0.0.1:3000` e PostgreSQL em `127.0.0.1:5432`. A publicação em loopback evita exposição na rede local. Em emulador Android, `10.0.2.2` normalmente representa o host; em aparelho físico será necessário configurar acesso de desenvolvimento específico.

O volume nomeado mantém os dados ao recriar containers. Um volume não substitui backup. Para parar preservando o volume:

```powershell
docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml down
```

Depois de alterar código da API, execute novamente `up --build -d`.

## Verificação

```powershell
# Dentro de frontend/
flutter analyze
flutter test

# Dentro de backend/
npm ci
npm run typecheck
npm test
```

Os workflows usam os novos diretórios. A configuração fictícia criada pelo CI Flutter serve para compilar e testar, não para chamar o TMDB real ou distribuir uma versão utilizável.

## Evolução

- [Arquitetura e limites atuais](docs/ARCHITECTURE.md)
- [Skills e MCP Flutter/Dart no Codex](docs/AI_TOOLING.md)
- [Roteiro de estudos e entregas](docs/ROADMAP.md)
- [Preparação para AWS Lightsail](infra/aws/README.md)
- [Validação desta reorganização](docs/REORGANIZATION.md)
- [Contribuição](CONTRIBUTING.md)

Documentos anteriores foram preservados em `docs/flutter-history/`. Eles registram o histórico do frontend e podem conter comandos relativos à antiga raiz e resultados que não foram revalidados.
