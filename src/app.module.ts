import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from './config/config.module';
import { Web3Module } from './modules/web3/web3.module';
import { UsersModule } from './modules/users/users.module';

@Module({
  imports: [ConfigModule, Web3Module, UsersModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
