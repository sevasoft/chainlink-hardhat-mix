import { DeployFunction } from "hardhat-deploy/types";
import { getNamedAccounts, deployments, network } from "hardhat";
import { MOCKS } from "../helper-hardhat";

const deployMocks: DeployFunction = async () => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId: number | undefined = network.config.chainId;

    if (chainId === 31337) {
        log(`Local network detected! Deploying mocks ...`);

        const linkToken = await deploy("LinkToken", {
            from: deployer,
            log: true,
        });

        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [
                MOCKS.chainlink.decimalsEthUsd,
                MOCKS.chainlink.initialPriceFeedValueEthUsd,
            ],
        });

        await deploy("MockOracle", {
            from: deployer,
            log: true,
            args: [linkToken.address],
        });

        await deploy("VRFCoordinatorV2Mock", {
            from: deployer,
            log: true,
            args: [MOCKS.chainlink.pointOneLinkFee, MOCKS.chainlink.linkPerGas],
        });

        log("Mocks deployed!");
    }
};

export default deployMocks;
deployMocks.tags = ["all", "mocks", "main"];
