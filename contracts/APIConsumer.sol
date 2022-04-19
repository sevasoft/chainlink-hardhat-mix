// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract APIConsumer is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;
    using Counters for Counters.Counter;


    Counters.Counter private _apiIdCounter;


    // Events. Change if you would like to.
    event DataFulfilledInt(int256 _res);
    event DataFulfilledUint(uint256 _res);
    event DataFulfilledBytes32(bytes32 _res);
    event DataFulfilledBool(bool _res);


    enum HTTP {
        GET_BYTES32,        // HTTP GET | JSON PARSE | -        | ETH BYTES
        GET_INT256,         // HTTP GET | JSON PARSE | MULTIPLY | ETH INT 2
        GET_UINT256,        // HTTP GET | JSON PARSE | MULTIPLY | ETH UINT 
        GET_BOOL,           // HTTP GET | JSON PARSE | -        | ETH BOOL
        POST_BYTES32        // HTTP POST| JSON PARSE | -        | ETH BYTES 32
    }


    struct LINK {
        address oracle;
        uint256 payment;
        bytes32 jobId;
        address callback;
        bool isMultipliableOutput;
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


    // Responses. Change if you would like to.
    bytes32 public resBytes;
    int256 public resInt;
    uint256 public resUint;
    bool public resBool;


    mapping(uint256 => API) public s_APIs;      // s_ Scroll through


    constructor(
        address _linkToken
    ) {
        setChainlinkToken(_linkToken);  // Kovan: 0xa36085F69e2889c224210F603D836748e7dC0088
        setExampleAPI();
    }

    function setExampleAPI() public {
        // Example of the setup.
        string memory name = "Latest CPI in Belgium";
        string memory description = "Get latest CPI in Belgium in the form of int256. Data is based on the Beligan statistical office.";
        string memory url = "https://bestat.statbel.fgov.be/bestat/api/views/876acb9d-4eae-408e-93d9-88eae4ad1eaf/result/JSON";
        string memory path = "facts,5,Consumptieprijsindex";
        HTTP http = HTTP.GET_UINT256;
        /* Chainlink */
        address oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        uint256 payment = LINK_DIVISIBILITY / 10;
        bytes32 jobId = bytes32("d5270d1c311941d0b08bead21fea7747");
        address callback = address(this);
        bool isMultipliableOutput = true;
        bytes4 callbackFunctionSignature = this.responseUint.selector;

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
            isMultipliableOutput,
            callbackFunctionSignature
        );
    }


    function getApiById(uint256 _id) public view returns (API memory) {
        return s_APIs[_id];
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
        bool _isMultipliableOutput,
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
        api.link.isMultipliableOutput = _isMultipliableOutput;
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

        req = _multiplyIfRequired(api, req);

        return sendChainlinkRequestTo(api.link.oracle, req, api.link.payment);
    }


    function _multiplyIfRequired(API memory _api, Chainlink.Request memory _req)
        internal
        pure
        returns (Chainlink.Request memory) 
    {
        if (_api.link.isMultipliableOutput && _api.http == HTTP.GET_INT256) {
            _req.addInt("times", 1000000000000000000);
        }

        if (_api.link.isMultipliableOutput && _api.http == HTTP.GET_UINT256) {
            _req.addUint("times", 1000000000000000000);
        }

        return _req;
    }


    function responseBytes32(bytes32 _requestId, bytes32 _res)
        public 
        recordChainlinkFulfillment(_requestId)
    {
        resBytes = _res;
        emit DataFulfilledBytes32(resBytes);
    }
    
    
    /**
     * Receive the response in the form of int256.
     * @dev recordChainlinkFulfillment: Ensure that the sender and requestId are valid.
     * @dev validateChainlinkCallback(_requestId) Could be used as well instead of that modifier.
     */ 
    function responseInt256(bytes32 _requestId, int256 _res)
        public
        recordChainlinkFulfillment(_requestId)
    {
        resInt = _res;
        emit DataFulfilledInt(resInt);
    }


    function responseUint(bytes32 _requestId, uint256 _res)
        public 
        recordChainlinkFulfillment(_requestId)
    {
        resUint = _res;
        emit DataFulfilledUint(resUint);
    }


    function responseBool(bytes32 _requestId, bool _res)
        public
        recordChainlinkFulfillment(_requestId)
    {
        resBool = _res;
        emit DataFulfilledBool(resBool);
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
