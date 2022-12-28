import { Injectable, Logger } from '@nestjs/common';
import { WalletAddressDto } from './dto/wallet.address.dto';
// eslint-disable-next-line @typescript-eslint/no-unused-vars, @typescript-eslint/no-var-requires
const Web3 = require('web3');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const TX = require('@ethereumjs/tx').Transaction;

@Injectable()
export class Web3Service {
  // constructor(){}
  // privateKay = Buffer.from(process.env.PRIVATE_KAY, 'hex');

  async web3Transaction(data: WalletAddressDto) {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      // network ID
      const networkId: number = await web3.eth.net.getId();
      console.log('network ID => ', networkId);

      // default gas price
      let gasPrice: number | string = process.env.GAS_PRICE;
      if (!gasPrice) {
        await web3.eth
          .getGasPrice()
          .then((gasPriceDefault: number | string) => {
            gasPrice = gasPriceDefault;
            console.log(
              'Default gas price => ',
              web3.utils.toWei(gasPriceDefault, 'ether'),
            );
          });
      }

      // create transaction
      const createTransaction = await web3.eth.accounts.signTransaction(
        {
          // chaneId: networkId,
          from: data.fromAddress,
          to: data.toAddress,
          value: web3.utils.toWei(data.ethBalance, 'ether'),
          gas: gasPrice,
          // web3.utils.toWei(gasPrice, 'ether'),
        },
        process.env.PRIVATE_KAY2,
      );
      //
      //
      // await web3.eth.accounts.privKey;
      const createReceipt = await web3.eth.sendSignedTransaction(
        createTransaction.rawTransaction,
      );
      Logger.verbose(
        `Transaction successful with hash: ${createReceipt.transactionHash}`,
      );

      return createReceipt.transactionHash;
      //
    } catch (error) {
      Logger.error('Web3 transaction function ', error);
      throw error;
    }
  }

  // get transaction
  async getTransaction(req: string) {
    try {
      const web3 = new Web3(process.env.INFURA_URL);

      let countTransactions: string | number;
      await web3.eth.getTransactionCount(req).then((item: number | string) => {
        countTransactions = item;
        item;
      });

      return {
        data: countTransactions,
        error: false,
        message: 'this is transaction count',
      };
    } catch (error) {
      Logger.error('Get transaction count function ', error);
      throw error;
    }
  }

  async getBalance(address: string) {
    try {
      const web3 = new Web3(process.env.INFURA_URL);
      let balance: number | string;
      await web3.eth.getBalance(address).then((item: number | string) => {
        // convert to ether
        const etrBal = web3.utils.fromWei(item, 'ether');
        balance = etrBal;
        console.log(`${address} balance = `, balance);
      });
      return {
        data: balance,
        error: false,
        message: `This is the balance of this ${address} wallet.`,
      };
    } catch (error) {
      Logger.error('Get balance function!!! ', error);
      throw error;
    }
  }
}
