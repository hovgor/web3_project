import { Injectable } from '@nestjs/common';
import { WalletAddressDto } from './dto/wallet.address.dto';

// import * as Web3 from 'web3';
// eslint-disable-next-line @typescript-eslint/no-unused-vars, @typescript-eslint/no-var-requires
const Web3 = require('web3');

@Injectable()
export class Web3Service {
  // constructor(){}

  async web3Function(data: WalletAddressDto) {
    console.log(data);
    const web3 = new Web3(
      Web3.givenProvider || 'ws://some.local-or-remote.node:8546',
    );
    web3.eth.getAccounts('0x779f4D42C30370382D8cb58f17D20373BD727c88');
    return;
  }
}
