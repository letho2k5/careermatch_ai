import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import * as Joi from 'joi';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validationSchema: Joi.object({
        NODE_ENV: Joi.string()
          .valid('development', 'test', 'production')
          .default('development'),
        HOST: Joi.string().trim().min(1).default('0.0.0.0'),
        PORT: Joi.number().port().default(3000),
        API_PREFIX: Joi.string()
          .pattern(/^[a-zA-Z0-9]+(?:\/[a-zA-Z0-9_-]+)*$/)
          .default('api/v1'),
        CORS_ORIGINS: Joi.string()
          .trim()
          .min(1)
          .default('http://localhost:8080,http://127.0.0.1:8080'),
      }),
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
