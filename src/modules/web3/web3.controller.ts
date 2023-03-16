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
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AddBonusDto } from './dto/add.bonus.dto';
import { AddressDto } from './dto/address.dto';
import { GetWalletAddressDto } from './dto/gettwalletaddress.dto';
import { HashingSistemDto } from './dto/hashing.sistem.data.dto';
import { ToFixedNumberDto } from './dto/toFixNumber.dto';
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

  @Post('add_bonus_with_create')
  async addBonusWithCreate(@Res() res: Response, @Body() body: AddBonusDto) {
    try {
      const userBlock = await this.web3Service.giveBonusRegistration(
        body.username,
        body.userId,
      );
      return res.status(HttpStatus.OK).json(userBlock);
    } catch (error) {
      throw error;
    }
  }
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

  @Get('get-wallet-address-with-private-key')
  async getWalletAddressWithPrivateKey(
    @Res() res: Response,
    @Query() query: GetWalletAddressDto,
  ) {
    try {
      const address = await this.web3Service.getWalletAddressWithPrivateKey(
        query.privateKey,
      );
      return res.status(HttpStatus.OK).json(address);
    } catch (error) {
      throw error;
    }
  }
  @Post('toFixNumber')
  async toFixNumber(@Res() res: Response, @Body() body: ToFixedNumberDto) {
    try {
      if (!body.num) {
        return res.status(HttpStatus.OK).json(null);
      }
      const splitNum = body.num.toString().split('.');
      if (!splitNum[1]) {
        return res.status(HttpStatus.OK).json(body.num);
      }
      return res
        .status(HttpStatus.OK)
        .json(Number(body.num.toFixed(splitNum[0].length > 1 ? 0 : 1)));
    } catch (error) {
      throw error;
    }
  }

  @Get('getCMN')
  async getCMN(@Res() res: Response) {
    try {
      const getFreeTokens = await this.web3Service.getFreeTokens();
      return res.status(HttpStatus.OK).json(getFreeTokens);
    } catch (error) {
      throw error;
    }
  }

  @Get('getHtmlFile')
  async getHtmlFile(@Req() req: Request, @Res() res: Response) {
    res.sendFile(
      '/home/gor/Desktop/projects/web3-transactions/src/modules/index.html',
    );
  }
}
