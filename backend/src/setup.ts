import { INestApplication } from '@nestjs/common';

export function configureApp(app: INestApplication): void {
  app.setGlobalPrefix('api/v1');
  app.getHttpAdapter().getInstance().disable('x-powered-by');
}
