import { Body, Controller, Post, Res } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { WalletAddressDto } from './dto/wallet.address.dto';
import { Web3Service } from './web3.service';

@ApiTags('Web3')
@Controller('web3')
export class Web3Controller {
  constructor(private readonly web3Service: Web3Service) {}

  @Post('/')
  async web3Data(@Res() res: Response, @Body() body: WalletAddressDto) {
    try {
      const newWeb3 = this.web3Service.web3Function(body);
      return res.send(newWeb3);
    } catch (error) {
      throw error;
    }
  }
}
