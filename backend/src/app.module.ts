import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { FavoritesModule } from './modules/favorites/favorites.module';
import { HealthModule } from './modules/health/health.module';

@Module({ imports: [AuthModule, UsersModule, FavoritesModule, HealthModule] })
export class AppModule {}
