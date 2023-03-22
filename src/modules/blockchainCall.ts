import pointABI from './web3/smart_contracts/point.abi.json';

import Web3 from 'web3';
const rpc = 'https://rpc-mumbai.maticvigil.com/';
const web3 = new Web3(rpc);
import { ContractAddressPoint } from './web3/constants/smart_contract_address';
const contract = new web3.eth.Contract(pointABI as any, ContractAddressPoint);
const _fromAddress = '0x779f4D42C30370382D8cb58f17D20373BD727c88';
const _fromKey =
  'fead8d9413ef183f939a7904fc84e59334b4e6f59cc155384c871538291835de';

export async function sendData() {
  try {
    console.log('Initiating Transaction ');

    const transactionABI = contract.methods
      .mint('0xf922e3223567AeB66e6986cb09068B1B879B6ccc', 1000)
      .encodeABI();
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
    console.log('result: ', sentTx);
    return sentTx.status;
  } catch (e) {
    console.log(e);
  }
}
