import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  check(): { status: string; service: string } {
    // Liveness: confirma o processo HTTP, não a conexão com o banco.
    return { status: 'ok', service: 'i-rate-that-movie-api' };
  }
}
