///// @ts-ignore
///import { ethers } from "hardhat";
///import { APIConsumer } from "../../typechain-types/contracts/APIConsumer";
///import { fundWithLink } from "./helper";
///
///export async function request(_apiId: number) {
///    const apiConsumer: APIConsumer = await ethers.getContract("APIConsumer");
///    const linkToken = await ethers.getContract("LinkToken");
///    await fundWithLink(apiConsumer.address, "100000000000000000", linkToken.address);
///    const requestTx = await apiConsumer.request(_apiId);
///    await requestTx.wait(1);
///}
///
///request(1)
///    .then(() => process.exit(0))
///    .catch((err) => {
///        console.error(err);
///        process.exit(1);
///    });
