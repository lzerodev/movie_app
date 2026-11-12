const { test } = require('node:test');
const assert = require('node:assert/strict');
require('reflect-metadata');
const { NestFactory } = require('@nestjs/core');
const { AppModule } = require('../dist/app.module');
const { configureApp } = require('../dist/setup');

test('API responde na rota versionada e não expõe funcionalidades ainda pendentes', async () => {
  const app = await NestFactory.create(AppModule, { logger: false });
  configureApp(app);
  try {
    await app.listen(0, '127.0.0.1');
    const baseUrl = await app.getUrl();
    const response = await fetch(`${baseUrl}/api/v1/health`);
    assert.equal(response.status, 200);
    assert.equal(response.headers.get('x-powered-by'), null);
    assert.deepEqual(await response.json(), {
      status: 'ok', service: 'rtm-api',
    });
    for (const path of ['/health', '/api/v1/favorites', '/api/v1/auth']) {
      assert.equal((await fetch(`${baseUrl}${path}`)).status, 404);
    }
  } finally {
    await app.close();
  }
});
