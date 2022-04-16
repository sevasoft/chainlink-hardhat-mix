// @ts-ignore
import { ethers } from "hardhat";
import { PriceConsumerV3 } from "../../typechain-types/contracts/PriceConsumerV3";

export async function getDecimals(_pair: string): Promise<number> {
    const priceConsumerV3: PriceConsumerV3 = await ethers.getContract("PriceConsumerV3");
    const decimals: number = await priceConsumerV3.getDecimals(_pair);

    console.log(`${decimals}`);

    return decimals;
}

getDecimals("ETH/USD")
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });
