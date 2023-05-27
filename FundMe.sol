// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "contracts/PriceConverter.sol";

contract FundMe {
    // --- State variables ---
    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) addressToMoneyFunded;

    address public owner;

    // --- Constructor ---

    constructor() {
        owner = msg.sender;
    }

    // --- Modifiers ---

    modifier managerOnly() {
        require(msg.sender == owner, "Only manager can withdraw funds.");
        _;
    }

    // --- Functions ---

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "Minimum 50 USD is required."
        );
        funders.push(msg.sender);
        addressToMoneyFunded[msg.sender] += msg.value;
    }

    function withdraw() public payable managerOnly {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex += 1
        ) {
            address funder = funders[funderIndex];
            addressToMoneyFunded[funder] = 0;
        }

        funders = new address[](0);

        // Using transfer()
        // payable(msg.sender).transfer(address(this).balance);

        // Using send()
        bool sendStatus = payable(msg.sender).send(address(this).balance);
        require(sendStatus, "Withdrawal failed.");

        // Using call()
        (bool isWithdrawalSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(isWithdrawalSuccess, "Withdrawal failed.");
    }
}
