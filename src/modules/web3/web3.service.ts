import { Injectable, Logger } from '@nestjs/common';
import { WalletAddressDto } from './dto/wallet.address.dto';
import * as bip39 from 'bip39';
// eslint-disable-next-line @typescript-eslint/no-unused-vars, @typescript-eslint/no-var-requires
// const Web3 = require('web3');
// import ControlAbi from './smartContracts/ABI/control.abi.json';
import * as PointAbi from './smart_contracts/point.abi.json';
import { Wallet, providers, ContractFactory } from 'ethers';
import fs from 'fs';
import path from 'path';
import * as ethers from 'ethers';
import { use, POSClient } from '@maticnetwork/maticjs';
import { Web3ClientPlugin } from '@maticnetwork/maticjs-web3';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const crypto = require('crypto');
import {
  ContractAddressBonus,
  ContractAddressPoint,
} from './constants/smart_contract_address';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const Web3 = require('web3');
import {} from 'web3-eth-abi';

// const web3 = new Web3(process.env.CRYPTO_URL);
// const parentProvider = new providers.JsonRpcProvider(rpc.parent);
// const childProvider = new providers.JsonRpcProvider(rpc.child);

// install web3 plugin
use(Web3ClientPlugin);
@Injectable()
export class Web3Service {
  // constructor(){}
  // privateKay = Buffer.from(process.env.PRIVATE_KAY, 'hex');
  constructor() {
    // this.web3 = new Web3(process.env.CRYPTO_URL);
  }
  async createWalletFile(): Promise<string> {
    const file = path.join(__dirname, 'polygon-wallet');
    if (!fs.existsSync(file)) {
      fs.mkdirSync(file);
    }
    return file;
  }

  async generateWallet(file: string): Promise<Wallet> {
    const provider = new providers.InfuraProvider(
      'polygon',
      process.env.INFURA_URL as string,
    );
    const wallet = await Wallet.createRandom();
    const keystore = wallet.encrypt('password');
    const keystoreFileName = path.join(
      file,
      `UTC--${new Date().toISOString()}--${wallet.address}`,
    );
    fs.writeFileSync(keystoreFileName, JSON.stringify(keystore), 'utf-8');
    return wallet;
  }

  async deploySmartContract(wallet: Wallet): Promise<void> {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const contractJson = require('./smartContracts/ABI/control.abi.json');
    const contractFactory = new ContractFactory(
      contractJson.abi,
      contractJson.bytecode,
      wallet,
    );
    const contract = await contractFactory.deploy();
    console.log('Smart contract deployed at:', contract.address);
  }

  // generate mnemonic seed phrase 12 words
  async generateMnemonic(): Promise<string> {
    const mnemonic: string = bip39.generateMnemonic();
    return mnemonic;
  }

  async getCredentialByMnemonic() {
    const seed: string = ethers.Wallet.createRandom().mnemonic.phrase;
    const wallet = ethers.Wallet.fromMnemonic(seed, "m/44'/60'/0'/0/0");
    const address = wallet.address;
    const privateKey = wallet.privateKey;
    return { address, privateKey };
  }

  async createTransaction(
    privateKey: string,
    fromAddress: string,
    toAddress: string,
    price: string,
  ) {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);

      let gasPrice: number | string | undefined = process.env.GAS_PRICE;

      if (!gasPrice) {
        await web3.eth
          .getGasPrice()
          .then((gasPriceDefault: number | string) => {
            gasPrice = gasPriceDefault;
          });
      }
      const transaction = await web3.eth.accounts.signTransaction(
        {
          from: fromAddress,
          to: toAddress,
          value: web3.utils.toWei(price, 'ether'),
          gas: gasPrice,
        },
        privateKey,
      );

      return { transaction, gasPrice };
    } catch (error) {
      throw error;
    }
  }

  async giveBonusRegistration(username: string, userId: number | string) {
    try {
      if (!username && !userId) {
        throw 'username or user id is not found';
      }
      const accauntPrivatKey = this.getCredentialByMnemonic();
      const address = (await accauntPrivatKey).address;
      const transaction = await this.createTransaction(
        process.env.PRIVATE_KAY,
        process.env.DEFAULT_ADDRESS,
        await address,
        process.env.DEFAULT_PRICE,
      );

      return transaction;
    } catch (error) {
      throw error;
    }
  }
  //
  //tag forest wealth fabric slim foil spread damage toward casino ensure essay
  // [Nest] 1562808  - 02/03/2023, 11:52:50 AM     LOG [object Object]
  // Promise { '0xeD324cD3585C675F8B141dB18988423C309d71d2' }
  //            0xeD324cD3585C675F8B141dB18988423C309d71d2
  // 0xcae4bdb4dcb76aed29d89bce96a9e6a75a0d389205ffd293bead62de7b1bcfa8
  //
  //
  //
  //
  //
  //
  //
  //
  async web3Transaction(data: WalletAddressDto) {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      // const web3 = new Web3(process.env.CRYPTO_URL);
      const networkId: number = await web3.eth.net.getId();
      console.log('network ID => ', networkId);
      // const contract = new Web3.eth.Contract(bonusAbi, ContractAddressBonus);
      // default gas price
      let gasPrice: number | string = process.env.GAS_PRICE;
      if (!gasPrice) {
        await web3.eth
          .getGasPrice()
          .then((gasPriceDefault: number | string) => {
            gasPrice = gasPriceDefault;
          });
      }

      // create transaction
      const createTransaction = await web3.eth.accounts.signTransaction(
        {
          // chaneId: networkId,
          from: data.fromAddress,
          to: data.toAddress,
          value: web3.utils.toWei(data.ethBalance, 'ether'),
          gas: web3.utils.toWei(gasPrice, 'ether'),
          // gasLimit: this.web3.utils.toHex(21000),
        },
        process.env.PRIVATE_KAY,
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
      const web3 = new Web3(process.env.CRYPTO_URL);

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

  async getWalletAddressWithPrivateKey(privateKey: string) {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      const account = web3.eth.accounts.privateKeyToAccount(privateKey);
      const address = account.address;
      return address;
    } catch (error) {
      throw error;
    }
  }

  async getBalance(address: string) {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      // const contract = new Web3.eth.Contract(ControlAbi, address);
      // const web3 = new Web3(process.env.CRYPTO_URL);
      let balance: number | string;
      await web3.eth.getBalance(address).then((item: number | string) => {
        // convert to ether
        //TODO
        // const etrBal = this.web3.utils.fromWei(item, 'ether');
        // balance = etrBal;
        // console.log(`${address} balance = `, balance);
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
  async getTransactionReceipt(address: string) {
    try {
      // const web3 = new Web3(process.env.CRYPTO_URL);
      // let receipt: string | number;
      // await web3.eth
      //   .getTransactionReceipt(address)
      //   .then((item: number | string) => {
      //     receipt = item;
      //   });
      // console.log(11111111);
      // return receipt;
    } catch (error) {
      Logger.error('');
      throw error;
    }
  }
  initVector = crypto.randomBytes(16);
  Securitykey = crypto.randomBytes(32);
  async hashingSistemForString(text: string) {
    const algorithm = 'aes-256-cbc';
    const cipher = crypto.createCipheriv(
      algorithm,
      this.Securitykey,
      this.initVector,
    );
    let encryptedData = cipher.update(text, 'utf-8', 'hex');
    encryptedData += cipher.final('hex');
    return encryptedData;
  }

  async decodeHashingString(text: string) {
    const algorithm = 'aes-256-cbc';

    const decipher = crypto.createDecipheriv(
      algorithm,
      this.Securitykey,
      this.initVector,
    );

    let decryptedData = decipher.update(text, 'hex', 'utf-8');

    decryptedData += decipher.final('utf8');

    return decryptedData;
  }
  //
  //
  //

  async sendData() {
    try {
      console.log(process.env.CRYPTO_URL);
      const web3 = new Web3(process.env.CRYPTO_URL);

      const contract = new web3.eth.Contract(
        PointAbi as any,
        ContractAddressPoint,
      );
      const _fromAddress = process.env.DEFAULT_ADDRESS;
      const _fromKey = process.env.PRIVATE_KAY;

      console.log('Initiating Transaction ');

      const transactionABI = contract.methods.getFreeCmnToken().encodeABI();
      console.log(1);
      const estimate_gas = await web3.eth.estimateGas({
        from: _fromAddress,
        to: ContractAddressPoint,
        data: transactionABI,
      });
      console.log(2);
      const transactionParameters = {
        to: ContractAddressPoint,
        from: _fromAddress,
        data: transactionABI,
        chainId: 80001,
        gas: estimate_gas,
      };
      console.log(3);
      const signTransaction = await web3.eth.accounts.signTransaction(
        transactionParameters,
        _fromKey,
      );
      const sentTx = await web3.eth.sendSignedTransaction(
        signTransaction.rawTransaction,
      );
      console.log('transaction hash: ', sentTx);
      // return sentTx.status;
    } catch (error) {
      Logger.error(error);
      throw error;
    }
  }

  public async getBalanceForCmn() {
    const web3 = new Web3(process.env.CRYPTO_URL);

    const contract = new web3.eth.Contract(
      PointAbi as any,
      ContractAddressPoint,
    );
    const user = await this.getCurrentAccount();

    const getB = await contract.methods.getBalance(0, user.address).call();
    const cmnPrice = web3.utils.fromWei(getB);

    return cmnPrice;
  }
  //
  //
  //
  //
  //
  //
  public async loadTokenContract() {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      const contract = new web3.eth.Contract(
        PointAbi as any,
        ContractAddressPoint,
      );
      return contract;
    } catch (err) {
      console.log(err);
    }
  }

  async getCurrentAccount() {
    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      const account = web3.eth.accounts.privateKeyToAccount(
        process.env.PRIVATE_KAY,
      );
      return account;
    } catch (err) {
      console.log(err);
    }
  }

  async getGasPrice() {
    const web3 = new Web3(process.env.CRYPTO_URL);
    const gas = await web3.eth.getGasPrice();
    return await web3.utils.toWei(gas, 'ether');
  }

  public async getFreeTokens() {
    try {
      const contract = await this.loadTokenContract();
      const account = await this.getCurrentAccount();
      const gas = await this.getGasPrice();

      const result = await contract.methods.getFreeCmnToken().send({
        from: account.address,
        gasPrice: gas,
      });

      return result;
    } catch (error) {
      throw error;
    }
  }

  public async connectWallet() {
    // Get the current chain ID
    const id: number | string = await this.getChainId();

    try {
      const web3 = new Web3(process.env.CRYPTO_URL);
      // Check if the current chain ID matches the expected ID
      if (id != '0x80001') {
        // If not, prompt the user to switch to the expected network
        // await this.web3.currentProvider.send({
        // method: 'wallet_addEthereumChain',
        //   params: [
        //     {
        //       chainId: '0x80001',
        //       chainName: process.env.CHAIN_NAME,
        //       rpcUrls: [process.env.RPC_URL],
        //       blockExplorerUrls: [process.env.BLOCK_EXPLORER_URL],
        //       nativeCurrency: {
        //         name: process.env.CURRENCY_NAME,
        //         symbol: process.env.CURRENCY_SYMBOL,
        //         decimals: process.env.CURRENCY_DECIMALS,
        //       },
        //     },
        //   ],
        // });
      }

      // Request access to the user's wallet
      const accounts = await (web3.eth as any).request({
        method: 'eth_requestAccounts',
      });

      console.log('Connected Successfully');
    } catch (err) {
      console.log(err);
    }
  }

  async getChainId() {
    const web3 = new Web3(process.env.CRYPTO_URL);
    let id;
    await web3.eth.net
      .getId()
      .then((chainId: number) => {
        id = chainId;
      })
      .catch((error: string) => console.error(error));
    return id;
  }
}
