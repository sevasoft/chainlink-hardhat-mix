// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


error ApiIdAlreadyExists(uint256 _apiId);

/**
 * @title Only on Rinkeby network
 */
contract APIConsumer is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;
    using Counters for Counters.Counter;

    Counters.Counter private _apiIdCounter;

    enum HTTP {
        GET_BYTES32,    // HTTP GET | JSON PARSE | -        | ETH BYTES
        GET_INT256,     // HTTP GET | JSON PARSE | MULTIPLY | ETH INT 2
        GET_UINT256,    // HTTP GET | JSON PARSE | MULTIPLY | ETH UINT 
        GET_BOOL,       // HTTP GET | JSON PARSE | -        | ETH BOOL
        POST_BYTES32    // HTTP POST| JSON PARSE | -        | ETH BYTES 32
    }

    struct LINK {
        address oracle;
        uint256 payment;
        bytes32 jobId;
        address callback;
        bool multiplyOutput;
        bytes4 callbackFunctionSignature; 
    }


    struct API {
        uint256 id;
        string name;
        string description;
        string url;
        string path;
        HTTP http;
        LINK link;
    }


    int toWeiInt = 10**18;
    uint toWeiUint = 10**18;


    mapping(uint256 => API) public s_APIs;      // s_APIs Scroll through


    constructor(
        //address _linkToken,
        //address _oracle
    ) {
        //setChainlinkToken(_linkToken);  // 0xa36085F69e2889c224210F603D836748e7dC0088
        //setChainlinkOracle(_oracle);    // 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8

        string memory name = "Latest CPI in Belgium";
        string memory description = "Get latest CPI in Belgium in the form of int256. Data is based on the Beligan statistical office.";
        string memory url = "https://bestat.statbel.fgov.be/bestat/api/views/876acb9d-4eae-408e-93d9-88eae4ad1eaf/result/JSON";
        string memory path = "facts.-1.Consumptieprijsindex";
        HTTP http = HTTP.GET_INT256;
        address oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        uint256 payment = LINK_DIVISIBILITY / 10;
        bytes32 jobId = bytes32("83ba9ddc927946198fbd0bf1bd8a8c25");
        address callback = address(this);
        bool multiplyOutput = true;
        bytes4 callbackFunctionSignature = this.resInt256.selector;

        setAPI(
            name,
            description,
            url,
            path,
            http,
            oracle,
            payment,
            jobId,
            callback,
            multiplyOutput,
            callbackFunctionSignature
        );
    }


    function setAPI(
        string memory _name,
        string memory _description,
        string memory _url,
        string memory _path,
        HTTP _http,
        address _oracle,
        uint256 _payment,
        bytes32 _jobId,
        address _callback,
        bool _multiplyOutput,
        bytes4 _callbackFunctionSignature
    )
        public
        onlyOwner
    {
        _apiIdCounter.increment();
        uint256 newId = _apiIdCounter.current();

        API storage api = s_APIs[newId];

        api.id = newId;
        api.name = _name;
        api.description = _description;
        api.url = _url;
        api.path = _path;
        api.http = _http;
        /* Chainlink */
        api.link.oracle = _oracle;
        api.link.payment = _payment;
        api.link.jobId = _jobId;
        api.link.callback = _callback;
        api.link.multiplyOutput = _multiplyOutput;
        api.link.callbackFunctionSignature = _callbackFunctionSignature;
    }


    function request(uint256 _apiId) public onlyOwner returns (bytes32 requestId)
    {
        API memory api = s_APIs[_apiId];

        Chainlink.Request memory req = buildChainlinkRequest(
            api.link.jobId,
            api.link.callback,
            api.link.callbackFunctionSignature
        );
        
        req.add("get", api.url);
        req.add("path", api.path);

        if (api.link.multiplyOutput && api.http == HTTP.GET_INT256) {
            req.addInt("times", toWeiInt);
        }

        if (api.link.multiplyOutput && api.http == HTTP.GET_UINT256) {
            req.addUint("times", toWeiUint);
        }

        return sendChainlinkRequestTo(api.link.oracle, req, api.link.payment);
    }

    function resBytes32(bytes32 _requestId, bytes32 _res)
        public 
        recordChainlinkFulfillment(_requestId)
        returns (bytes32)
    {
        return _res;
    }
    
    /**
     * param _url URL (e.g. https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD).
     * param _path Path of the desired data in the API  (e.g. RAW.ETH.USD.VOLUME24HOUR).
     * return API request ID.
     */
    
    /**
     * Receive the  in the form of uint256
     * @dev recordChainlinkFulfillment: Ensure that the sender and requestId are valid.
     */ 
    function resInt256(bytes32 _requestId, int256 _res)
        public
        recordChainlinkFulfillment(_requestId)
        returns (int256)
    {
        return _res;
    }


    function resUint256(bytes32 _requestId, uint256 _res)
        public 
        recordChainlinkFulfillment(_requestId)
        returns (uint256)
    {
        return _res;
    }


    function resBool(bytes32 _requestId, bool _res)
        public
        recordChainlinkFulfillment(_requestId)
        returns (bool)
    {
        return _res;
    }


    function withdrawLink() public onlyOwner {
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }

    // function stringToBytes32(string memory source) public pure returns (bytes32 result) {
    //     bytes memory tempEmptyStringTest = bytes(source);
    //     if (tempEmptyStringTest.length == 0) {
    //         return 0x0;
    //     }

    //     assembly {
    //         result := mload(add(source, 32))
    //     }
    // }


}
