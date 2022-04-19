import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import {
    BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    isVerifiableContract,
    verify,
} from "../helper-hardhat";

const deployAPIConsumer: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments } = hre;
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const linkTokenAddrKovan: string = "0xa36085F69e2889c224210F603D836748e7dC0088";
    const constructorArgs: any[] = [linkTokenAddrKovan];

    const apiConsumer = await deploy("APIConsumer", {
        from: deployer,
        args: constructorArgs,
        log: true,
        waitConfirmations: BLOCK_CONFIRMATIONS_FOR_VERIFICATION,
    });

    if (await isVerifiableContract()) {
        await verify(apiConsumer.address, constructorArgs);
    }
};

export default deployAPIConsumer;
