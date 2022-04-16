// @ts-ignore
import { ethers } from "hardhat";
import { PriceConsumerV3 } from "../../typechain-types/contracts/PriceConsumerV3";

export async function setPriceFeedProxy(_pair: string, _priceFeedProxy: string): Promise<void> {
    const priceConsumerV3: PriceConsumerV3 = await ethers.getContract("PriceConsumerV3");

    const setPriceFeedProxyTx = await priceConsumerV3.setPriceFeedProxy(_pair, _priceFeedProxy);

    await setPriceFeedProxyTx.wait(1);
}

setPriceFeedProxy("ETH/USD", "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
