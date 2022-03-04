pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal ethPrice;
    AggregatorV3Interface internal linkPrice;
    AggregatorV3Interface internal manaETHPrice;

    // Kovan ETH/USD address: 0x9326BFA02ADD2366b30bacB125260Af641031331
    // Kovan LINK/USD address: 0x396c5E36DD0a0F5a5D33dae44368D4193f69a1F0
    // Kovan MANA/ETH address: 0x1b93D8E109cfeDcBb3Cc74eD761DE286d5771511
    constructor() public {
        ethPrice = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        linkPrice = AggregatorV3Interface(0x396c5E36DD0a0F5a5D33dae44368D4193f69a1F0);
        manaETHPrice = AggregatorV3Interface(0x1b93D8E109cfeDcBb3Cc74eD761DE286d5771511);
    }

    function getLatestETHPrice() public view returns(int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = ethPrice.latestRoundData();
        return price;
    }

    function getLatestLINKPrice() public view returns(int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = linkPrice.latestRoundData();
        return price;
    }

    function getLatestMANAPrice() public view returns(int) {
        (
            uint roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = manaETHPrice.latestRoundData();
        return price;
    }

    function getETHTimestamp() public view returns(uint) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = ethPrice.latestRoundData();
        return timeStamp;
    }

}
