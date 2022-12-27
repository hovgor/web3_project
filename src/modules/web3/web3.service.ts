import { Injectable } from '@nestjs/common';
import { WalletAddressDto } from './dto/wallet.address.dto';
// import * as fs from 'fs';
// import * as Web3 from 'web3';
// eslint-disable-next-line @typescript-eslint/no-unused-vars, @typescript-eslint/no-var-requires
const Web3 = require('web3');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const TX = require('@ethereumjs/tx').Transaction;

@Injectable()
export class Web3Service {
  // constructor(){}
  // privateKay = Buffer.from(process.env.PRIVATE_KAY, 'hex');

  async web3Function(data: WalletAddressDto) {
    const web3 = new Web3(process.env.INFURA_URL);
    // network ID
    const networkId = await web3.eth.net.getId();
    console.log('network ID => ', networkId);

    const gasPrice = await web3.eth.getGasPrice().then(console.log);
    // create transaction
    const createTransaction = await web3.eth.accounts.signTransaction(
      {
        // chaneId: networkId,
        from: data.fromAddress,
        to: data.toAddress,
        value: web3.utils.toWei(data.ethBalance, 'ether'),
        gas: 21000,
        // web3.utils.toWei(gasPrice, 'ether'),
      },
      process.env.PRIVATE_KAY,
    );
    console.log(createTransaction);
    await web3.eth.accounts.privKey;
    const createReceipt = await web3.eth.sendSignedTransaction(
      createTransaction.rawTransaction,
    );
    console.log(
      `Transaction successful with hash: ${createReceipt.transactionHash}`,
    );

    return createReceipt.transactionHash;
  }

  // get transaction
  async getTransaction(req: string) {
    try {
      const web3 = new Web3(process.env.INFURA_URL);

      let countTransactions: string | number;
      await web3.eth.getTransactionCount(req).then((item) => {
        countTransactions = item;
        item;
      });

      return {
        data: countTransactions,
        error: false,
        message: 'this is transaction count',
      };
    } catch (error) {
      throw error;
    }
  }
}

//
//
//

// const createTransaction = await web3js.eth.accounts.signTransaction(
//   {
//       from: addressFrom,
//       to: addressTo,
//       value: web3js.utils.toWei('0.0000001', 'ether'),
//       gas: 21000
//   },
//   privKey
// );
// console.log(createTransaction);
// web3js.eth.accounts.privKey
// // Deploy transaction
// const createReceipt = await web3js.eth.sendSignedTransaction(
//   createTransaction.rawTransaction
// );

//
//

//

//
//
//tx transaction
// const tx = new TX(createTransaction, { chain: 'ropsten' });
// console.log('tx => ', tx);

// // signed transaction
// const signedTx = tx.sign(process.env.PRIVATE_KAY);
// console.log('signedTx => ', signedTx);

// const serializedTx = signedTx.serialize();
// console.log('serialized Tx => ', serializedTx);

// const sendSigne = await web3.eth
//   .sendSignedTransaction('0x' + serializedTx.toString('hex'))
//   .on('receipt', console.log);
// console.log('sendSigned Transaction => ', sendSigne);

// const PK = await web3.eth.accounts.privateKeyToAccount(
//   process.env.PRIVATE_KAY,
// );
// console.log('PK => ', PK);

// const transaction = await web3.eth.accounts
//   .signTransaction(
//     {
//       to: data.toAddress,
//       value: '1000000000',
//       gas: 2000000,
//     },
//     process.env.PRIVATE_KAY,
//   )
//   .then();

// console.log(transaction);

// const transactiona = await web3.eth
//   .getTransaction(transaction.messageHash)
//   .then(console.log);

// const transaction = await web3.eth.sendTransaction({
//   from: data.fromAddress,
//   to: data.toAddress,
//   value: 1,
// });

// await web3.eth.accounts.privateKeyToAccount(this.privateKay);
// // Deploy transaction
// const createReceipt = await web3.eth.sendSignedTransaction(
//   createTransaction.rawTransaction,
// );
//
//
//
//

// const myContract = new web3.eth.Contract();
// console.log(networkId);
// const private_kay = "fead8d9413ef183f939a7904fc84e59334b4e6f59cc155384c871538291835de";
//
//
// const bal = accaunt.
// console.log(accaunt);
// console.log(balance);
//
//
//

///
///
//
// password = gorqwe123!ASD111;
// const API_KAY = "9ef8d4dea21a4552b5849c80605b0e2c"
//
//const api_kay = "7381e258654c43eca8a8dd0d03653f14"
//const url = "https://celo-mainnet.infura.io/v3/7381e258654c43eca8a8dd0d03653f14"
//
//

//  {
//   "address":"0x3375e1ea6cacafb98d8fb139653a445e44754de0",
//   "crypto":{
//     "kdf":"pbkdf2",
//     "kdfparams":
//      {
//       "c":262144,
//       "dklen":32,
//       "prf":"hmac-sha256",
//       "salt":"b196e6f49ce9ef3f41e43e832e5a94525ad49bf4af7aab618fb112ddc6e5a36a"
//     },
//     "cipher":"aes-128-ctr",
//     "ciphertext":"3612409dc713168bb4fff89284cb4e5d559009df5bac554509a669471328de00",
//     "cipherparams":
//     {
//       "iv":"b9342a7ed469a3363d50557e70f197fd"
//     },
//     "mac":"5cb98f64b2633360f40094da5d7fd0f1c1940a79153ad8f2526b0e6061cccdaf"
//   },
//   "id":"8a3c1fa8-0883-4646-90b3-88c30ccb38f0",
//   "version":3
// }

// const getBalance = async () => {
// const balance = web3.utils.fromWei(
//   await web3.eth.getBalance(address),
//   "ether"
// );
//

//
// const address = '0x779f4D42C30370382D8cb58f17D20373BD727c88';

// const balance = await web3.eth
//   .getBalance(address)
//   .then((result) => web3.utils.fromWei(result, 'ether'));
// await web3.eth.getBalance(address, function (error, wei) {
//   if (!error) {
//     const balance2 = web3.utils.fromWei(wei, 'ether');
//     console.log(balance2 + ' ETH');
//   }
// });
//
