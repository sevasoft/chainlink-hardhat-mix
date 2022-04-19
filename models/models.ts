import { BigNumber } from "ethers";

/* ./hardhat.config.ts */

export type RpcUrl = {
    mainnet: string;
    rinkeby: string;
    kovan: string;
    polygon: string;
};

export type Explorer = {
    etherscan: string;
    polygonscan: string;
};

export type NetworkConfigItem = {
    name: string;
    chainId: number;
    /* chainlink */
    fundAmount?: BigNumber;
    keyHash?: string;
    linkTokenAddr?: string;
    keepersUpdateIntervalInMin?: string;
    /* chainlink APIConsumer */
    oracleAddr?: string;

    linkFee?: string;
    verify: boolean;
};

export type NetworkConfigMap = {
    [network: string]: NetworkConfigItem;
};

/* ./helper-hardhat.ts */

export type BlockchainEnvironments = {
    local: string[];
    test: string[];
    main: string[];
};

/* contract constructor */
