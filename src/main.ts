import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv';
import { useSwagger } from './swagger/swagger';
dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  useSwagger(app);
  await app.listen(process.env.PORT);

  Logger.verbose(`Server is listening on http://localhost:${process.env.PORT}`);
}
bootstrap();
