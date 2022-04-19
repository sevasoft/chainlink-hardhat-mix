//// @ts-ignore
//import { ethers } from "hardhat";
//
//export async function fundWithLink(
//    _contractAddr: string,
//    _amountToFund: string,
//    _linkTokenAddr: string,
//    _account?: string
//) {
//    const accounts = await ethers.getSigners();
//    const signer = accounts[0];
//    const LinkToken = await ethers.getContract("LinkToken");
//    //const linkTokenContract = new ethers.Contract(_linkTokenAddr, LinkToken.interface, signer);
//
//    //const fundWithLinkTx = await linkTokenContract.transfer(_contractAddr, _amountToFund);
//    const fundWithLinkTx = await LinkToken.transfer(_contractAddr, _amountToFund);
//    await fundWithLinkTx.wait(1);
//}
