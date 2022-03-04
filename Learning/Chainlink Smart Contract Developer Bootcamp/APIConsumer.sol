pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {

    uint256 public volume;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // Network: Kovan
    // Chainlink Oracle - 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
    // Chainlink jobId - 29fa9aa13bf1468788b7cc4a500a45b8
    // Fee: 0.1 LINK
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10**18; //0.1 LINK 
    }

    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        //the url to perform the GET request 
        request.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");

        //find the data in the API
        request.add("path", "RAW.ETH.USD.VOLUME24HOUR");

        //remove the decimals 
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);

        //send the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    //receiving the response
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        volume = _volume;
    }

}
