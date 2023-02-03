import {
  Body,
  Controller,
  Get,
  HttpStatus,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AddressDto } from './dto/address.dto';
import { HashingSistemDto } from './dto/hashing.sistem.data.dto';
import { WalletAddressDto } from './dto/wallet.address.dto';
import { Web3Service } from './web3.service';

@ApiTags('Web3')
@Controller('web3')
export class Web3Controller {
  constructor(private readonly web3Service: Web3Service) {}

  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'endpoint for transaction.',
  })
  @Post('/transaction')
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

  @Get('/receipt')
  async getTransactionReceipt(
    @Res() res: Response,
    @Query() address: AddressDto,
  ) {
    try {
      const transactionReceipt = await this.web3Service.getTransactionReceipt(
        address.address,
      );
      return res.status(HttpStatus.OK).json(transactionReceipt);
    } catch (error) {
      throw error;
    }
  }
  //

  //

  //
  @Get('/mnemonic-faz')
  async getMnemonicWords(@Res() res: Response) {
    try {
      const faz12 = await this.web3Service.generateMnemonic();

      return res.status(HttpStatus.OK).json(faz12);
    } catch (error) {
      throw error;
    }
  }

  @Get('credentional')
  async createWallet(@Res() res: Response) {
    try {
      const walletAddress = await this.web3Service.getCredentialByMnemonic();

      return res.status(HttpStatus.OK).json(walletAddress);
    } catch (error) {
      throw error;
    }
  }

  @Post('heashing-sistem')
  async heashString(@Res() res: Response, @Body() body: HashingSistemDto) {
    try {
      const hash = await this.web3Service.hashingSistemForString(
        body.codeForHashing,
      );
      return res.status(HttpStatus.ACCEPTED).json(hash);
    } catch (error) {
      throw error;
    }
  }
  @Post('decode-heashing-sistem')
  async decodeHeashString(
    @Res() res: Response,
    @Body() body: HashingSistemDto,
  ) {
    try {
      const hash = await this.web3Service.decodeHashingString(
        body.codeForHashing,
      );
      return res.status(HttpStatus.ACCEPTED).json(hash);
    } catch (error) {
      throw error;
    }
  }
}
