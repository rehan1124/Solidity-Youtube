// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "contracts/PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) addressToMoneyFunded;

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "Minimum 50 USD is required."
        );
        funders.push(msg.sender);
        addressToMoneyFunded[msg.sender] = msg.value;
    }
}
