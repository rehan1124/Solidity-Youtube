// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) addressToMoneyFunded;

    function getPrice() public view returns (uint256) {
        // Contract address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // Price of ETH in terms of USD
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethInUsd = (ethPrice * ethAmount) * 1e18;
        return ethInUsd;
    }

    function fund() public payable {
        require(
            getConversionRate(msg.value) >= minimumUsd,
            "Minimum 50 USD is required."
        );
        funders.push(msg.sender);
        addressToMoneyFunded[msg.sender] = msg.value;
    }
}
