import { BigNumber } from "ethers";
// @ts-ignore
import { ethers } from "hardhat";
import { PriceConsumerV3 } from "../../typechain-types/contracts/PriceConsumerV3";

export async function getLatestPrice(_pair: string): Promise<BigNumber> {
    const priceConsumerV3: PriceConsumerV3 = await ethers.getContract("PriceConsumerV3");
    const latestPrice: BigNumber = await priceConsumerV3.getLatestPrice(_pair);

    console.log(`Latest price of ${_pair} is\n${latestPrice}`);

    return latestPrice;
}

getLatestPrice("ETH/USD")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
