import {
  Body,
  Controller,
  Get,
  HttpStatus,
  Post,
  Query,
  Req,
  Res,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AddressDto } from './dto/address.dto';
import { WalletAddressDto } from './dto/wallet.address.dto';
import { Web3Service } from './web3.service';

@ApiTags('Web3')
@Controller('web3')
export class Web3Controller {
  constructor(private readonly web3Service: Web3Service) {}

  @Post('/')
  async web3Data(@Res() res: Response, @Body() body: WalletAddressDto) {
    try {
      const newWeb3 = await this.web3Service.web3Transaction(body);
      return res.status(HttpStatus.OK).json({
        data: newWeb3,
        error: false,
        message: 'Transaction is done!',
      });
    } catch (error) {
      throw error;
    }
  }

  @Get('/transactionCount')
  async getTransactionWhitAddress(
    @Res() res: Response,
    @Query() address: AddressDto,
  ) {
    try {
      const getTransactionCount = await this.web3Service.getTransaction(
        address.address,
      );
      return res.status(HttpStatus.OK).json(getTransactionCount);
    } catch (error) {
      throw error;
    }
  }

  @Get('/balance')
  async getBalanceWhitAddress(
    @Res() res: Response,
    @Query() address: AddressDto,
  ) {
    try {
      const getBalanceCount = await this.web3Service.getBalance(
        address.address,
      );
      return res.status(HttpStatus.OK).json(getBalanceCount);
    } catch (error) {
      throw error;
    }
  }
}
