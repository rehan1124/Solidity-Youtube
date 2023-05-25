// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageList;
    mapping(SimpleStorage => bool) public isSimpleStoragePresent;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageList.push(simpleStorage);
        isSimpleStoragePresent[simpleStorage] = true;
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)
        public
    {
        SimpleStorage simpleStorage = simpleStorageList[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage simpleStorage = simpleStorageList[_simpleStorageIndex];
        return simpleStorage.retrieve();
    }
}
