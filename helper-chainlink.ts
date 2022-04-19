export const linkConfig = {
    apiConsumer: [
        {
            id: "",
            name: "",
            description: "",
            url: "",
            path: "",
            http: 0,
            jobId: "d5270d1c311941d0b08bead21fea7747",
            linkTokenAddr: "0xa36085F69e2889c224210F603D836748e7dC0088",
            oracle: "0xa36085F69e2889c224210F603D836748e7dC0088",
            payment: "100000000000000000", // 0.1
            callback: "",
            isMultipliableOutput: false || true,
            callbackFunctionSignature: "",
        },
    ],
    priceConsumerV3: [
        {
            pair: "",
        },
    ],
};

export const networkConfig = {
    hardhat: {
        name: "hardhat",
        chainId: 31337,
        verify: false,
    },
    localhost: {
        name: "localhost",
        chainId: 31337,
        verify: false,
    },
    mainnet: {
        name: "mainnet",
        chainId: 1,
        verify: false,
    },
    rinkeby: {
        name: "rinkeby",
        chainId: 4,
        verify: false,
    },
    kovan: {
        name: "kovan",
        chainId: 42,
        verify: false,
        chainlink: {
            apiConsumer: [
                {
                    id: "",
                    name: "",
                    description: "",
                    url: "",
                    path: "",
                    http: 0,
                    jobId: "d5270d1c311941d0b08bead21fea7747",
                    linkTokenAddr: "0xa36085F69e2889c224210F603D836748e7dC0088",
                    oracle: "0xa36085F69e2889c224210F603D836748e7dC0088",
                    payment: "100000000000000000", // 0.1
                    callback: "",
                    isMultipliableOutput: false || true,
                    callbackFunctionSignature: "",
                },
            ],
            priceConsumerV3: [
                {
                    pair: "ETH/USDT",
                    proxy: "0x10900f50d1bC46b4Ed796C50A4Cc63791CaF7501",
                },
            ],
        },
    },
    polygon: {
        name: "polygon",
        chainId: 137,
        verify: false,
    },
};
