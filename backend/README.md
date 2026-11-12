# API — RTM (Rate That Movie)

API NestJS com Node.js 24 e TypeScript. Esta primeira entrega estabelece compilação, teste HTTP e empacotamento Docker.

## Executar

```powershell
npm ci
npm run build
npm start
```

Endpoint disponível: `GET http://localhost:3000/api/v1/health`.

Para recompilar automaticamente, execute `npm run build:watch` em um terminal e `npm run start:dev` em outro. `start:dev` monitora `dist/` e carrega `.env` se ele existir; requer um build inicial.

## Organização

- `src/main.ts`: inicialização e validação da porta.
- `src/setup.ts`: prefixo público `/api/v1`.
- `src/modules/health`: liveness HTTP; não valida PostgreSQL.
- `src/modules/auth`, `users`, `favorites`: módulos vazios reservados, sem endpoints.
- `test/health.test.cjs`: teste HTTP real com porta temporária e encerramento da aplicação.
- `Dockerfile`: build em múltiplos estágios e execução como usuário `node`.

## Próxima entrega

Escolher a camada de acesso ao PostgreSQL e criar migrations; implementar cadastro/login e autorização por usuário antes dos endpoints de favoritos. Adicionar validação de DTOs, limites de requisições, testes de integração com banco e especificação OpenAPI conforme os contratos forem implementados.

O PostgreSQL definido no Compose ainda não é acessado por esta API. CORS para Flutter Web será configurado com origens explícitas quando houver integração. O app nativo não depende de CORS.
