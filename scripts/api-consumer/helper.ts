// @ts-ignore
import { ethers } from "hardhat";
import { LinkToken } from "../../typechain-types/contracts/test/LinkToken";

export async function fundWithLink(
    _contractAddr: string,
    _amountToFund: string,
    _linkTokenAddr?: string,
    _account?: string
) {
    const accounts = await ethers.getSigners();
    const signer = accounts[0];
    const LinkToken: LinkToken = await ethers.getContract("LinkToken");
    //const linkTokenContract = new ethers.Contract(_linkTokenAddr, LinkToken.interface, signer);

    //const fundWithLinkTx = await linkTokenContract.transfer(_contractAddr, _amountToFund);
    //const fundWithLinkTx = await LinkToken.transfer(_contractAddr, _amountToFund);
    const fundWithLinkTx = await LinkToken.transfer(_contractAddr, "10000000000000");
    await fundWithLinkTx.wait(1);
}

fundWithLink("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266", "100000000000")
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });
