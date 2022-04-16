// @ts-ignore
import { ethers } from "hardhat";
import { PriceConsumerV3 } from "../../typechain-types/contracts/PriceConsumerV3";

export async function getPriceFeedProxy(_pair: string): Promise<string> {
    const priceConsumerV3: PriceConsumerV3 = await ethers.getContract("PriceConsumerV3");
    const proxy: string = await priceConsumerV3.getPriceFeedProxy(_pair);

    console.log(`Price feed proxy of ${_pair} is\n${proxy}`);

    return proxy;
}

getPriceFeedProxy("ETH/USD")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
