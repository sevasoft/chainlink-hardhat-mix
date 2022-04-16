// SPDX-Licence-Identifier: MIT
pragma solidity >=0.8.7 <0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 is Ownable {
    mapping(string => address) public currencyPairToPriceFeedProxy;

    /**
     * Set price feed proxy.
     * @dev Provide to reference contracts in order to get a necessary proxy
     * @dev address for specific a Blockchain network:
     * @dev https://docs.chain.link/docs/reference-contracts/
     * @param _pair Currency pair. Recommended style: ETH/USD
     * @param _priceFeedProxy Proxy address.
     */
    function setPriceFeedProxy(string memory _pair, address _priceFeedProxy)
        public
        onlyOwner
    {
        currencyPairToPriceFeedProxy[_pair] = _priceFeedProxy;
    }

    /**
     * Get price feed proxy address.
     * @param _pair Currency pair (e.g. ETH/USD).
     * @return Proxy address of a provided currency pair.
     */
    function getPriceFeedProxy(string memory _pair)
        public
        view
        returns (address)
    {
        return currencyPairToPriceFeedProxy[_pair];
    }

    /**
     * Get latest price of a particular aggregator.
     * @param _pair Currency pair (e.g. ETH/USD).
     * @return Latest price.
     */
    function getLatestPrice(string memory _pair)
        public
        view
        returns (uint256)
    {
        address proxy = currencyPairToPriceFeedProxy[_pair];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(proxy);

        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        return uint256(price);
    }

    /**
     * Get decimals of a particular aggregator.
     * @param _pair Currency pair (e.g. ETH/USD).
     * @return Decimals (usually 8 if x/USD or 18 if x/ETH; see docs).
     */
    function getDecimals(string memory _pair)
        public 
        view
        returns (uint8)
    {
        address proxy = currencyPairToPriceFeedProxy[_pair];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(proxy);

        return priceFeed.decimals();
    }
}
